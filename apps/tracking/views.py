from django.shortcuts import get_object_or_404
from django.db import models
from django.db.models import Avg, Count, Q
from django.utils import timezone
from rest_framework import generics, mixins, permissions, status, views, viewsets
from rest_framework.response import Response

import apps.tracking.tasks as tracking_tasks

from apps.tracking.models import (
    Message, Mood, Relative, Suggestion, MoodCheckIn, ChatConversation, 
    ChatMessage, MoodNotification, NotificationTemplate, GratitudeEntry,
    Workspace, WorkspaceMembership, WorkspaceSupportRequest
)
from apps.users.models import Brain_Health_Score, Send_To_Relative, Suggestion_Therapist, Therapist, User
from apps.users.serializers import UserSerializer

from .serializers import (
    MoodSerializer, RelativeSerializer, SuggestionSerializer, MoodCheckInSerializer,
    ChatConversationSerializer, ChatMessageSerializer, MoodNotificationSerializer,
    GratitudeEntrySerializer, NotificationTemplateSerializer,
    WorkspaceSerializer, WorkspaceMembershipSerializer, WorkspaceSupportRequestSerializer
)
from rest_framework.decorators import action
from rest_framework.request import Request



class RelativeList(
    mixins.ListModelMixin,
    mixins.CreateModelMixin,
    mixins.RetrieveModelMixin,
    mixins.UpdateModelMixin,
    mixins.DestroyModelMixin,
    viewsets.GenericViewSet,
):
    serializer_class = RelativeSerializer
    permission_classes = [permissions.IsAuthenticated]
    lookup_field = "pk"

    def get_queryset(self):
        return Relative.objects.filter(user=self.request.user)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(user=request.user)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @action(detail=False, methods=['post'])
    def check_user(self, request):
        email = request.data.get('email')
        try:
            user = User.objects.get(email=email)
            serializer = UserSerializer(user, context={'request': request})
            return Response(serializer.data, status=200)
        except User.DoesNotExist:
            return Response({'error': 'User does not exist.'}, status=404)

class MoodListView(generics.ListAPIView):
    serializer_class = MoodSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        # Retrieve all moods
        return Mood.objects.all()
    


class RelativeViewSet(viewsets.ModelViewSet):
    queryset = Relative.objects.all()
    serializer_class = RelativeSerializer
    permission_classes = [permissions.IsAuthenticated,]

    def get_queryset(self):
        user = self.request.user
        return Relative.objects.filter(user=user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user) 

    
class SuggestionByMoodView(views.APIView):
    serializer_class = SuggestionSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        mood_name = request.query_params.get("mood", "").lower()
        mood = get_object_or_404(Mood, name__iexact=mood_name)

        suggestion = Suggestion.objects.filter(mood=mood).order_by("?").first()
        if not suggestion:
            return Response([], status=status.HTTP_204_NO_CONTENT)

        # Suggestions are private. Never queue a disclosure as a side effect of GET.
        serializer = self.serializer_class(suggestion)
        return Response(serializer.data, status=status.HTTP_200_OK)


# ============ MOOD CHECK-IN VIEWS ============
class MoodCheckInViewSet(viewsets.ModelViewSet):
    """
    API for recording daily mood check-ins with multiple mood selections
    """
    serializer_class = MoodCheckInSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return MoodCheckIn.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def today_check_in(self, request):
        """Get or create today's mood check-in"""
        from django.utils.timezone import now
        today = now().date()
        
        check_in, created = MoodCheckIn.objects.get_or_create(
            user=request.user,
            date=today
        )
        
        # If we're updating moods
        if 'mood_ids' in request.data:
            check_in.moods.clear()
            check_in.moods.set(request.data.get('mood_ids', []))
        
        # Update notes if provided
        if 'notes' in request.data:
            check_in.notes = request.data.get('notes')
            check_in.save()
        
        serializer = self.get_serializer(check_in)
        return Response(serializer.data, status=status.HTTP_201_CREATED if created else status.HTTP_200_OK)
    
    @action(detail=False, methods=['get'])
    def analytics(self, request):
        """Get mood analytics for the user"""
        user = request.user
        check_ins = MoodCheckIn.objects.filter(user=user)
        
        # Get last 7 days
        from datetime import timedelta
        from django.utils.timezone import now
        last_7_days = now().date() - timedelta(days=7)
        recent_check_ins = check_ins.filter(date__gte=last_7_days)
        
        # Calculate average score
        moods = Mood.objects.filter(check_ins__in=recent_check_ins).distinct()
        avg_score = sum(mood.score for mood in moods) / len(moods) if moods else 0
        
        return Response({
            'total_check_ins': check_ins.count(),
            'last_7_days_check_ins': recent_check_ins.count(),
            'average_mood_score': avg_score,
            'most_recent': MoodCheckInSerializer(check_ins.first()).data if check_ins.exists() else None
        })


# ============ CHAT VIEWS ============
class ChatConversationViewSet(viewsets.ModelViewSet):
    """
    API for managing chat conversations with AI counselor
    """
    serializer_class = ChatConversationSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return ChatConversation.objects.filter(
            models.Q(user=self.request.user) | models.Q(therapist=self.request.user)
        ).distinct()
    
    def perform_create(self, serializer):
        therapist_id = self.request.data.get('therapist')
        therapist = User.objects.filter(id=therapist_id, is_therapist=True, is_active=True).first() if therapist_id else None
        if therapist_id and therapist is None:
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'therapist': 'Active therapist not found.'})
        serializer.save(user=self.request.user, therapist=therapist)
    
    @action(detail=True, methods=['post'])
    def send_message(self, request, pk=None):
        """Send a message in a conversation"""
        conversation = self.get_object()
        if request.user not in [conversation.user, conversation.therapist]:
            return Response({'error': 'Conversation access denied.'}, status=status.HTTP_403_FORBIDDEN)
        message_text = request.data.get('message')
        
        if not message_text:
            return Response({'error': 'Message text is required'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Save user message
        sender = 'therapist' if conversation.therapist_id == request.user.id else 'user'
        user_message = ChatMessage.objects.create(
            conversation=conversation,
            sender=sender,
            message_text=message_text
        )
        
        # TODO: Call AI service (OpenAI) to generate bot response
        if conversation.therapist is None:
            ChatMessage.objects.create(conversation=conversation, sender='bot', message_text="Thank you for sharing. I'm here to help. Can you tell me more about what you're feeling?")
        
        # Return updated conversation
        serializer = self.get_serializer(conversation)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def end_conversation(self, request, pk=None):
        """End a chat conversation"""
        conversation = self.get_object()
        conversation.is_active = False
        conversation.ended_at = timezone.now()
        conversation.save()
        
        serializer = self.get_serializer(conversation)
        return Response(serializer.data)


class ChatMessageListView(generics.ListAPIView):
    """Get messages from a specific conversation"""
    serializer_class = ChatMessageSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        conversation_id = self.kwargs.get('conversation_id')
        return ChatMessage.objects.filter(conversation_id=conversation_id, conversation__user=self.request.user)


# ============ NOTIFICATION VIEWS ============
class MoodNotificationViewSet(viewsets.ReadOnlyModelViewSet):
    """
    View and manage mood notifications sent to relatives
    """
    serializer_class = MoodNotificationSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return MoodNotification.objects.filter(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def send_to_relatives(self, request):
        """Send mood notifications to relatives"""
        mood_check_in_id = request.data.get('mood_check_in_id')
        
        try:
            mood_check_in = MoodCheckIn.objects.get(id=mood_check_in_id, user=request.user)
        except MoodCheckIn.DoesNotExist:
            return Response({'error': 'Mood check-in not found'}, status=status.HTTP_404_NOT_FOUND)
        
        relatives = Relative.objects.filter(user=request.user)
        notifications_created = []
        
        for mood in mood_check_in.moods.all():
            template = NotificationTemplate.objects.filter(mood=mood).first()
            message_text = (
                template.template_text
                if template
                else f"{request.user.name} is feeling {mood.name.lower()} today. Please check in and offer support."
            )
            notification_type = template.notification_type if template else "neutral"

            for relative in relatives:
                notification = MoodNotification.objects.create(
                    user=request.user,
                    relative=relative,
                    mood_check_in=mood_check_in,
                    message_text=message_text,
                    notification_type=notification_type
                )
                notifications_created.append(notification)
        
        serializer = MoodNotificationSerializer(notifications_created, many=True)
        return Response({
            'message': f'Notifications sent to {len(notifications_created)} relatives',
            'notifications': serializer.data
        })


class NotificationTemplateListView(generics.ListAPIView):
    """Get notification templates"""
    serializer_class = NotificationTemplateSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = NotificationTemplate.objects.all()


class NotificationDeliveryViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAuthenticated]

    @action(detail=False, methods=['post'])
    def send_email(self, request):
        recipient_email = request.data.get('recipient_email')
        subject = request.data.get('subject') or 'WeHappy Notification'
        message = request.data.get('message') or 'You have a new notification.'

        if not recipient_email:
            return Response({'error': 'recipient_email is required.'}, status=status.HTTP_400_BAD_REQUEST)

        tracking_tasks.send_email_notification(recipient_email, subject, message)
        return Response({'message': 'Email notification sent successfully.'}, status=status.HTTP_200_OK)

    @action(detail=False, methods=['post'])
    def send_whatsapp(self, request):
        to_phone = request.data.get('to_phone')
        message = request.data.get('message') or 'You have a new notification from WeHappy.'

        if not to_phone:
            return Response({'error': 'to_phone is required.'}, status=status.HTTP_400_BAD_REQUEST)

        sent = tracking_tasks.send_whatsapp_message(to_phone, message)
        if not sent:
            return Response({'message': 'WhatsApp message skipped because Twilio is not configured.'}, status=status.HTTP_200_OK)

        return Response({'message': 'WhatsApp notification sent successfully.'}, status=status.HTTP_200_OK)


# ============ GRATITUDE VIEWS ============
class GratitudeEntryViewSet(viewsets.ModelViewSet):
    """
    API for managing daily gratitude entries
    """
    serializer_class = GratitudeEntrySerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return GratitudeEntry.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['get'])
    def today(self, request):
        """Get or create today's gratitude entry"""
        from django.utils.timezone import now
        today = now().date()
        
        gratitude = GratitudeEntry.objects.filter(user=request.user, date=today).first()
        
        if gratitude:
            serializer = self.get_serializer(gratitude)
            return Response(serializer.data)
        
        return Response({
            'message': 'No gratitude entry for today. Create one now!',
            'date': today
        }, status=status.HTTP_204_NO_CONTENT)


class WorkspaceViewSet(viewsets.ModelViewSet):
    """Workspaces for teams, families, and partner circles."""
    serializer_class = WorkspaceSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        owned = Workspace.objects.filter(owner=user)
        member = Workspace.objects.filter(memberships__user=user, memberships__status='approved')
        return (owned | member).distinct()

    def perform_create(self, serializer):
        workspace = serializer.save(owner=self.request.user)
        if workspace.workspace_type == Workspace.WORKSPACE_TYPE_OFFICE:
            workspace.subscription_plan = Workspace.SUBSCRIPTION_PLAN_OFFICE_20
            workspace.save(update_fields=['subscription_plan'])
        WorkspaceMembership.objects.create(
            workspace=workspace,
            user=self.request.user,
            role=WorkspaceMembership.ROLE_OWNER,
            designation='Owner' if workspace.workspace_type != Workspace.WORKSPACE_TYPE_OFFICE else 'Admin',
            status=WorkspaceMembership.STATUS_APPROVED,
            joined_at=timezone.now()
        )

    @action(detail=True, methods=['get'])
    def office_dashboard(self, request, pk=None):
        workspace = self.get_object()

        if workspace.workspace_type != Workspace.WORKSPACE_TYPE_OFFICE:
            return Response(
                {'error': 'This dashboard is only available for office workspaces.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        is_owner = request.user == workspace.owner
        is_manager = WorkspaceMembership.objects.filter(
            workspace=workspace,
            user=request.user,
            role__in=[WorkspaceMembership.ROLE_OWNER, WorkspaceMembership.ROLE_MANAGER],
            status=WorkspaceMembership.STATUS_APPROVED,
        ).exists()

        if not (is_owner or is_manager):
            return Response(
                {'error': 'Only the workspace owner or manager can view this dashboard.'},
                status=status.HTTP_403_FORBIDDEN,
            )

        approved_memberships = list(workspace.memberships.filter(status=WorkspaceMembership.STATUS_APPROVED).select_related('user'))
        owner_present = any(membership.user_id == workspace.owner_id for membership in approved_memberships)

        members_payload = [
            {
                'id': membership.user.id,
                'name': membership.user.name,
                'email': membership.user.email,
                'designation': membership.designation,
                'role': membership.role,
                'can_share_mood_with_manager': membership.can_share_mood_with_manager,
            }
            for membership in approved_memberships
        ]

        if not owner_present:
            members_payload.insert(0, {
                'id': workspace.owner.id,
                'name': workspace.owner.name,
                'email': workspace.owner.email,
                'designation': 'Admin',
                'role': WorkspaceMembership.ROLE_OWNER,
                'can_share_mood_with_manager': False,
            })

        total_members = len(members_payload)

        last_7_days = timezone.now().date() - timezone.timedelta(days=7)
        active_members_7d = User.objects.filter(
            workspace_memberships__workspace=workspace,
            workspace_memberships__status=WorkspaceMembership.STATUS_APPROVED,
            mood_check_ins__date__gte=last_7_days,
        ).distinct().count()

        mood_score_values = list(
            MoodCheckIn.objects.filter(
                user__workspace_memberships__workspace=workspace,
                user__workspace_memberships__status=WorkspaceMembership.STATUS_APPROVED,
                date__gte=last_7_days,
            ).values_list('moods__score', flat=True)
        )

        total_check_ins = len(mood_score_values)
        average_mood_score = round(sum(mood_score_values) / total_check_ins, 2) if total_check_ins else 0

        positive_count = sum(1 for score in mood_score_values if score >= 65)
        neutral_count = sum(1 for score in mood_score_values if 40 <= score < 65)
        low_count = sum(1 for score in mood_score_values if score < 40)

        return Response({
            'workspace_id': workspace.id,
            'workspace_type': workspace.workspace_type,
            'name': workspace.name,
            'total_members': total_members,
            'active_members_7d': active_members_7d,
            'average_mood_score': average_mood_score,
            'environment_score': average_mood_score,
            'environment_breakdown': {
                'total_check_ins': total_check_ins,
                'positive': positive_count,
                'neutral': neutral_count,
                'low': low_count,
            },
            'members': members_payload,
        })

    @action(detail=True, methods=['post'])
    def bulk_invite(self, request, pk=None):
        workspace = self.get_object()

        if request.user != workspace.owner:
            return Response(
                {'error': 'Only the workspace owner can bulk invite members.'},
                status=status.HTTP_403_FORBIDDEN,
            )

        if workspace.workspace_type != Workspace.WORKSPACE_TYPE_OFFICE:
            return Response(
                {'error': 'Bulk invite is only available for office workspaces.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        emails = request.data.get('emails', [])
        if not isinstance(emails, list):
            return Response({'error': 'emails must be a list.'}, status=status.HTTP_400_BAD_REQUEST)

        invited_count = 0
        skipped_emails = []
        invited_emails = []

        for raw_email in emails:
            email = (raw_email or '').strip()
            if not email:
                continue

            user = User.objects.filter(email__iexact=email).first()
            if not user:
                skipped_emails.append(email)
                continue

            membership, created = WorkspaceMembership.objects.get_or_create(
                workspace=workspace,
                user=user,
                defaults={
                    'role': WorkspaceMembership.ROLE_EMPLOYEE,
                    'designation': 'Employee',
                    'status': WorkspaceMembership.STATUS_APPROVED,
                    'invited_by': request.user,
                    'joined_at': timezone.now(),
                },
            )

            if created:
                invited_count += 1
                invited_emails.append(user.email)
            else:
                if membership.status != WorkspaceMembership.STATUS_APPROVED:
                    membership.status = WorkspaceMembership.STATUS_APPROVED
                    membership.invited_by = request.user
                    membership.joined_at = timezone.now()
                    membership.save()
                invited_emails.append(user.email)

        return Response({
            'workspace_id': workspace.id,
            'workspace_type': workspace.workspace_type,
            'invited_count': invited_count,
            'skipped_emails': skipped_emails,
            'invited_emails': invited_emails,
            'message': 'Bulk invite completed successfully.'
        })

    @action(detail=False, methods=['post'])
    def join(self, request):
        invite_code = request.data.get('invite_code') or request.query_params.get('invite')
        if not invite_code:
            return Response({'error': 'invite_code is required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            workspace = Workspace.objects.get(invite_code__iexact=invite_code)
        except Workspace.DoesNotExist:
            return Response({'error': 'Invalid invite code'}, status=status.HTTP_404_NOT_FOUND)

        membership, created = WorkspaceMembership.objects.get_or_create(
            workspace=workspace,
            user=request.user,
            defaults={
                'role': WorkspaceMembership.ROLE_EMPLOYEE,
                'status': WorkspaceMembership.STATUS_APPROVED if not workspace.is_approval_required else WorkspaceMembership.STATUS_PENDING,
                'designation': 'Employee'
            }
        )

        if not created and membership.status != WorkspaceMembership.STATUS_APPROVED:
            membership.status = WorkspaceMembership.STATUS_APPROVED if not workspace.is_approval_required else membership.status
            membership.save()

        return Response({
            'workspace_id': workspace.id,
            'status': membership.status,
            'join_url': workspace.join_url,
            'message': 'Workspace joined successfully' if membership.status == WorkspaceMembership.STATUS_APPROVED else 'Join request sent for approval'
        })

    @action(detail=True, methods=['post'])
    def approve_member(self, request, pk=None):
        workspace = self.get_object()
        member_id = request.data.get('member_id')
        if not member_id:
            return Response({'error': 'member_id is required'}, status=status.HTTP_400_BAD_REQUEST)

        if request.user != workspace.owner:
            return Response({'error': 'Only workspace owner can approve members'}, status=status.HTTP_403_FORBIDDEN)

        membership = WorkspaceMembership.objects.filter(workspace=workspace, user_id=member_id).first()
        if not membership:
            return Response({'error': 'Membership not found'}, status=status.HTTP_404_NOT_FOUND)

        membership.status = WorkspaceMembership.STATUS_APPROVED
        membership.joined_at = timezone.now()
        membership.save()
        return Response(WorkspaceMembershipSerializer(membership).data)

    @action(detail=True, methods=['post'])
    def toggle_consent(self, request, pk=None):
        workspace = self.get_object()
        membership = WorkspaceMembership.objects.filter(workspace=workspace, user=request.user).first()
        if not membership:
            return Response({'error': 'Membership not found'}, status=status.HTTP_404_NOT_FOUND)

        membership.can_share_mood_with_manager = not membership.can_share_mood_with_manager
        membership.save()
        return Response(WorkspaceMembershipSerializer(membership).data)


class WorkspaceMembershipViewSet(viewsets.ModelViewSet):
    serializer_class = WorkspaceMembershipSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return WorkspaceMembership.objects.filter(user=self.request.user)


class WorkspaceSupportRequestViewSet(viewsets.ModelViewSet):
    serializer_class = WorkspaceSupportRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return WorkspaceSupportRequest.objects.filter(receiver=self.request.user) | WorkspaceSupportRequest.objects.filter(sender=self.request.user)

    def perform_create(self, serializer):
        serializer.save(sender=self.request.user)
