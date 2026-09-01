from django.contrib import admin

from apps.tracking.models import (
    Message, Mood, Relative, Suggestion, MoodCheckIn, ChatConversation,
    ChatMessage, MoodNotification, NotificationTemplate, GratitudeEntry
)


@admin.register(Relative)
class RelativeAdmin(admin.ModelAdmin):
    list_display = ("name", "email", "phone_number", "is_app_user", "relation")
    list_filter = ("is_app_user", "relation")
    search_fields = ("name", "email", "phone_number")


class SuggestionAdmin(admin.StackedInline):
    model = Suggestion
    extra = 1


@admin.register(Mood)
class MoodAdmin(admin.ModelAdmin):
    list_display = ("name", "score", "calculate_brain_health")
    inlines = [SuggestionAdmin]


@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    list_display = ("message_text", "mood", "is_urgent")
    list_filter = ("is_urgent",)


# ============ NEW ADMIN REGISTRATIONS ============

@admin.register(MoodCheckIn)
class MoodCheckInAdmin(admin.ModelAdmin):
    list_display = ("user", "date", "timestamp")
    list_filter = ("date", "user")
    search_fields = ("user__name", "user__email")
    readonly_fields = ("timestamp",)
    filter_horizontal = ("moods",)


class ChatMessageInline(admin.TabularInline):
    model = ChatMessage
    extra = 0
    readonly_fields = ("timestamp",)


@admin.register(ChatConversation)
class ChatConversationAdmin(admin.ModelAdmin):
    list_display = ("user", "started_at", "ended_at", "is_active")
    list_filter = ("is_active", "started_at")
    search_fields = ("user__name", "user__email")
    readonly_fields = ("started_at",)
    inlines = [ChatMessageInline]


@admin.register(ChatMessage)
class ChatMessageAdmin(admin.ModelAdmin):
    list_display = ("conversation", "sender", "message_text_preview", "timestamp")
    list_filter = ("sender", "timestamp")
    search_fields = ("conversation__user__name", "message_text")
    readonly_fields = ("timestamp",)
    
    def message_text_preview(self, obj):
        return obj.message_text[:50] + "..." if len(obj.message_text) > 50 else obj.message_text
    message_text_preview.short_description = "Message"


@admin.register(MoodNotification)
class MoodNotificationAdmin(admin.ModelAdmin):
    list_display = ("user", "relative", "notification_type", "is_sent", "sent_via", "created_at")
    list_filter = ("notification_type", "is_sent", "sent_via", "created_at")
    search_fields = ("user__name", "relative__name")
    readonly_fields = ("created_at", "sent_at")


@admin.register(NotificationTemplate)
class NotificationTemplateAdmin(admin.ModelAdmin):
    list_display = ("mood", "notification_type", "template_text_preview")
    list_filter = ("notification_type",)
    search_fields = ("mood__name",)
    
    def template_text_preview(self, obj):
        return obj.template_text[:50] + "..." if len(obj.template_text) > 50 else obj.template_text
    template_text_preview.short_description = "Template"


@admin.register(GratitudeEntry)
class GratitudeEntryAdmin(admin.ModelAdmin):
    list_display = ("user", "date", "created_at")
    list_filter = ("date",)
    search_fields = ("user__name", "user__email")
    readonly_fields = ("created_at",)