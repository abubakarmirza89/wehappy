from django.core import signing
from django.db import IntegrityError, transaction
from django.shortcuts import render
from django.urls import reverse
from django.utils import timezone
from django.views.decorators.http import require_http_methods

from apps.users.email_verification import needs_verification
from .models import CircleConnection, CircleSignupInvitation, ConsentEvent

SALT = 'hearteli.circle-email-invite.v1'
MAX_AGE = 7 * 24 * 60 * 60


def invitation_path(invitation):
    token = signing.dumps({'invite': invitation.pk, 'sent': invitation.last_sent_at.isoformat()}, salt=SALT)
    return reverse('hearteli-circle-email-invite', args=[token])


@require_http_methods(['GET', 'POST'])
def review_invitation(request, token):
    outcome = 'unavailable'
    with transaction.atomic():
        try:
            payload = signing.loads(token, salt=SALT, max_age=MAX_AGE)
        except (signing.BadSignature, ValueError):
            payload = None
        if payload:
            invite = CircleSignupInvitation.objects.select_for_update().filter(
                pk=payload['invite'], requires_link=True, owner__is_active=True,
                expires_at__gt=timezone.now(), claimed_at__isnull=True,
                last_sent_at__isnull=False,
            ).first()
            if invite and invite.last_sent_at.isoformat() == payload['sent']:
                if not request.user.is_authenticated:
                    outcome = 'sign_in'
                    request.session['circle_invitation_next'] = request.path
                elif request.user.email.casefold() != invite.email.casefold() or needs_verification(request.user):
                    outcome = 'wrong_account'
                elif request.method == 'GET':
                    outcome = 'review'
                elif request.POST.get('decision') in ('accept', 'decline'):
                    accepted = request.POST['decision'] == 'accept'
                    invite.claimed_at = timezone.now()
                    invite.save(update_fields=['claimed_at'])
                    request.session.pop('circle_invitation_next', None)
                    outcome = 'declined'
                    if accepted:
                        connections = CircleConnection.objects.filter(
                            owner=invite.owner, recipient=request.user,
                        )
                        connection = connections.select_for_update().first()
                        if connection is None:
                            connection = CircleConnection(
                                owner=invite.owner, recipient=request.user,
                                relationship=invite.relationship, accepted_at=timezone.now(),
                            )
                            connection._circle_invite_code_redeemed = True
                            try:
                                with transaction.atomic():
                                    connection.save(force_insert=True)
                            except IntegrityError:
                                connection = connections.select_for_update().get()
                        if not connection.accepted_at or connection.declined_at:
                            connection.accepted_at = timezone.now()
                            connection.declined_at = None
                            connection.may_receive_nudges = False
                            connection.may_receive_preference = False
                            connection.ask_on_pattern = False
                            connection.save(update_fields=['accepted_at', 'declined_at', 'may_receive_nudges',
                                                           'may_receive_preference', 'ask_on_pattern'])
                        ConsentEvent.objects.create(actor=request.user, connection=connection,
                                                    event='invite_redeemed', categories=[])
                        outcome = 'accepted'
    response = render(request, 'work/circle_invitation.html', {'outcome': outcome, 'next_url': request.path})
    response['Cache-Control'] = 'no-store'
    response['Referrer-Policy'] = 'no-referrer'
    return response
