from django.contrib.auth.decorators import login_required
from django.shortcuts import render,redirect,get_object_or_404
from django.http import HttpResponseForbidden
from django.views.decorators.http import require_POST, require_http_methods
from django.db import transaction
from .work_web import admin_workspace
from .models import WorkspaceMembership, WorkspaceRoleAudit
from apps.users.models import BusinessSubscription

from django import forms
from django.contrib import messages
from django.urls import reverse
from django.http import Http404
from .models import Workspace

class WorkspaceSettingsForm(forms.ModelForm):
    name=forms.CharField(min_length=2,max_length=120,label='Workspace name')
    description=forms.CharField(max_length=500,required=False,widget=forms.Textarea(attrs={'rows':4}))
    class Meta:
        model=Workspace
        fields=['name','description']

class RotateInviteForm(forms.Form):
    confirm_rotate=forms.BooleanField(label='I understand that the previous invitation code will stop working.')

PAGE_TITLES={'overview':'Overview','members':'Members & roles','resources':'Support resources','insights':'Insights','privacy':'Privacy & access','billing':'Plans & billing','settings':'Workspace settings'}

def workspace_context(workspace,user,section):
    owner=workspace.owner_id==user.pk
    navigation=[]
    for key,label in PAGE_TITLES.items():
        if key in ('billing','settings') and not owner: continue
        url=reverse('business-billing',args=[workspace.pk]) if key=='billing' else reverse('hearteli-work-dashboard',args=[workspace.pk]) if key=='overview' else reverse('business-page',args=[workspace.pk,key])
        navigation.append({'label':label,'url':url,'active':key==section})
    members=workspace.memberships.select_related('user')
    return {'workspace':workspace,'section':section,'page_title':PAGE_TITLES[section],
        'is_owner':owner,'workspace_navigation':navigation,'members':members,
        'approved_count':members.filter(status='approved').count(),
        'pending_count':members.filter(status='pending').count(),
        'resources':workspace.resources.all(),
        'subscription':BusinessSubscription.objects.filter(workspace=workspace).select_related('plan').first(),
        'role_events':workspace.role_events.select_related('actor','member').order_by('-created_at')[:30]}

@login_required(login_url='/work/login/')
@require_http_methods(['GET','POST'])
def page(request,pk,section='overview'):
    if section not in PAGE_TITLES or section=='billing': raise Http404()
    workspace=admin_workspace(request.user,pk)
    if workspace is None: return HttpResponseForbidden('Workspace administrator access required.')
    owner=workspace.owner_id==request.user.pk
    if section=='settings' and not owner: return HttpResponseForbidden('Owner access required.')
    if request.method=='POST' and section!='settings': return HttpResponseForbidden('Use the section action form.')
    action=request.POST.get('action','details')
    settings_form=WorkspaceSettingsForm(request.POST if request.method=='POST' and action=='details' else None,instance=workspace)
    rotate_form=RotateInviteForm(request.POST if request.method=='POST' and action=='rotate_invite' else None)
    if request.method=='POST':
        if action=='details' and settings_form.is_valid():
            settings_form.save();messages.success(request,'Workspace details saved.')
            return redirect('business-page',pk=pk,section='settings')
        elif action=='rotate_invite' and rotate_form.is_valid():
            import uuid
            workspace.invite_code=uuid.uuid4().hex[:12].upper()
            workspace.save(update_fields=['invite_code'])
            messages.success(request,'A new invite code is ready. The previous code no longer works.')
            return redirect('business-page',pk=pk,section='settings')
        elif action not in ('details','rotate_invite'): return HttpResponseForbidden('Unknown settings action.')
    context=workspace_context(workspace,request.user,section)
    context.update(settings_form=settings_form,rotate_form=rotate_form)
    return render(request,f'work/{section}.html',context)

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
