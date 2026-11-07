import hashlib,secrets
from django.conf import settings
from django.db import transaction
from django.utils import timezone
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.exceptions import ValidationError,PermissionDenied
from django.shortcuts import get_object_or_404
from apps.tracking.models import Workspace,WorkspaceMembership,EmpathyNudge,CircleConnection
from .models import SponsorCampaign,SponsorEventTicket,OrganisationInvitation,InvitationRedemption,BusinessSubscription
from .marketplace import eligible_profiles
from .models import MarketplacePolicy
from apps.tracking.models import HearteliPreferences


def viewer_hash(user):
    import hmac
    return hmac.new(settings.SECRET_KEY.encode(),str(user.pk).encode(),hashlib.sha256).hexdigest()


def active_campaigns(placement):
    now=timezone.now()
    return SponsorCampaign.objects.filter(placement=placement,status__in=['active','approved'],approved_by__isnull=False,starts_at__lte=now,ends_at__gt=now).order_by('-priority','pk')


def campaign_eligible(campaign,check_cap=True):
    if not active_campaigns(campaign.placement).filter(pk=campaign.pk).exists():return False
    if campaign.benefit_subscription_id and not campaign.benefit_subscription.entitled:return False
    if campaign.placement=='search' and not eligible_profiles().filter(pk=campaign.therapist_id).exists():return False
    if check_cap and campaign.impression_cap and campaign.tickets.filter(shown_at__isnull=False).count()>=campaign.impression_cap:return False
    return True


def ticket_payload(campaign,user,context_id=None):
    hashed=viewer_hash(user)
    if campaign.per_recipient_cap and campaign.tickets.filter(viewer_hash=hashed,shown_at__isnull=False).count()>=campaign.per_recipient_cap:return None
    ticket=SponsorEventTicket.objects.create(campaign=campaign,viewer_hash=hashed,placement=campaign.placement,context_id=context_id,expires_at=min(campaign.ends_at,timezone.now()+timezone.timedelta(minutes=10)))
    return {'event_id':str(ticket.pk),'campaign_id':campaign.pk,'sponsor_name':campaign.sponsor_name,
        'label':'Sponsored','ends_at':campaign.ends_at.isoformat(),'creative_url':__import__('django.urls',fromlist=['reverse']).reverse('sponsor-creative',args=[ticket.pk]) if campaign.creative else None,'destination':campaign.destination}


def adult(user):
    if not user.date_of_birth:return False
    today=timezone.now().date();dob=user.date_of_birth
    return today.year-dob.year-((today.month,today.day)<(dob.month,dob.day))>=18


def nudge_access(user,pk):
    n=get_object_or_404(EmpathyNudge,pk=pk,recipient=user)
    if not CircleConnection.objects.filter(owner=n.sender,recipient=user,accepted_at__isnull=False,may_receive_nudges=True).exists():raise PermissionDenied('Update unavailable.')
    return n


class NudgeSponsorView(APIView):
    permission_classes=[IsAuthenticated]
    def get(self,request,pk):
        n=nudge_access(request.user,pk)
        if n.delivery_status!='opened' or not nudge_sponsor_eligible(n,request.user):return Response(None)
        for campaign in active_campaigns('nudge'):
            if campaign_eligible(campaign):
                payload=ticket_payload(campaign,request.user,n.pk)
                if payload:return Response(payload)
        return Response(None)


def nudge_sponsor_eligible(n,user):
    policy=MarketplacePolicy.current()
    return policy.nudge_sponsors_enabled and bool(policy.nudge_ad_policy_reference) and n.support_context=='ordinary' and adult(user) and adult(n.sender) and HearteliPreferences.objects.filter(user=user,sponsor_opt_in=True).exists()



class SponsorEventView(APIView):
    permission_classes=[IsAuthenticated]
    def post(self,request):
        with transaction.atomic():
            import uuid
            try: ticket_id=uuid.UUID(str(request.data.get('event_id')))
            except (TypeError,ValueError,AttributeError):raise ValidationError('Invalid event ID.')
            t=get_object_or_404(SponsorEventTicket.objects.select_for_update(),pk=ticket_id,viewer_hash=viewer_hash(request.user))
            c=SponsorCampaign.objects.select_for_update().get(pk=t.campaign_id)
            kind=request.data.get('event_type')
            if kind not in ('impression','click','booking_start'):raise ValidationError('Choose impression or click.')
            if t.expires_at<=timezone.now() or not campaign_eligible(c,check_cap=False):raise ValidationError('Campaign is not available.')
            if t.placement=='nudge':
                n=nudge_access(request.user,t.context_id)
                if n.delivery_status!='opened' or not nudge_sponsor_eligible(n,request.user):raise ValidationError('This placement is not currently eligible.')
            if kind=='impression' and t.shown_at is None:
                if c.impression_cap and c.tickets.filter(shown_at__isnull=False).count()>=c.impression_cap:raise ValidationError('Campaign impression cap reached.')
                try: visibility=float(request.data.get('visible_fraction',0));duration=int(request.data.get('visible_ms',0))
                except (ValueError,TypeError):raise ValidationError('Invalid visibility measurement.')
                if visibility<.5 or duration<1000:raise ValidationError('At least 50% visibility for one continuous second is required.')
                if c.per_recipient_cap and c.tickets.filter(viewer_hash=t.viewer_hash,shown_at__isnull=False).count()>=c.per_recipient_cap:raise ValidationError('Frequency limit reached.')
                t.shown_at=timezone.now()
            if kind=='booking_start':
                if t.placement!='search' or t.shown_at is None:raise ValidationError('A visible search placement is required.')
                if t.booking_started_at is None:t.booking_started_at=timezone.now()
            if kind=='click':
                if t.shown_at is None:raise ValidationError('Record a qualifying impression first.')
                if t.clicked_at is None:t.clicked_at=timezone.now()
            t.save();return Response({'recorded':True,'destination':c.destination if kind=='click' else None})


class RedeemOrganisationInvite(APIView):
    permission_classes=[IsAuthenticated]
    def post(self,request):
        token=request.data.get('token','')
        if not isinstance(token,str) or len(token)>256:raise ValidationError('Invalid invitation.')
        with transaction.atomic():
            invitation=get_object_or_404(OrganisationInvitation.objects.select_for_update(),token_hash=hashlib.sha256(token.encode()).hexdigest())
            workspace=Workspace.objects.select_for_update().get(pk=invitation.workspace_id)
            now=timezone.now()
            sub=BusinessSubscription.objects.filter(workspace=workspace).select_related('plan').first()
            if invitation.revoked_at or invitation.expires_at<=now or not sub or not sub.entitled:raise ValidationError('Invitation or organisation access is expired or unavailable.')
            prior=WorkspaceMembership.objects.filter(workspace=workspace,user=request.user).first()
            if prior:return Response({'workspace_id':workspace.pk,'status':prior.status,'already_joined':True})
            if invitation.redemptions.count()>=invitation.max_redemptions or workspace.memberships.exclude(status='rejected').exclude(user_id=workspace.owner_id).count()>=sub.plan.member_limit:raise ValidationError('Invitation capacity reached.')
            member=WorkspaceMembership.objects.create(workspace=workspace,user=request.user,role='employee',status='approved',joined_at=now)
            InvitationRedemption.objects.create(invitation=invitation,user=request.user)
            return Response({'workspace_id':workspace.pk,'status':member.status},status=201)


def attribute_booking(appointment,event_id):
    if not event_id:return
    import uuid
    from .models import SponsorBookingAttribution
    try:event_id=uuid.UUID(str(event_id))
    except (ValueError,TypeError):return
    ticket=SponsorEventTicket.objects.filter(pk=event_id,viewer_hash=viewer_hash(appointment.user),placement='search',shown_at__isnull=False,expires_at__gt=timezone.now(),campaign__therapist__user_id=appointment.therapist_id).first()
    if ticket and campaign_eligible(ticket.campaign,check_cap=False):
        SponsorBookingAttribution.objects.get_or_create(appointment=appointment,defaults={'ticket':ticket})
        if ticket.booking_started_at is None:ticket.booking_started_at=timezone.now();ticket.save(update_fields=['booking_started_at'])
