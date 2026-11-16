from django.contrib import admin
from django import forms
from django.contrib.auth import admin as auth_admin
from django.contrib.auth import get_user_model
from django.contrib.admin.helpers import ActionForm
from django.contrib import messages
from django.db import transaction
from django.utils.translation import gettext_lazy as _
import uuid

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


class ManualPushActionForm(ActionForm):
    push_title = forms.CharField(
        label="Push title",
        max_length=200,
        required=False,
        help_text="Required when sending a push notification.",
    )
    push_message = forms.CharField(
        label="Push message",
        max_length=255,
        required=False,
        widget=forms.Textarea(attrs={"rows": 2}),
        help_text="Required when sending. Keep it short for lock-screen display.",
    )


@admin.register(User)
class UserAdmin(auth_admin.UserAdmin):
    form = UserAdminChangeForm
    add_form = UserAdminCreationForm
    action_form = ManualPushActionForm
    actions = ["delete_selected", "send_manual_push"]
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

    @admin.action(description="Queue Firebase push for selected users")
    def send_manual_push(self, request, queryset):
        try:
            title = self.action_form.base_fields["push_title"].clean(
                request.POST.get("push_title", "")
            ).strip()
            body = self.action_form.base_fields["push_message"].clean(
                request.POST.get("push_message", "")
            ).strip()
        except forms.ValidationError as error:
            messages.error(request, " ".join(error.messages))
            return

        if not title or not body:
            messages.error(request, "Both the push title and message are required.")
            return

        selected_count = queryset.count()
        recipients = queryset.filter(
            is_active=True,
            device_tokens__is_active=True,
        ).distinct()
        eligible_count = recipients.count()
        if not eligible_count:
            messages.warning(
                request,
                "No selected active users have a registered active device token. "
                "Nothing was queued.",
            )
            return

        from .communications import queue_push_notification

        event_id = uuid.uuid4()
        queued_count = 0
        with transaction.atomic():
            for recipient in recipients:
                delivery = queue_push_notification(
                    recipient,
                    "admin_manual",
                    title,
                    body,
                    key=f"admin-manual:{event_id}:{recipient.pk}",
                    in_app_message=body,
                )
                if delivery is not None:
                    queued_count += 1

        skipped_count = selected_count - queued_count
        messages.success(
            request,
            f"Queued push notification for {queued_count} user(s). "
            "The notification worker will send it through Firebase. "
            f"Skipped {skipped_count} inactive user(s) or user(s) without an active device token.",
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

@admin.register(TherapistApplication)
class TherapistApplicationAdmin(admin.ModelAdmin):
    list_display = ['user','status','license_number','location','updated_at']
    readonly_fields = ['user','status']
    actions = None

    # Retain historical records without allowing this legacy queue to grant roles.
    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


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


from .models import PrivacyPolicy


@admin.register(PrivacyPolicy)
class PrivacyPolicyAdmin(admin.ModelAdmin):
    list_display = ['__str__', 'publication_status', 'saved_at', 'published_at']
    readonly_fields = ['publication_status', 'saved_at', 'published_at', 'preview_draft']
    fields = ['draft', 'publication_status', 'saved_at', 'published_at', 'preview_draft']
    actions = ['publish_reviewed_policy']

    class Media:
        js = ('hearteli/policy-editor.js',)

    def has_add_permission(self, request):
        return super().has_add_permission(request) and not PrivacyPolicy.objects.exists()

    def has_delete_permission(self, request, obj=None):
        return False

    def save_model(self, request, obj, form, change):
        if change:
            obj.save(update_fields=['draft', 'saved_at'])
        else:
            super().save_model(request, obj, form, change)

    def has_publish_permission(self, request):
        return self.has_change_permission(request) and request.user.has_perm('users.publish_privacypolicy')

    @admin.display(description='Public status')
    def publication_status(self, obj):
        return 'Published (draft edits are private)' if obj and obj.published_at else 'Draft only'

    @admin.display(description='Draft preview')
    def preview_draft(self, obj):
        if not obj or not obj.pk:
            return 'Save a draft before previewing.'
        from django.urls import reverse
        from django.utils.html import format_html
        return format_html('<a href="{}">Preview saved draft</a>', reverse('admin:privacy-policy-draft', args=[obj.pk]))

    def get_urls(self):
        from django.urls import path
        return [path('<int:pk>/draft-preview/', self.admin_site.admin_view(self.preview), name='privacy-policy-draft')] + super().get_urls()

    def preview(self, request, pk):
        from django.core.exceptions import PermissionDenied
        from django.shortcuts import get_object_or_404, render
        from .policy_web import render_policy

        obj = get_object_or_404(PrivacyPolicy, pk=pk)
        if not self.has_change_permission(request, obj):
            raise PermissionDenied
        return render(request, 'privacy_policy.html', {'preview_html': render_policy(obj.draft), 'is_preview': True})

    @admin.action(permissions=['publish'], description='Publish selected policy after content approval')
    def publish_reviewed_policy(self, request, queryset):
        from django.core.exceptions import PermissionDenied
        from django.utils.html import strip_tags
        from .policy_web import render_policy

        if not self.has_publish_permission(request):
            raise PermissionDenied
        with transaction.atomic():
            policy = queryset.select_for_update().first()
            html = render_policy(policy.draft) if policy else ''
            if not strip_tags(html).strip():
                self.message_user(request, 'Save a complete reviewed draft before publishing.', level=messages.ERROR)
                return
            policy.published_html = html
            from django.utils import timezone
            policy.published_at = timezone.now()
            policy.save(update_fields=['published_html', 'published_at'])
            self.log_change(request, policy, 'Published reviewed privacy policy')
        self.message_user(request, 'Privacy Policy published.', level=messages.SUCCESS)
