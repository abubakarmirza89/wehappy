"""Event hooks only create durable rows; external sends happen in the worker."""
from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from apps.users.models import User, Appointment
from apps.tracking.models import CircleConnection, EmpathyNudge, NudgeMessage, WorkspaceMembership, WorkspaceRoleAudit
from .communications import queue_email


@receiver(post_save, sender=User)
def welcome(sender, instance, created, raw=False, **kwargs):
    if created and not raw:
        queue_email(instance, 'welcome', 'Welcome to Hearteli',
            'Welcome to Hearteli. Start with a private check-in, then choose the people you trust. You control what you share.',
            key=f'welcome:{instance.pk}', path='/')


@receiver(post_save, sender=CircleConnection)
def circle_invite(sender, instance, created, raw=False, **kwargs):
    if created and not raw:
        queue_email(instance.recipient, 'circle_invite', 'You have a Hearteli Circle invitation',
            f'{instance.owner.name} invited you to their Hearteli Circle. Open Hearteli to accept or decline. No check-in data is shared by accepting alone.',
            key=f'circle:{instance.pk}', path='/notifications/', target_id=instance.pk)


@receiver(pre_save, sender=EmpathyNudge)
def nudge_previous(sender, instance, raw=False, **kwargs):
    instance._old_status = sender.objects.filter(pk=instance.pk).values_list('status', flat=True).first() if instance.pk else None


@receiver(post_save, sender=EmpathyNudge)
def nudge_events(sender, instance, created, raw=False, **kwargs):
    if raw:
        return
    if created:
        queue_email(instance.recipient, 'nudge', 'A gentle check-in from Hearteli',
            'Someone you care about could use a check-in. Sign in to see only the details they chose to share.',
            key=f'nudge:{instance.pk}', path=f'/notifications/nudges/{instance.pk}/', target_id=instance.pk, sensitive=True)
        sender.objects.filter(pk=instance.pk).update(delivery_status='queued')
    elif getattr(instance, '_old_status', instance.status) != instance.status and instance.status in ('acknowledged', 'cannot_help'):
        text = 'Your person acknowledged your nudge. This is an intention to respond, not confirmation that support has happened.' if instance.status == 'acknowledged' else 'Your person cannot help right now. You can choose another person you have authorised.'
        queue_email(instance.sender, 'acknowledgement', 'An update on your Hearteli nudge', text,
            key=f'ack:{instance.pk}:{instance.status}', path=f'/notifications/nudges/{instance.pk}/', target_id=instance.pk)


@receiver(post_save, sender=NudgeMessage)
def support_message(sender, instance, created, raw=False, **kwargs):
    if created and not raw:
        other = instance.nudge.recipient if instance.author_id == instance.nudge.sender_id else instance.nudge.sender
        queue_email(other, 'support_message', 'A new Hearteli support message',
            'You have a new support message. Sign in to read it privately.',
            key=f'support-message:{instance.pk}', path=f'/notifications/nudges/{instance.nudge_id}/', target_id=instance.nudge_id, sensitive=True)


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
