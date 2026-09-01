from django.shortcuts import get_object_or_404
from rest_framework import generics, mixins, permissions, status, views, viewsets
from rest_framework.response import Response
from datetime import datetime

from apps.tracking.models import (
    Message, Mood, Relative, Suggestion, MoodCheckIn, ChatConversation, 
    ChatMessage, MoodNotification, NotificationTemplate, GratitudeEntry
)
from apps.users.models import Brain_Health_Score, Send_To_Relative, Suggestion_Therapist, Therapist, User
from apps.users.serializers import UserSerializer

from .serializers import (
    MoodSerializer, RelativeSerializer, SuggestionSerializer, MoodCheckInSerializer,
    ChatConversationSerializer, ChatMessageSerializer, MoodNotificationSerializer,
    GratitudeEntrySerializer, NotificationTemplateSerializer
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

        user = request.user
        Brain_Health_Score.objects.create(user=user, rating=mood.score)

        message = Message.objects.filter(mood=mood).order_by("?").first()
        if message:
            suggestion_text = suggestion.suggestion_text
            message_text = message.message_text
            is_urgent = message.is_urgent
            relatives = user.relative.distinct("name", "email")
            for relative in relatives:
                message_body = (
                    f"Hey {relative.name}, {user.name} has been feeling {mood.name}.\n\n"
                    f"Here's a suggestion: {suggestion_text}\n\n{message_text}\n\n"
                    f"Is urgent: {is_urgent}\n\nThanks,"
                )
                msg = f"{message_body} to {[relative.email]} from 'brainhealth@gmail.com'"
                Send_To_Relative.objects.create(message_text=msg)

        brain_health_score = user.brain_health_score()
        if brain_health_score < 50:
            therapists = Therapist.objects.filter(is_available=True)
            therapists_details = "\n\n".join(
                f"{therapist.user.name}: {therapist.user.email}" for therapist in therapists
            )
            message_body = (
                f"Hey {user.name}, we see your mood is less than 50%, so we suggest "
                f"that you meet with one of the following therapists for brain health therapy:\n\n"
                f"{therapists_details}\n\nThanks"
            )
            Suggestion_Therapist.objects.create(message_text=message_body)

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
        return ChatConversation.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def send_message(self, request, pk=None):
        """Send a message in a conversation"""
        conversation = self.get_object()
        message_text = request.data.get('message')
        
        if not message_text:
            return Response({'error': 'Message text is required'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Save user message
        user_message = ChatMessage.objects.create(
            conversation=conversation,
            sender='user',
            message_text=message_text
        )
        
        # TODO: Call AI service (OpenAI) to generate bot response
        bot_response = "Thank you for sharing. I'm here to help. Can you tell me more about what you're feeling?"
        
        # Save bot response
        ChatMessage.objects.create(
            conversation=conversation,
            sender='bot',
            message_text=bot_response
        )
        
        # Return updated conversation
        serializer = self.get_serializer(conversation)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def end_conversation(self, request, pk=None):
        """End a chat conversation"""
        conversation = self.get_object()
        conversation.is_active = False
        conversation.ended_at = datetime.now()
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
            if not template:
                continue
            
            for relative in relatives:
                # Create notification for each relative
                notification = MoodNotification.objects.create(
                    user=request.user,
                    relative=relative,
                    mood_check_in=mood_check_in,
                    message_text=template.template_text,
                    notification_type=template.notification_type
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