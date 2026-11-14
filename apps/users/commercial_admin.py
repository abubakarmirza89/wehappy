import csv,hashlib,secrets
from django.contrib import admin,messages
from django.http import HttpResponse
from django.utils import timezone
from django.db.models import Count,Q
from .models import MarketplacePolicy,SessionOffering,CommercialAudit,OrganisationInvitation,InvitationRedemption,SponsorCampaign,SponsorEventTicket,BusinessSubscription,Therapist,Feedback,BillingPlan

class AuditedAdmin(admin.ModelAdmin):
    def save_model(self,request,obj,form,change):
        super().save_model(request,obj,form,change)
        CommercialAudit.objects.create(actor=request.user,object_type=obj.__class__.__name__,object_id=str(obj.pk),action='updated' if change else 'created')
    def delete_model(self,request,obj):
        CommercialAudit.objects.create(actor=request.user,object_type=obj.__class__.__name__,object_id=str(obj.pk),action='deleted')
        super().delete_model(request,obj)
    def delete_queryset(self,request,queryset):
        for obj in queryset:self.delete_model(request,obj)

@admin.register(MarketplacePolicy)
class PolicyAdmin(AuditedAdmin):
    def has_add_permission(self,request):return not MarketplacePolicy.objects.exists() and super().has_add_permission(request)
    def has_delete_permission(self,request,obj=None):return False
    def save_model(self,request,obj,form,change):obj.pk=1;super().save_model(request,obj,form,change)

@admin.register(SessionOffering)
class OfferingAdmin(AuditedAdmin):
    list_display=['therapist','duration_minutes','fee','approved','active']
    readonly_fields=['reviewed_by']
    def save_model(self,request,obj,form,change):
        if obj.approved:obj.reviewed_by=request.user
        super().save_model(request,obj,form,change)

admin.site.unregister(BusinessSubscription)
@admin.register(BusinessSubscription)
class ManualSubscriptionAdmin(AuditedAdmin):
    list_display=['workspace','organisation_type','effective_status','starts_at','period_end','invoice_reference','agreed_amount','currency']
    list_filter=['manual_status','organisation_type']
    exclude=['stripe_subscription_id','customer_id','checkout_session_id','status','cancel_at_period_end']
    actions=['activate','suspend','renew_30_days']
    def save_model(self,request,obj,form,change):
        if obj.period_end and obj.period_end<=timezone.now() and obj.manual_status=='active':obj.manual_status='expired';obj.organisation_status='expired'
        super().save_model(request,obj,form,change)
    def update_status(self,request,queryset,status,renew=False):
        for obj in queryset:
            if renew:obj.period_end=max(obj.period_end or timezone.now(),timezone.now())+timezone.timedelta(days=30)
            if status=='active' and (not obj.period_end or obj.period_end<=timezone.now()):
                self.message_user(request,'Set a future expiry before activation.',messages.ERROR);continue
            obj.manual_status=status
            if status=='active':obj.organisation_status='active'
            elif status=='suspended':obj.organisation_status='paused'
            obj.save()
            CommercialAudit.objects.create(actor=request.user,object_type='BusinessSubscription',object_id=str(obj.pk),action='renewed' if renew else status)
    @admin.action(description='Activate selected manual subscriptions')
    def activate(self,request,queryset):self.update_status(request,queryset,'active')
    @admin.action(description='Suspend selected subscriptions')
    def suspend(self,request,queryset):self.update_status(request,queryset,'suspended')
    @admin.action(description='Renew selected subscriptions for 30 days')
    def renew_30_days(self,request,queryset):self.update_status(request,queryset,'active',True)

@admin.register(OrganisationInvitation)
class InviteAdmin(AuditedAdmin):
    list_display=['workspace','expires_at','max_redemptions','revoked_at']
    exclude=['token_hash']
    readonly_fields=['created_by','created_at']
    actions=['revoke']
    def save_model(self,request,obj,form,change):
        if not change:
            token=secrets.token_urlsafe(32);obj.token_hash=hashlib.sha256(token.encode()).hexdigest();obj.created_by=request.user
            self.message_user(request,'Copy this invitation token now; it is not stored in plain text: '+token)
        super().save_model(request,obj,form,change)
    @admin.action(description='Revoke selected invitations')
    def revoke(self,request,queryset):
        for obj in queryset:
            obj.revoked_at=timezone.now();obj.save();CommercialAudit.objects.create(actor=request.user,object_type='OrganisationInvitation',object_id=str(obj.pk),action='revoked')

@admin.register(SponsorCampaign)
class CampaignAdmin(AuditedAdmin):
    list_display=['name','sponsor_name','placement','status','starts_at','ends_at','impressions','clicks','ctr','booking_starts','confirmed_bookings']
    list_filter=['placement','status']
    date_hierarchy='starts_at'
    readonly_fields=['approved_by','impressions','clicks','ctr','booking_starts','confirmed_bookings']
    actions=['approve','pause','resume','export_report']
    def impressions(self,obj):return obj.tickets.filter(shown_at__isnull=False).count()
    def clicks(self,obj):return obj.tickets.filter(clicked_at__isnull=False).count()
    def booking_starts(self,obj):return obj.tickets.filter(booking_started_at__isnull=False).count()
    def confirmed_bookings(self,obj):
        from .models import SponsorBookingAttribution
        return SponsorBookingAttribution.objects.filter(ticket__campaign=obj,appointment__payment_status='paid').count()
    def ctr(self,obj):
        impressions=self.impressions(obj)
        return round(100*self.clicks(obj)/impressions,2) if impressions else 0
    def save_model(self,request,obj,form,change):
        if obj.status in ('active','approved'):obj.approved_by=request.user
        obj.full_clean();super().save_model(request,obj,form,change)
    def change_status(self,request,queryset,state):
        for obj in queryset:
            obj.status=state
            if state in ('active','approved'):obj.approved_by=request.user
            obj.full_clean();obj.save();CommercialAudit.objects.create(actor=request.user,object_type='SponsorCampaign',object_id=str(obj.pk),action=state)
    @admin.action(description='Approve selected campaigns')
    def approve(self,request,queryset):self.change_status(request,queryset,'approved')
    @admin.action(description='Pause selected campaigns')
    def pause(self,request,queryset):self.change_status(request,queryset,'paused')
    @admin.action(description='Resume selected campaigns')
    def resume(self,request,queryset):self.change_status(request,queryset,'active')
    @admin.action(description='Export aggregate campaign report CSV')
    def export_report(self,request,queryset):
        response=HttpResponse(content_type='text/csv');response['Content-Disposition']='attachment; filename="sponsor-report.csv"'
        writer=csv.writer(response);writer.writerow(['Campaign ID','Start UTC','End UTC','Impressions','Clicks','CTR percent','Booking starts','Confirmed bookings'])
        for obj in queryset:writer.writerow([obj.pk,obj.starts_at.isoformat(),obj.ends_at.isoformat(),self.impressions(obj),self.clicks(obj),self.ctr(obj),self.booking_starts(obj),self.confirmed_bookings(obj)])
        return response

admin.site.unregister(Feedback)
@admin.register(Feedback)
class ModeratedReviewAdmin(AuditedAdmin):
    list_display=['therapist','rating','moderation_status','public_visibility','submitted_at']
    readonly_fields=['user','therapist','appointment','rating','comment','submitted_at']
    list_filter=['moderation_status','public_visibility']
    def has_add_permission(self,request):return False

admin.site.unregister(Therapist)
@admin.register(Therapist)
class VerificationAdmin(AuditedAdmin):
    list_display = ['user', 'verification_status', 'verification_expires_at',
                    'directory_published_at', 'availability_status', 'last_activity_confirmation',
                    'activity_status', 'last_login']
    readonly_fields = ['verified_by', 'verified_at', 'directory_published_at',
                       'last_activity_confirmation', 'last_availability_update', 'referral_code', 'last_login']
    actions = ['publish_directory', 'unpublish_directory']

    def last_login(self, obj):
        return obj.user.last_login

    def save_model(self, request, obj, form, change):
        credential_fields = {
            'verification_status', 'verification_expires_at', 'verification_evidence',
            'registration_body', 'registration_number', 'practitioner_type',
        }
        if credential_fields.intersection(form.changed_data):
            obj.directory_published_at = None
        if obj.verification_status == 'verified' and (
            not obj.verified_at or credential_fields.intersection(form.changed_data)
        ):
            obj.verified_by = request.user
            obj.verified_at = timezone.now()
        super().save_model(request, obj, form, change)

    @admin.action(permissions=['change'], description='Publish selected reviewed profiles to the directory')
    def publish_directory(self, request, queryset):
        from django.db import transaction
        with transaction.atomic():
            for obj in queryset.select_for_update().select_related('user'):
                if not obj.verified or not obj.user.is_active or not obj.user.is_therapist:
                    self.message_user(request, f'{obj.user.name} was not published: active professional verification is required.', messages.ERROR)
                    continue
                if obj.directory_published_at is None:
                    obj.directory_published_at = timezone.now()
                    obj.save(update_fields=['directory_published_at'])
                    CommercialAudit.objects.create(actor=request.user, object_type='Therapist',
                                                   object_id=str(obj.pk), action='directory_published')
                    self.message_user(request, f'{obj.user.name} is approved for directory publication.')

    @admin.action(permissions=['change'], description='Unpublish selected directory profiles')
    def unpublish_directory(self, request, queryset):
        from django.db import transaction
        with transaction.atomic():
            for obj in queryset.select_for_update().filter(directory_published_at__isnull=False):
                obj.directory_published_at = None
                obj.save(update_fields=['directory_published_at'])
                CommercialAudit.objects.create(actor=request.user, object_type='Therapist',
                                               object_id=str(obj.pk), action='directory_unpublished')


@admin.register(CommercialAudit)
class AuditAdmin(admin.ModelAdmin):
    list_display=['actor','object_type','object_id','action','created_at']
    def has_add_permission(self,request):return False
    def has_change_permission(self,request,obj=None):return False
    def has_delete_permission(self,request,obj=None):return False

from .models import ReviewReport
@admin.register(ReviewReport)
class ReviewReportAdmin(AuditedAdmin):
    list_display=['review','created_at']
    readonly_fields=['review','reporter','reason','created_at']
    def has_add_permission(self,request):return False
