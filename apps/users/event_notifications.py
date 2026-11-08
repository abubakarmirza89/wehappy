"""Event hooks only create durable rows; external sends happen in the worker."""
from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from apps.users.models import User, Appointment, AppointmentMessage
from apps.tracking.models import CircleConnection, EmpathyNudge, WorkspaceMembership, WorkspaceRoleAudit
from .communications import queue_email, queue_push_notification
from .models import Notification


@receiver(post_save, sender=User)
def welcome(sender, instance, created, raw=False, **kwargs):
    if created and not raw:
        Notification.objects.create(
            recipient=instance,
            verb='Welcome to Hearteli ❤️ — A little more understanding starts here. Take your time, settle in, and make this space your own.',
        )


@receiver(post_save, sender=CircleConnection)
def circle_invite(sender, instance, created, raw=False, **kwargs):
    if (
        created
        and not raw
        and not getattr(instance, '_circle_invite_code_redeemed', False)
    ):
        queue_email(
            instance.recipient,
            'circle_invite',
            'You\'ve been invited to connect on Hearteli',
            'Someone you know would like to add you to their trusted Circle on Hearteli.\n\nA Circle is a private way to stay connected and offer support when it\'s welcome.\n\nYou can choose whether to accept.',
            key=f'circle:{instance.pk}',
            path='/notifications/',
            target_id=instance.pk,
            push=True,
            push_subject='Someone wants you in their Circle',
            push_message="You've received an invitation to connect on Hearteli.",
            in_app_message='Someone wants you in their Circle',
        )


@receiver(pre_save, sender=CircleConnection)
def circle_connection_previous(sender, instance, raw=False, **kwargs):
    instance._old_accepted_at = (
        sender.objects.filter(pk=instance.pk)
        .values_list('accepted_at', flat=True)
        .first()
        if instance.pk
        else None
    )


@receiver(post_save, sender=CircleConnection)
def circle_accepted(sender, instance, created, raw=False, **kwargs):
    if raw:
        return
    if created and not getattr(instance, '_circle_invite_code_redeemed', False):
        return
    if not created and instance._old_accepted_at is not None:
        return
    if instance.accepted_at is None or instance.declined_at is not None:
        return
    first_name = (instance.recipient.name or '').strip().split(maxsplit=1)
    name = first_name[0] if first_name else 'Someone'
    queue_push_notification(
        instance.owner,
        'circle_accepted',
        'Your Circle has grown',
        'Someone has accepted your Circle invitation.',
        key=f'circle-accepted:{instance.pk}',
        path='/circle/',
        target_id=instance.pk,
        in_app_message=f'{name} has accepted your Circle invitation.',
    )


@receiver(pre_save, sender=EmpathyNudge)
def nudge_previous(sender, instance, raw=False, **kwargs):
    instance._old_status = sender.objects.filter(pk=instance.pk).values_list('status', flat=True).first() if instance.pk else None


@receiver(post_save, sender=EmpathyNudge)
def nudge_events(sender, instance, created, raw=False, **kwargs):
    if raw:
        return
    if created:
        queue_push_notification(
            instance.recipient,
            'nudge',
            'A little nudge from Hearteli ❤️',
            'Someone in your Circle would appreciate some kindness today.',
            key=f'nudge:{instance.pk}:push',
            path=f'/notifications/nudges/{instance.pk}/',
            target_id=instance.pk,
            sensitive=True,
            in_app_message='A little nudge from Hearteli ❤️',
        )
        sender.objects.filter(pk=instance.pk).update(delivery_status='queued')
    elif getattr(instance, '_old_status', instance.status) != instance.status and instance.status in ('acknowledged', 'cannot_help'):
        recipient_name = instance.recipient.name.strip() or 'your Circle member'
        copy_by_choice = {
            'recipient_reported_reached_out': f"{recipient_name} says they've reached out to you.",
            'will_check_in_later': f'{recipient_name} plans to check in.',
            'will_give_space': f'{recipient_name} is giving you some space and is thinking of you.',
            'cannot_help': f"{recipient_name} can't be there right now. Would you like to reach out to someone else?",
        }
        queue_push_notification(
            instance.sender,
            'acknowledgement',
            'You have a Hearteli update',
            'Open Hearteli to see it.',
            key=f'ack:{instance.pk}:{instance.recipient_choice}:push',
            path=f'/notifications/nudges/{instance.pk}/',
            target_id=instance.pk,
            in_app_message=copy_by_choice.get(
                instance.recipient_choice,
                f'{recipient_name} has responded to your Empathy Nudge.',
            ),
        )


@receiver(pre_save, sender=Appointment)
def appointment_previous(sender, instance, **kwargs):
    instance._old_schedule = sender.objects.filter(pk=instance.pk).values('date', 'time', 'status').first() if instance.pk else None


@receiver(post_save, sender=Appointment)
def appointment_events(sender, instance, created, raw=False, **kwargs):
    if raw:
        return
    old = getattr(instance, '_old_schedule', None)
    schedule = {'date': instance.date, 'time': instance.time, 'status': instance.status}
    if created or (old and old != schedule):
        text = f'Your appointment was {"requested" if created else "updated"}. Open Hearteli to review the date, time and status. Appointment times use UTC unless the provider confirms another timezone.'
        for user in (instance.user, instance.therapist):
            queue_email(user, 'appointment', 'Your Hearteli appointment update', text,
                key=f'appointment:{instance.pk}:{user.pk}:{instance.date}:{instance.time}:{instance.status}', path='/notifications/', target_id=instance.pk)


@receiver(pre_save, sender=WorkspaceMembership)
def membership_previous(sender, instance, **kwargs):
    instance._old_member_status = sender.objects.filter(pk=instance.pk).values_list('status', flat=True).first() if instance.pk else None


@receiver(post_save, sender=WorkspaceMembership)
def membership_events(sender, instance, created, raw=False, **kwargs):
    if raw or instance.user_id == instance.workspace.owner_id:
        return
    if created or getattr(instance, '_old_member_status', instance.status) != instance.status:
        queue_email(instance.user, 'workspace', 'Your Hearteli workspace membership',
            f'Your membership in {instance.workspace.name} is {instance.status}. Joining a workplace does not give anyone access to your personal check-ins.',
            key=f'workspace:{instance.pk}:{instance.status}', path='/notifications/', target_id=instance.pk)


@receiver(post_save, sender=WorkspaceRoleAudit)
def role_changed(sender, instance, created, raw=False, **kwargs):
    if created and not raw and instance.member_id:
        CircleConnection.objects.filter(recipient_id=instance.member_id, relationship__iexact='manager',
            owner__workspace_memberships__workspace=instance.workspace).update(
            may_receive_nudges=False, may_receive_preference=False, ask_on_pattern=False)
        queue_email(instance.member, 'workspace_role', 'Your Hearteli workspace role changed',
            'Your workspace role changed. Review any support permissions before sharing again. Personal check-ins stay private.',
            key=f'role:{instance.pk}', path='/notifications/')


@receiver(post_save,sender=AppointmentMessage)
def appointment_message_event(sender,instance,created,raw=False,**kwargs):
    if created and not raw:
        a=instance.appointment
        other=a.therapist if instance.author_id==a.user_id else a.user
        queue_email(other,'appointment_message','A private Hearteli session message',
            'You have a new appointment message. Sign in to read it privately.',
            key=f'appointment-message:{instance.pk}',path=f'/practice/appointments/{a.pk}/',target_id=a.pk)
