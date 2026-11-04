from django.contrib.auth.decorators import login_required,permission_required
from django.shortcuts import render,get_object_or_404,redirect
from django.http import FileResponse,HttpResponseForbidden
from django.core import signing
from rest_framework.request import Request
from .marketplace import MarketplaceSearchView,SearchFilters,eligible_profiles
from .models import Therapist,SponsorEventTicket,SponsorCampaign
from .monetisation import campaign_eligible
from django.utils import timezone

@login_required(login_url='/practice/login/')
def search(request):
    wrapped=Request(request);wrapped.user=request.user
    view=MarketplaceSearchView()
    filters=SearchFilters(data=request.GET)
    if filters.is_valid():data=view.get(wrapped).data;error=None
    else:data={'sponsored':[],'organic':[]};error='Check your search filters and try again.'
    return render(request,'practice/marketplace.html',{'results':data,'search_error':error,'filters':request.GET})

@permission_required('users.view_therapist',raise_exception=True)
def preview(request):
    t=Therapist.objects.select_related('user').first()
    return render(request,'practice/marketplace_preview.html',{'provider':t,'states':[{'sponsored':True,'verified':True},{'sponsored':True,'verified':False},{'sponsored':False,'verified':True},{'sponsored':False,'verified':False}]})

@permission_required('users.view_therapist',raise_exception=True)
def credential(request,token):
    try:name=signing.loads(token,salt='credential-download')
    except signing.BadSignature:return HttpResponseForbidden()
    p=get_object_or_404(Therapist,verification_evidence=name)
    return FileResponse(p.verification_evidence.open('rb'),as_attachment=True,filename='credential-evidence')


@login_required(login_url='/practice/login/')
def creative(request,ticket):
    from .monetisation import viewer_hash
    t=get_object_or_404(SponsorEventTicket,pk=ticket,expires_at__gt=timezone.now())
    if t.viewer_hash!=viewer_hash(request.user):return HttpResponseForbidden()
    if not campaign_eligible(t.campaign) or not t.campaign.creative:return HttpResponseForbidden()
    response=FileResponse(t.campaign.creative.open('rb'))
    response['Cache-Control']='private, no-store';return response

@permission_required('users.view_sponsorcampaign',raise_exception=True)
def admin_creative(request,token):
    try:name=signing.loads(token,salt='sponsor-asset-download')
    except signing.BadSignature:return HttpResponseForbidden()
    campaign=get_object_or_404(SponsorCampaign,creative=name)
    response=FileResponse(campaign.creative.open('rb'),as_attachment=True)
    response['Cache-Control']='private, no-store'
    return response
