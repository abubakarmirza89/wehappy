from django.db import transaction
from django.utils import timezone
from rest_framework import serializers, viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.exceptions import ValidationError, PermissionDenied
from rest_framework.response import Response
from .models import CircleConnection, EmpathyNudge, MoodCheckIn
from apps.users.models import User


class ConnectionSerializer(serializers.ModelSerializer):
    recipient_name = serializers.CharField(source='recipient.name', read_only=True)
    recipient_email = serializers.EmailField(source='recipient.email', read_only=True)
    recipient_email_input = serializers.EmailField(write_only=True, required=False)

    class Meta:
        model = CircleConnection
        fields = ['id', 'recipient', 'recipient_name', 'recipient_email', 'recipient_email_input', 'relationship', 'accepted_at', 'may_receive_nudges']
        read_only_fields = ['recipient', 'accepted_at', 'may_receive_nudges']

    def create(self, validated_data):
        email = validated_data.pop('recipient_email_input', None)
        if not email:
            raise ValidationError({'recipient_email_input': 'Email is required.'})
        recipient = User.objects.filter(email__iexact=email, is_active=True).first()
        if not recipient or recipient == self.context['request'].user:
            raise ValidationError({'recipient_email_input': 'Choose another existing Hearteli member.'})
        if CircleConnection.objects.filter(owner=self.context['request'].user, recipient=recipient).exists():
            raise ValidationError({'recipient_email_input': 'Already invited.'})
        return CircleConnection.objects.create(owner=self.context['request'].user, recipient=recipient, **validated_data)


class ConnectionViewSet(viewsets.ModelViewSet):
    serializer_class = ConnectionSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'post', 'patch', 'delete', 'head', 'options']

    def get_queryset(self):
        user = self.request.user
        return CircleConnection.objects.filter(owner=user) | CircleConnection.objects.filter(recipient=user)

    def partial_update(self, request, *args, **kwargs):
        connection = self.get_object()
        if connection.recipient_id != request.user.id:
            raise PermissionDenied('Only the recipient can accept or pause nudges.')
        allowed = {'accept', 'may_receive_nudges'}
        if set(request.data) - allowed:
            raise ValidationError('Unsupported fields.')
        if request.data.get('accept') is True:
            connection.accepted_at = timezone.now()
        elif request.data.get('accept') is False:
            connection.accepted_at = None
            connection.may_receive_nudges = False
        if 'may_receive_nudges' in request.data:
            if type(request.data['may_receive_nudges']) is not bool:
                raise ValidationError({'may_receive_nudges': 'Must be boolean.'})
            connection.may_receive_nudges = bool(request.data['may_receive_nudges']) and connection.accepted_at is not None
        connection.save()
        return Response(self.get_serializer(connection).data)


class NudgeSerializer(serializers.ModelSerializer):
    recipient_name = serializers.CharField(source='recipient.name', read_only=True)
    sender_name = serializers.CharField(source='sender.name', read_only=True)

    class Meta:
        model = EmpathyNudge
        fields = ['id', 'sender', 'sender_name', 'recipient', 'recipient_name', 'check_in', 'message', 'support_preference', 'status', 'created_at', 'responded_at']
        read_only_fields = ['sender', 'sender_name', 'recipient_name', 'status', 'created_at', 'responded_at']

    def validate(self, attrs):
        user = self.context['request'].user
        check_in = attrs['check_in']
        if check_in.user_id != user.id or not check_in.moods.exists():
            raise ValidationError({'check_in': 'Choose your completed check-in.'})
        if not CircleConnection.objects.filter(owner=user, recipient=attrs['recipient'], accepted_at__isnull=False, may_receive_nudges=True).exists():
            raise ValidationError({'recipient': 'Recipient must accept and enable nudges.'})
        return attrs


class NudgeViewSet(viewsets.ModelViewSet):
    serializer_class = NudgeSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'post', 'head', 'options']

    def get_queryset(self):
        from django.db.models import Q
        return EmpathyNudge.objects.filter(Q(sender=self.request.user) | Q(recipient=self.request.user)).select_related('sender', 'recipient', 'check_in')

    def perform_create(self, serializer):
        serializer.save(sender=self.request.user)

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
