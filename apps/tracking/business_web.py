from django.contrib.auth.decorators import login_required
from django.shortcuts import render,redirect,get_object_or_404
from django.http import HttpResponseForbidden
from django.views.decorators.http import require_POST
from django.db import transaction
from .work_web import admin_workspace
from .models import WorkspaceMembership, WorkspaceRoleAudit
from apps.users.models import BusinessSubscription

@login_required(login_url='/work/login/')
def page(request,pk,section='overview'):
    if section not in ('overview','members','resources','insights','settings'): return HttpResponseForbidden()
    workspace=admin_workspace(request.user,pk)
    if workspace is None: return HttpResponseForbidden()
    owner=workspace.owner_id==request.user.pk
    if request.method=='POST' and section=='settings' and owner:
        name=request.POST.get('name','').strip()
        if 2<=len(name)<=120:
            workspace.name=name;workspace.description=request.POST.get('description','')[:500];workspace.save(update_fields=['name','description'])
            return redirect('business-page',pk=pk,section='settings')
    members=workspace.memberships.select_related('user')
    return render(request,'work/business.html',{'workspace':workspace,'section':section,'is_owner':owner,
        'members':members,'approved_count':members.filter(status='approved').count(),
        'pending_count':members.filter(status='pending').count(),'resources':workspace.resources.all(),
        'subscription':BusinessSubscription.objects.filter(workspace=workspace).select_related('plan').first(),
        'role_events':workspace.role_events.select_related('actor','member').order_by('-created_at')[:30]})

@login_required(login_url='/work/login/')
@require_POST
def deactivate(request,pk,member_id):
    workspace=admin_workspace(request.user,pk)
    if not workspace or workspace.owner_id!=request.user.pk: return HttpResponseForbidden()
    with transaction.atomic():
        member=get_object_or_404(WorkspaceMembership.objects.select_for_update(),pk=member_id,workspace=workspace)
        if member.user_id==workspace.owner_id: return HttpResponseForbidden()
        member.status='rejected';member.can_share_mood_with_manager=False;member.save()
        WorkspaceRoleAudit.objects.create(workspace=workspace,actor=request.user,member=member.user,from_role=member.role,to_role='deactivated')
    return redirect('business-page',pk=pk,section='members')
