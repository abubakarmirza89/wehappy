from rest_framework.exceptions import APIException
from django.utils import timezone
from apps.users.models import BusinessSubscription
from .models import WorkspaceMembership, WorkspaceSignupInvitation

class SubscriptionRequired(APIException):
    status_code=402
    default_detail='An active workspace subscription is required. Open Plans & billing.'

def require_subscription(workspace, adding_member=False, invite_email=''):
    if workspace.workspace_type!='office': return
    sub=BusinessSubscription.objects.filter(workspace=workspace).select_related('plan').first()
    if not sub or not sub.entitled: raise SubscriptionRequired()
    if adding_member:
        now = timezone.now()
        if invite_email and WorkspaceSignupInvitation.objects.filter(
            workspace=workspace, email__iexact=invite_email, claimed_at__isnull=True,
            expires_at__gt=now,
        ).exists():
            adding_member = False
        member_count = workspace.memberships.exclude(status='rejected').exclude(
            user_id=workspace.owner_id
        ).count()
        invitation_count = WorkspaceSignupInvitation.objects.filter(
            workspace=workspace, claimed_at__isnull=True, expires_at__gt=now,
        ).exclude(email__in=workspace.memberships.values_list('user__email', flat=True)).values(
            'email'
        ).distinct().count()
        if adding_member and member_count + invitation_count >= sub.plan.member_limit:
            raise SubscriptionRequired('Your plan member limit is reached. Upgrade before inviting more members.')

class SubscriptionGateMiddleware:
    def __init__(self,get_response): self.get_response=get_response
    def __call__(self,request): return self.get_response(request)
    def process_view(self,request,view_func,view_args,view_kwargs):
        if request.method!='POST' or not request.user.is_authenticated: return None
        import re
        from django.http import JsonResponse
        from django.contrib import messages
        from django.shortcuts import redirect
        from .models import Workspace
        match=re.fullmatch(r'/work/(\d+)/(invite/|approve/\d+/|resources/)',request.path)
        api=re.fullmatch(r'/api/tracking/workspaces/(\d+)/(bulk_invite|approve_member)/',request.path)
        hit=match or api
        if not hit: return None
        workspace=Workspace.objects.filter(pk=hit.group(1),owner=request.user).first()
        if not workspace: return None  # View retains its normal ownership checks.
        try:
            require_subscription(
                workspace,
                adding_member=('invite' in request.path),
                invite_email=request.POST.get('email', '').strip(),
            )
        except SubscriptionRequired as exc:
            if match:
                messages.error(request, str(exc.detail))
                section = 'resources' if 'resources/' in request.path else 'members'
                return redirect('business-page', pk=workspace.pk, section=section)
            return JsonResponse({'detail':str(exc.detail)},status=402)
        return None
