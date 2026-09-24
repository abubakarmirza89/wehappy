"""Hearteli's private-by-default support loop.

Every nudge is a deliberately confirmed, bounded snapshot. Check-in notes are
never serialized to recipients or copied into the nudge payload.
"""
from django.db import IntegrityError, transaction
from django.db.models import Q
from django.utils import timezone
from rest_framework import serializers, viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.exceptions import ValidationError, PermissionDenied
from rest_framework.response import Response

from .models import (CircleConnection, ConsentEvent, EmpathyNudge,
                     HearteliPreferences, MoodCheckIn, SupportOutcome, TherapistContextGrant)
from apps.users.models import User


class ConnectionSerializer(serializers.ModelSerializer):
    owner_name = serializers.CharField(source='owner.name', read_only=True)
    recipient_name = serializers.CharField(source='recipient.name', read_only=True)
    recipient_email = serializers.EmailField(source='recipient.email', read_only=True)
    recipient_email_input = serializers.EmailField(write_only=True, required=False)

    class Meta:
        model = CircleConnection
        fields = ['id', 'owner', 'owner_name', 'recipient', 'recipient_name',
                  'recipient_email', 'recipient_email_input', 'relationship',
                  'accepted_at', 'may_receive_nudges', 'may_receive_preference']
        read_only_fields = ['owner', 'recipient', 'accepted_at', 'may_receive_nudges']

    def create(self, validated_data):
        email = validated_data.pop('recipient_email_input', None)
        validated_data.pop('may_receive_preference', None)
        if not email:
            raise ValidationError({'recipient_email_input': 'Email is required.'})
        recipient = User.objects.filter(email__iexact=email, is_active=True).first()
        if not recipient or recipient == self.context['request'].user:
            raise ValidationError({'recipient_email_input': 'Choose another existing Hearteli member.'})
        if CircleConnection.objects.filter(owner=self.context['request'].user, recipient=recipient).exists():
            raise ValidationError({'recipient_email_input': 'Already invited.'})
        connection = CircleConnection.objects.create(owner=self.context['request'].user,
                                                     recipient=recipient, **validated_data)
        ConsentEvent.objects.create(actor=self.context['request'].user, connection=connection,
                                    event='invited', categories=[])
        return connection


class ConnectionViewSet(viewsets.ModelViewSet):
    serializer_class = ConnectionSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'post', 'patch', 'delete', 'head', 'options']

    def get_queryset(self):
        user = self.request.user
        return CircleConnection.objects.filter(Q(owner=user) | Q(recipient=user)).select_related('owner', 'recipient')

    def partial_update(self, request, *args, **kwargs):
        connection = self.get_object()
        if connection.recipient_id == request.user.id:
            allowed = {'accept', 'may_receive_nudges'}
            if set(request.data) - allowed:
                raise ValidationError('Unsupported fields for recipient.')
            if 'accept' in request.data and type(request.data['accept']) is not bool:
                raise ValidationError({'accept': 'Must be boolean.'})
            if 'may_receive_nudges' in request.data and type(request.data['may_receive_nudges']) is not bool:
                raise ValidationError({'may_receive_nudges': 'Must be boolean.'})
            if request.data.get('accept') is True:
                connection.accepted_at = timezone.now()
            elif request.data.get('accept') is False:
                connection.accepted_at = None
                connection.may_receive_nudges = False
            if 'may_receive_nudges' in request.data:
                connection.may_receive_nudges = request.data['may_receive_nudges'] and connection.accepted_at is not None
            event = 'accepted' if request.data.get('accept') is True else 'recipient_permission_changed'
        else:
            allowed = {'relationship', 'may_receive_preference'}
            if set(request.data) - allowed:
                raise ValidationError('Unsupported fields for owner.')
            if 'may_receive_preference' in request.data and type(request.data['may_receive_preference']) is not bool:
                raise ValidationError({'may_receive_preference': 'Must be boolean.'})
            if 'relationship' in request.data:
                value = request.data['relationship']
                if not isinstance(value, str) or not 1 <= len(value.strip()) <= 40:
                    raise ValidationError({'relationship': 'Use a relationship name up to 40 characters.'})
                connection.relationship = value.strip()
                # A changed role must not inherit the former permission silently.
                connection.may_receive_preference = False
            if 'may_receive_preference' in request.data:
                connection.may_receive_preference = request.data['may_receive_preference'] and connection.accepted_at is not None
            event = 'owner_permission_changed'
        connection.save()
        ConsentEvent.objects.create(actor=request.user, connection=connection, event=event,
                                    categories=['nudge'] if connection.may_receive_nudges else [])
        return Response(self.get_serializer(connection).data)

    def perform_destroy(self, instance):
        ConsentEvent.objects.create(actor=self.request.user, connection=instance,
                                    event='revoked', categories=[])
        instance.delete()


class NudgeSerializer(serializers.ModelSerializer):
    idempotency_key = serializers.UUIDField(required=True)
    recipient_name = serializers.CharField(source='recipient.name', read_only=True)
    sender_name = serializers.CharField(source='sender.name', read_only=True)
    viewer_is_recipient = serializers.SerializerMethodField()

    def get_viewer_is_recipient(self, obj):
        return obj.recipient_id == self.context['request'].user.id

    class Meta:
        model = EmpathyNudge
        fields = ['id', 'sender', 'sender_name', 'recipient', 'recipient_name',
                  'check_in', 'message', 'support_preference', 'idempotency_key',
                  'delivery_status', 'status', 'created_at', 'responded_at', 'viewer_is_recipient']
        read_only_fields = ['sender', 'sender_name', 'recipient_name', 'delivery_status',
                            'status', 'created_at', 'responded_at']

    def validate(self, attrs):
        user = self.context['request'].user
        check_in = attrs['check_in']
        if check_in.user_id != user.id or not (check_in.feeling_category or check_in.moods.exists()):
            raise ValidationError({'check_in': 'Choose your completed check-in.'})
        connection = CircleConnection.objects.filter(owner=user, recipient=attrs['recipient'],
                          accepted_at__isnull=False, may_receive_nudges=True).first()
        if not connection:
            raise ValidationError({'recipient': 'Recipient must accept and enable nudges.'})
        if attrs.get('support_preference') and not connection.may_receive_preference:
            raise ValidationError({'support_preference': 'Enable this category in relationship permissions first.'})
        if not attrs.get('message', '').strip():
            raise ValidationError({'message': 'Write a short message to preview.'})
        return attrs


class NudgeViewSet(viewsets.ModelViewSet):
    serializer_class = NudgeSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'post', 'head', 'options']

    def get_queryset(self):
        user = self.request.user
        accepted_senders = CircleConnection.objects.filter(recipient=user, accepted_at__isnull=False,
                         may_receive_nudges=True).values('owner_id')
        return EmpathyNudge.objects.filter(Q(sender=user) | Q(recipient=user,
                   sender_id__in=accepted_senders)).select_related('sender', 'recipient', 'check_in')

    def create(self, request, *args, **kwargs):
        key = request.data.get('idempotency_key')
        if key:
            previous = EmpathyNudge.objects.filter(sender=request.user, idempotency_key=key).first()
            if previous:
                return Response(self.get_serializer(previous).data, status=status.HTTP_200_OK)
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            with transaction.atomic():
                connection = CircleConnection.objects.select_for_update().filter(
                    owner=request.user, recipient=serializer.validated_data['recipient'],
                    accepted_at__isnull=False, may_receive_nudges=True).first()
                if not connection:
                    raise ValidationError({'recipient': 'Permission changed. Review the recipient again.'})
                if serializer.validated_data.get('support_preference') and not connection.may_receive_preference:
                    raise ValidationError({'support_preference': 'Permission changed. Review the preview again.'})
                nudge = serializer.save(sender=request.user)
                ConsentEvent.objects.create(actor=request.user, connection=connection,
                                            event='nudge_confirmed',
                                            categories=['message'] + (['support_preference'] if nudge.support_preference else []))
        except IntegrityError:
            previous = EmpathyNudge.objects.get(sender=request.user, idempotency_key=key)
            return Response(self.get_serializer(previous).data, status=status.HTTP_200_OK)
        return Response(self.get_serializer(nudge).data, status=status.HTTP_201_CREATED)

    def retrieve(self, request, *args, **kwargs):
        nudge = self.get_object()
        if nudge.recipient_id == request.user.id and nudge.delivery_status in ('created', 'queued', 'sent', 'delivered'):
            nudge.delivery_status = 'opened'
            nudge.save(update_fields=['delivery_status'])
        return Response(self.get_serializer(nudge).data)

    @action(detail=True, methods=['post'])
    def respond(self, request, pk=None):
        nudge = self.get_object()
        if nudge.recipient_id != request.user.id:
            raise PermissionDenied('Only the recipient can respond.')
        if request.data.get('status') not in ('acknowledged', 'cannot_help'):
            raise ValidationError({'status': 'Choose acknowledged or cannot_help.'})
        if nudge.status != 'sent':
            raise ValidationError({'status': 'Already responded.'})
        nudge.status = request.data['status']
        nudge.responded_at = timezone.now()
        nudge.save(update_fields=['status', 'responded_at'])
        return Response(self.get_serializer(nudge).data)


class OutcomeSerializer(serializers.ModelSerializer):
    class Meta:
        model = SupportOutcome
        fields = ['id', 'nudge', 'result', 'private_note', 'created_at']
        read_only_fields = ['created_at']

    def validate_nudge(self, nudge):
        if nudge.sender_id != self.context['request'].user.id:
            raise ValidationError('Only the member may record their private outcome.')
        return nudge

    def validate_private_note(self, value):
        if len(value) > 500:
            raise ValidationError('Keep your private note under 500 characters.')
        return value


class OutcomeViewSet(viewsets.ModelViewSet):
    serializer_class = OutcomeSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'post', 'head', 'options']

    def get_queryset(self):
        return SupportOutcome.objects.filter(member=self.request.user)

    def perform_create(self, serializer):
        serializer.save(member=self.request.user)


class PreferencesSerializer(serializers.ModelSerializer):
    class Meta:
        model = HearteliPreferences
        fields = ['use_contexts', 'reminder_enabled', 'nudge_notifications', 'quiet_start',
                  'quiet_end', 'rich_lock_preview']


class PreferencesViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAuthenticated]

    def list(self, request):
        obj, _ = HearteliPreferences.objects.get_or_create(user=request.user)
        return Response(PreferencesSerializer(obj).data)

    @action(detail=False, methods=['patch'])
    def update_mine(self, request):
        obj, _ = HearteliPreferences.objects.get_or_create(user=request.user)
        serializer = PreferencesSerializer(obj, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)

class TherapyGrantSerializer(serializers.ModelSerializer):
    check_in_ids = serializers.PrimaryKeyRelatedField(source='check_ins', many=True,
        queryset=MoodCheckIn.objects.all(), write_only=True)
    selected_context = serializers.SerializerMethodField()
    therapist_name = serializers.CharField(source='therapist.name', read_only=True)

    class Meta:
        model = TherapistContextGrant
        fields = ['id', 'therapist', 'therapist_name', 'check_in_ids', 'selected_context',
                  'include_notes', 'expires_at', 'revoked_at', 'created_at']
        read_only_fields = ['revoked_at', 'created_at']

    def validate(self, attrs):
        user = self.context['request'].user
        therapist = attrs.get('therapist')
        if not therapist or not therapist.is_therapist or not therapist.is_active:
            raise ValidationError({'therapist': 'Choose an active therapist.'})
        check_ins = attrs.get('check_ins', [])
        if not check_ins or len(check_ins) > 20 or any(c.user_id != user.id for c in check_ins):
            raise ValidationError({'check_in_ids': 'Select up to 20 of your own check-ins.'})
        expiry = attrs.get('expires_at')
        if expiry is None or not timezone.now() < expiry <= timezone.now() + timezone.timedelta(days=30):
            raise ValidationError({'expires_at': 'Choose an expiry within 30 days.'})
        return attrs

    def get_selected_context(self, obj):
        # Only the grant's two parties can reach this serializer via the viewset.
        if obj.revoked_at or obj.expires_at <= timezone.now():
            return []
        return [{'date': c.date, 'feeling': c.feeling_category,
                 **({'note': c.notes} if obj.include_notes else {})}
                for c in obj.check_ins.all()]


class TherapyGrantViewSet(viewsets.ModelViewSet):
    serializer_class = TherapyGrantSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'post', 'delete', 'head', 'options']

    def get_queryset(self):
        return self.serializer_class.Meta.model.objects.filter(
            Q(member=self.request.user) | Q(therapist=self.request.user,
              revoked_at__isnull=True, expires_at__gt=timezone.now())).prefetch_related('check_ins')

    def perform_create(self, serializer):
        serializer.save(member=self.request.user)

    def perform_destroy(self, instance):
        if instance.member_id != self.request.user.id:
            raise PermissionDenied('Only the member can revoke context.')
        instance.revoked_at = timezone.now()
        instance.save(update_fields=['revoked_at'])

class DataControlViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAuthenticated]

    def list(self, request):
        """An authenticated, member-only copy of personal Hearteli data."""
        check_ins = list(MoodCheckIn.objects.filter(user=request.user).values(
            'id', 'date', 'feeling_category', 'notes', 'context_tags', 'support_preferences'))
        nudges = list(EmpathyNudge.objects.filter(sender=request.user).values(
            'id', 'recipient_id', 'message', 'support_preference', 'status', 'delivery_status', 'created_at'))
        outcomes = list(SupportOutcome.objects.filter(member=request.user).values(
            'nudge_id', 'result', 'private_note', 'created_at'))
        audit = list(ConsentEvent.objects.filter(actor=request.user).values(
            'event', 'categories', 'occurred_at'))
        return Response({'check_ins': check_ins, 'nudges_sent': nudges,
                         'outcomes': outcomes, 'consent_events': audit})

    @action(detail=False, methods=['post'])
    def delete_account(self, request):
        password = request.data.get('password')
        if not password or not request.user.check_password(password):
            raise ValidationError({'password': 'Current password is required.'})
        if request.user.is_staff or request.user.is_superuser or request.user.is_therapist:
            raise PermissionDenied('Professional and staff accounts require administrator handling.')
        request.user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
