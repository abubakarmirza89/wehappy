from rest_framework.exceptions import APIException
from apps.users.models import BusinessSubscription

class SubscriptionRequired(APIException):
    status_code=402
    default_detail='An active workspace subscription is required. Open Plans & billing.'

def require_subscription(workspace, adding_member=False):
    if workspace.workspace_type!='office': return
    sub=BusinessSubscription.objects.filter(workspace=workspace).select_related('plan').first()
    if not sub or not sub.entitled: raise SubscriptionRequired()
    if adding_member and workspace.memberships.exclude(status='rejected').exclude(user_id=workspace.owner_id).count()>=sub.plan.member_limit:
        raise SubscriptionRequired('Your plan member limit is reached. Upgrade before inviting more members.')

class SubscriptionGateMiddleware:
    def __init__(self,get_response): self.get_response=get_response
    def __call__(self,request): return self.get_response(request)
    def process_view(self,request,view_func,view_args,view_kwargs):
        if request.method!='POST' or not request.user.is_authenticated: return None
        import re
        from django.http import JsonResponse
        from .models import Workspace
        match=re.fullmatch(r'/work/(\d+)/(invite/|approve/\d+/|resources/)',request.path)
        api=re.fullmatch(r'/api/tracking/workspaces/(\d+)/(bulk_invite|approve_member)/',request.path)
        hit=match or api
        if not hit: return None
        workspace=Workspace.objects.filter(pk=hit.group(1),owner=request.user).first()
        if not workspace: return None  # View retains its normal ownership checks.
        try: require_subscription(workspace,adding_member=('invite' in request.path))
        except SubscriptionRequired as exc: return JsonResponse({'detail':str(exc.detail)},status=402)
        return None
