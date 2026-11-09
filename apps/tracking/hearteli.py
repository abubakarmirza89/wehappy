"""Hearteli's private-by-default support loop.

Every nudge is a deliberately confirmed, bounded snapshot. Check-in notes are
never serialized to recipients or copied into the nudge payload.
"""
import hashlib
import secrets
from smtplib import SMTPException
from datetime import timedelta
from django.db import IntegrityError, transaction
from django.db.models import Q
from django.utils import timezone
from rest_framework import serializers, viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.exceptions import APIException, NotFound, ValidationError, PermissionDenied
from rest_framework.response import Response

from .models import (CircleConnection, CircleSignupInvitation, ConsentEvent, EmpathyNudge,
                     CircleInviteCode, HearteliPreferences, MoodCheckIn,
                     SupportOutcome, TherapistContextGrant)
from apps.users.models import User
from apps.users.communications import send_circle_signup_invitation


CIRCLE_INVITE_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
CIRCLE_INVITE_LENGTH = 20
CIRCLE_INVITE_LIFETIME = timedelta(minutes=10)
CIRCLE_SIGNUP_INVITE_LIFETIME = timedelta(days=30)
CIRCLE_SIGNUP_INVITE_COOLDOWN = timedelta(hours=24)
CIRCLE_SIGNUP_INVITE_DAILY_LIMIT = 10


class CircleSignupInviteDeliveryError(APIException):
    status_code = status.HTTP_503_SERVICE_UNAVAILABLE
    default_detail = 'The invitation email could not be sent. Please try again later.'
    default_code = 'signup_invite_email_unavailable'


class ConnectionSerializer(serializers.ModelSerializer):
    owner_name = serializers.CharField(source='owner.name', read_only=True)
    recipient_name = serializers.CharField(source='recipient.name', read_only=True)
    recipient_email = serializers.EmailField(source='recipient.email', read_only=True)
    recipient_email_input = serializers.EmailField(write_only=True, required=False)

    class Meta:
        model = CircleConnection
        fields = ['id', 'owner', 'owner_name', 'recipient', 'recipient_name',
                  'recipient_email', 'recipient_email_input', 'relationship',
                  'accepted_at', 'declined_at', 'may_receive_nudges',
                  'may_receive_preference', 'ask_on_pattern']
        read_only_fields = [
            'owner',
            'recipient',
            'accepted_at',
            'declined_at',
            'may_receive_nudges',
        ]

    def create(self, validated_data):
        email = validated_data.pop('recipient_email_input', None)
        validated_data.pop('may_receive_preference', None)
        validated_data.pop('ask_on_pattern', None)
        if not email:
            raise ValidationError({'recipient_email_input': 'Email is required.'})
        recipient = User.objects.filter(email__iexact=email).first()
        if not recipient:
            raise NotFound('This person is not on Hearteli yet. Invite them to sign up.')
        if not recipient.is_active:
            raise ValidationError({'recipient_email_input': 'This Hearteli account is not active.'})
        if recipient == self.context['request'].user:
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

    @action(detail=False, methods=['post'], url_path='invite-code')
    def invite_code(self, request):
        relationship = request.data.get('relationship', 'Friend')
        if not isinstance(relationship, str) or not 1 <= len(relationship.strip()) <= 40:
            raise ValidationError({'relationship': 'Use a relationship name up to 40 characters.'})

        now = timezone.now()
        CircleInviteCode.objects.filter(
            owner=request.user,
            redeemed_at__isnull=True,
            expires_at__gt=now,
        ).update(expires_at=now)

        code = ''.join(
            secrets.choice(CIRCLE_INVITE_ALPHABET)
            for _ in range(CIRCLE_INVITE_LENGTH)
        )
        invite = CircleInviteCode.objects.create(
            owner=request.user,
            code_hash=hashlib.sha256(code.encode('ascii')).hexdigest(),
            relationship=relationship.strip(),
            expires_at=now + CIRCLE_INVITE_LIFETIME,
        )
        return Response(
            {'code': code, 'expires_at': invite.expires_at},
            status=status.HTTP_201_CREATED,
        )

    @action(detail=False, methods=['post'], url_path='invite-signup')
    def invite_signup(self, request):
        email = serializers.EmailField().run_validation(request.data.get('email')).lower()
        relationship = request.data.get('relationship', 'Friend')
        if not isinstance(relationship, str) or not 1 <= len(relationship.strip()) <= 40:
            raise ValidationError({'relationship': 'Use a relationship name up to 40 characters.'})
        relationship = relationship.strip()
        if email.casefold() == request.user.email.casefold():
            raise ValidationError({'email': 'You cannot invite yourself.'})
        if User.objects.filter(email__iexact=email).exists():
            raise ValidationError({'email': 'This person already has a Hearteli account. Send a Circle invitation instead.'})

        now = timezone.now()
        with transaction.atomic():
            invitation, created = CircleSignupInvitation.objects.select_for_update().get_or_create(
                owner=request.user,
                email=email,
                defaults={
                    'relationship': relationship,
                    'expires_at': now + CIRCLE_SIGNUP_INVITE_LIFETIME,
                },
            )
            if invitation.claimed_at is not None:
                raise ValidationError({'email': 'This invitation has already been accepted by an account.'})
            if invitation.last_sent_at and invitation.last_sent_at > now - CIRCLE_SIGNUP_INVITE_COOLDOWN:
                raise ValidationError({'email': 'An invitation was sent to this address recently. Try again tomorrow.'})
            sent_today = CircleSignupInvitation.objects.filter(
                owner=request.user,
                last_sent_at__gte=now - CIRCLE_SIGNUP_INVITE_COOLDOWN,
            ).count()
            if sent_today >= CIRCLE_SIGNUP_INVITE_DAILY_LIMIT:
                raise ValidationError({'email': 'You have reached today’s signup invitation limit. Try again tomorrow.'})

            invitation.relationship = relationship
            invitation.expires_at = now + CIRCLE_SIGNUP_INVITE_LIFETIME
            try:
                send_circle_signup_invitation(invitation)
            except (OSError, SMTPException, RuntimeError) as exc:
                raise CircleSignupInviteDeliveryError() from exc
            invitation.last_sent_at = now
            invitation.save(update_fields=['relationship', 'expires_at', 'last_sent_at'])

        return Response({'message': 'Signup invitation sent.'}, status=status.HTTP_201_CREATED)

    @action(detail=False, methods=['post'], url_path='redeem-invite')
    def redeem_invite(self, request):
        code = request.data.get('code')
        if not isinstance(code, str):
            raise ValidationError({'code': 'Enter a valid Circle invite code.'})
        normalized_code = ''.join(character for character in code.upper() if character.isalnum())
        if (
            len(normalized_code) != CIRCLE_INVITE_LENGTH
            or any(character not in CIRCLE_INVITE_ALPHABET for character in normalized_code)
        ):
            raise ValidationError({'code': 'Enter a valid Circle invite code.'})
        code_hash = hashlib.sha256(normalized_code.encode('ascii')).hexdigest()

        with transaction.atomic():
            invite = CircleInviteCode.objects.select_for_update().select_related('owner').filter(
                code_hash=code_hash,
            ).first()
            now = timezone.now()
            if (
                invite is None
                or invite.redeemed_at is not None
                or invite.expires_at <= now
                or not invite.owner.is_active
                or invite.owner_id == request.user.id
            ):
                raise ValidationError({'code': 'This Circle invite is invalid, expired or already used.'})

            invite.redeemed_at = now
            invite.save(update_fields=['redeemed_at'])
            connection = CircleConnection.objects.filter(
                owner=invite.owner,
                recipient=request.user,
            ).first()
            created = connection is None
            if connection is None:
                connection = CircleConnection(
                    owner=invite.owner,
                    recipient=request.user,
                    relationship=invite.relationship,
                    accepted_at=now,
                )
                connection._circle_invite_code_redeemed = True
                connection.save()
            elif connection.accepted_at is None or connection.declined_at is not None:
                connection.relationship = invite.relationship
                connection.accepted_at = now
                connection.declined_at = None
                connection.may_receive_nudges = False
                connection.may_receive_preference = False
                connection.ask_on_pattern = False
                connection.save()

            ConsentEvent.objects.create(
                actor=request.user,
                connection=connection,
                event='invite_redeemed',
                categories=[],
            )

        return Response(
            self.get_serializer(connection).data,
            status=status.HTTP_201_CREATED if created else status.HTTP_200_OK,
        )

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
                if connection.declined_at is not None:
                    raise ValidationError({'accept': 'This invitation is no longer available.'})
                connection.accepted_at = timezone.now()
            elif request.data.get('accept') is False:
                if connection.accepted_at is not None:
                    raise ValidationError({'accept': 'An accepted invitation cannot be declined.'})
                if connection.declined_at is not None:
                    raise ValidationError({'accept': 'This invitation is no longer available.'})
                connection.accepted_at = None
                connection.declined_at = timezone.now()
                connection.may_receive_nudges = False
            if 'may_receive_nudges' in request.data:
                connection.may_receive_nudges = request.data['may_receive_nudges'] and connection.accepted_at is not None
            event = 'accepted' if request.data.get('accept') is True else 'recipient_permission_changed'
        else:
            allowed = {'relationship', 'may_receive_preference', 'ask_on_pattern'}
            if set(request.data) - allowed:
                raise ValidationError('Unsupported fields for owner.')
            if 'may_receive_preference' in request.data and type(request.data['may_receive_preference']) is not bool:
                raise ValidationError({'may_receive_preference': 'Must be boolean.'})
            if 'ask_on_pattern' in request.data:
                if type(request.data['ask_on_pattern']) is not bool:
                    raise ValidationError({'ask_on_pattern': 'Must be boolean.'})
                connection.ask_on_pattern = request.data['ask_on_pattern'] and connection.accepted_at is not None
            if 'relationship' in request.data:
                value = request.data['relationship']
                if not isinstance(value, str) or not 1 <= len(value.strip()) <= 40:
                    raise ValidationError({'relationship': 'Use a relationship name up to 40 characters.'})
                connection.relationship = value.strip()
                # A changed role must not inherit the former permission silently.
                connection.may_receive_preference = False
                connection.ask_on_pattern = False
            if 'may_receive_preference' in request.data:
                connection.may_receive_preference = request.data['may_receive_preference'] and connection.accepted_at is not None
            event = 'owner_permission_changed'
        connection.save()
        ConsentEvent.objects.create(actor=request.user, connection=connection, event=event,
                                    categories=['nudge'] if connection.may_receive_nudges else [])
        return Response(self.get_serializer(connection).data)

    @action(detail=False, methods=['get'])
    def pattern_prompt(self, request):
        recent = MoodCheckIn.objects.filter(user=request.user,
            timestamp__gte=timezone.now()-timezone.timedelta(hours=48),
            feeling_category__in=['not_great', 'struggling']).count()
        eligible = CircleConnection.objects.filter(owner=request.user,
            accepted_at__isnull=False, may_receive_nudges=True, ask_on_pattern=True)
        return Response({'suggested': recent >= 2 and eligible.exists(),
            'message': 'A couple of tough check-ins. Would you like to choose someone for support? Nothing will be sent without your review.',
            'connection_ids': list(eligible.values_list('id', flat=True)) if recent >= 2 else []})

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
                  'support_context', 'delivery_status', 'status', 'recipient_choice',
                  'created_at', 'responded_at', 'viewer_is_recipient']
        read_only_fields = ['sender', 'sender_name', 'recipient_name', 'delivery_status',
                            'status', 'recipient_choice', 'created_at', 'responded_at']

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
            import uuid
            try:
                key = uuid.UUID(str(key))
            except (ValueError, TypeError, AttributeError):
                raise ValidationError({'idempotency_key': 'Use a valid UUID.'})
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
                if EmpathyNudge.objects.filter(sender=request.user, recipient=connection.recipient, check_in=serializer.validated_data['check_in'], status='sent').exists():
                    raise ValidationError({'recipient': 'There is already a pending nudge for this check-in. Open that nudge instead.'})
                nudge = serializer.save(sender=request.user)
                nudge.refresh_from_db()
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
        choice = request.data.get('choice')
        if choice is None:
            choice = {
                'acknowledged': 'recipient_reported_reached_out',
                'cannot_help': 'cannot_help',
            }.get(request.data.get('status'))
        choices = {
            'recipient_reported_reached_out',
            'will_check_in_later',
            'will_give_space',
            'cannot_help',
        }
        if choice not in choices:
            raise ValidationError({'choice': 'Choose one of the available responses.'})
        if nudge.status != 'sent':
            raise ValidationError({'choice': 'Already responded.'})
        nudge.recipient_choice = choice
        nudge.status = 'cannot_help' if choice == 'cannot_help' else 'acknowledged'
        nudge.responded_at = timezone.now()
        nudge.save(update_fields=['status', 'recipient_choice', 'responded_at'])
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
                  'quiet_end', 'rich_lock_preview', 'email_notifications', 'timezone_name', 'reminder_time', 'sponsor_opt_in']

    def validate_timezone_name(self, value):
        from zoneinfo import ZoneInfo, ZoneInfoNotFoundError
        try:
            ZoneInfo(value)
        except (ZoneInfoNotFoundError, ValueError):
            raise ValidationError('Choose a valid IANA timezone, for example Asia/Karachi.')
        return value

    def validate(self, attrs):
        start = attrs.get('quiet_start', getattr(self.instance, 'quiet_start', None))
        end = attrs.get('quiet_end', getattr(self.instance, 'quiet_end', None))
        if (start is None) != (end is None) or (start is not None and start == end):
            raise ValidationError('Set both quiet times to different values, or clear both.')
        return attrs


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
