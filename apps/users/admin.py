from django.contrib import admin
from django import forms
from django.contrib.auth import admin as auth_admin
from django.contrib.auth import get_user_model
from django.utils.translation import gettext_lazy as _

from apps.users.forms import UserAdminChangeForm, UserAdminCreationForm

from .models import (
    Appointment,
    Brain_Health_Score,
    DeviceToken,
    Feedback,
    Send_To_Relative,
    Suggestion_Therapist,
    Therapist,
    UserHistory,
    WithdrawalRequest,
)

User = get_user_model()


@admin.register(User)
class UserAdmin(auth_admin.UserAdmin):
    form = UserAdminChangeForm
    add_form = UserAdminCreationForm
    fieldsets = (
        (None, {"fields": ("email", "password")}),
        (
            _("Personal info"),
            {
                "fields": (
                    "name",
                    "date_of_birth",
                    "is_therapist",
                )
            },
        ),
        (
            _("Permissions"),
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "groups",
                    "user_permissions",
                ),
            },
        ),
        (_("Important dates"), {"fields": ("last_login", "date_joined")}),
    )
    list_display = ["email", "name", "is_superuser", "is_active", "is_therapist", "brain_health_score"]
    search_fields = ["name"]
    ordering = ["id"]
    list_editable = ["is_active"]
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": ("email", "password1", "password2"),
            },
        ),
    )


admin.site.register(Brain_Health_Score)
admin.site.register(DeviceToken)


class WithdrawalAdminForm(forms.ModelForm):
    class Meta:
        model=WithdrawalRequest
        fields='__all__'
    def clean(self):
        data=super().clean()
        if data.get('status')=='paid' and not data.get('payout_reference'):
            self.add_error('payout_reference','Record the verified bank/provider payout reference first.')
        if self.instance.pk and WithdrawalRequest.objects.filter(pk=self.instance.pk,status='paid').exists() and data.get('status')!='paid':
            self.add_error('status','Paid withdrawals cannot be changed.')
        return data

@admin.register(WithdrawalRequest)
class WithdrawalRequestAdmin(admin.ModelAdmin):
    form=WithdrawalAdminForm
    list_display = ['therapist', 'amount', 'status', 'created_at', 'processed_at']
    list_filter = ['status']
    search_fields = ['therapist__email', 'payout_account']
    readonly_fields=['therapist','amount','payout_account','created_at','processed_at','processed_by']
    def has_add_permission(self,request): return False
    def has_delete_permission(self,request,obj=None): return False
    def save_model(self,request,obj,form,change):
        from django.core.exceptions import ValidationError
        from django.utils import timezone
        with transaction.atomic():
            old=WithdrawalRequest.objects.select_for_update().get(pk=obj.pk)
            if old.status=='paid' and obj.status!='paid': raise ValidationError('Paid withdrawals are immutable.')
            if obj.status=='paid' and not obj.payout_reference: raise ValidationError('Record the verified provider/bank payout reference before marking paid.')
            if obj.status!=old.status:
                obj.processed_at=timezone.now();obj.processed_by=request.user
            super().save_model(request,obj,form,change)


@admin.register(Send_To_Relative)
class Send_To_RelativeAdmin(admin.ModelAdmin):
    pass


@admin.register(Suggestion_Therapist)
class Suggestion_TherapistAdmin(admin.ModelAdmin):
    pass


@admin.register(Appointment)
class AppointmentAdmin(admin.ModelAdmin):
    pass


@admin.register(Feedback)
class FeedBackAdmin(admin.ModelAdmin):
    list_display = ("rating", "comment", "user", "therapist")
    # readonly_fields = ["rating", "comment", "therapist", "user"]


@admin.register(Therapist)
class TherapistAdmin(admin.ModelAdmin):
    list_display = ("user", "hourly_rate", "is_available")
    list_filter = ("is_available",)


@admin.register(UserHistory)
class UserHistoryAdmin(admin.ModelAdmin):
    pass

from .models import EmailDelivery, Notification

@admin.register(EmailDelivery)
class EmailDeliveryAdmin(admin.ModelAdmin):
    list_display = ['id', 'recipient', 'kind', 'channel', 'status', 'attempts', 'created_at', 'sent_at']
    list_filter = ['kind', 'channel', 'status']
    readonly_fields = ['recipient', 'event_key', 'kind', 'subject', 'target_id', 'status', 'attempts', 'error_code', 'next_attempt_at', 'created_at', 'sent_at']
    fields = readonly_fields
    def has_add_permission(self, request):
        return False

admin.site.register(Notification)

from .models import TherapistApplication, TherapyLedger, BillingPlan, BusinessSubscription, PaymentEvent
from django.db import transaction

@admin.register(TherapistApplication)
class TherapistApplicationAdmin(admin.ModelAdmin):
    list_display = ['user','status','license_number','location','updated_at']
    readonly_fields = ['user','status']
    actions = ['approve','reject']
    @admin.action(description='Approve selected therapist applications')
    def approve(self, request, queryset):
        from .communications import queue_email
        for item in queryset:
            with transaction.atomic():
                app = TherapistApplication.objects.select_for_update().get(pk=item.pk)
                if app.status != 'pending':
                    continue
                app.status='approved'; app.save()
                app.user.is_therapist=True; app.user.save(update_fields=['is_therapist'])
                profile, _ = Therapist.objects.get_or_create(user=app.user)
                profile.is_active=True; profile.degrees=app.credentials; profile.save()
                queue_email(app.user,'application','Your Hearteli therapist application was approved',
                    'Your application was approved. Sign in and complete your practice profile.',key=f'application-approved:{app.pk}',path='/practice/')
    @admin.action(description='Reject selected applications (add a review note first)')
    def reject(self, request, queryset):
        for app in queryset.filter(status='pending').exclude(review_note=''):
            app.status='rejected'; app.save()
            from .communications import queue_email
            queue_email(app.user,'application','Your Hearteli therapist application update','Your application was reviewed. Sign in to read the review note and next steps.',key=f'application-review:{app.pk}:{app.updated_at.isoformat()}',path='/practice/apply/')

@admin.register(TherapyLedger)
class TherapyLedgerAdmin(admin.ModelAdmin):
    list_display=['therapist','appointment','kind','amount','created_at']
    def has_add_permission(self, request): return False
    def has_change_permission(self, request, obj=None): return False
    def has_delete_permission(self, request, obj=None): return False

admin.site.register(BillingPlan)
@admin.register(BusinessSubscription)
class BusinessSubscriptionAdmin(admin.ModelAdmin):
    list_display=['workspace','plan','status','period_end']
    readonly_fields=['workspace','plan','customer_id','stripe_subscription_id','status','period_end','cancel_at_period_end']
    def has_add_permission(self, request): return False
    def has_delete_permission(self, request, obj=None): return False

# Register the manual monetisation workflow in place of the earlier billing UI.
from . import commercial_admin
