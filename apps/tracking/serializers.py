from rest_framework import serializers
from rest_framework.serializers import SerializerMethodField
from django.urls import reverse
from django.utils import timezone

from apps.tracking.models import (
    Mood, Relative, Suggestion, MoodCheckIn, ChatConversation, 
    ChatMessage, MoodNotification, NotificationTemplate, GratitudeEntry,
    Workspace, WorkspaceMembership, WorkspaceSupportRequest, WorkspaceResource
)


class RelativeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Relative
        fields = [
            'id', 'user', 'name', 'email', 'phone_number', 'is_app_user',
            'relation', 'image', 'created_at'
        ]
        read_only_fields = ['user', 'created_at']

    

class MoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = Mood
        fields = "__all__"

        
class SuggestionSerializer(serializers.ModelSerializer):
    mood_name = serializers.ReadOnlyField(source="mood.name")

    class Meta:
        model = Suggestion
        fields = ["id", "mood_name", "suggestion_text"]


# class MessageSerializer(serializers.ModelSerializer):
#     relative_name = serializers.ReadOnlyField(source='relative.name')
#     mood_name = serializers.ReadOnlyField(source='mood.name')

#     class Meta:
#         model = Message
#         fields = "__all__"


# ============ MOOD CHECK-IN SERIALIZERS ============
class MoodCheckInSerializer(serializers.ModelSerializer):
    moods = MoodSerializer(many=True, read_only=True)
    mood_ids = serializers.PrimaryKeyRelatedField(
        queryset=Mood.objects.all(),
        many=True,
        write_only=True,
        required=False,
        source='moods'
    )
    
    def validate(self, attrs):
        if self.instance is None and not attrs.get('feeling_category') and not attrs.get('moods'):
            raise serializers.ValidationError({'feeling_category': 'Choose a feeling.'})
        if len(attrs.get('notes') or '') > 500:
            raise serializers.ValidationError({'notes': 'Keep your private note under 500 characters.'})
        for field, allowed in [('context_tags', {'work', 'family', 'sleep', 'overwhelmed', 'other'}),
                               ('support_preferences', {'check_in', 'call', 'practical_help', 'space', 'just_know', 'not_sure'})]:
            value = attrs.get(field, [])
            if not isinstance(value, list) or len(value) > 6 or any(item not in allowed for item in value):
                raise serializers.ValidationError({field: 'Choose from the available options.'})
        return attrs

    class Meta:
        model = MoodCheckIn
        fields = ['id', 'user', 'moods', 'mood_ids', 'feeling_category', 'notes', 'context_tags', 'support_preferences', 'timestamp', 'date']
        read_only_fields = ['user', 'timestamp', 'date']


# ============ CHAT SERIALIZERS ============
class ChatMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatMessage
        fields = ['id', 'sender', 'message_text', 'timestamp']
        read_only_fields = ['timestamp']


class ChatConversationSerializer(serializers.ModelSerializer):
    messages = ChatMessageSerializer(many=True, read_only=True)
    therapist_name = serializers.ReadOnlyField(source='therapist.name')
    
    class Meta:
        model = ChatConversation
        fields = ['id', 'user', 'therapist', 'therapist_name', 'mood_check_in', 'started_at', 'ended_at', 'is_active', 'summary', 'messages']
        read_only_fields = ['user', 'started_at']


# ============ NOTIFICATION SERIALIZERS ============
class NotificationTemplateSerializer(serializers.ModelSerializer):
    mood_name = serializers.ReadOnlyField(source='mood.name')
    
    class Meta:
        model = NotificationTemplate
        fields = ['id', 'mood', 'mood_name', 'notification_type', 'template_text']


class MoodNotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = MoodNotification
        fields = ['id', 'user', 'relative', 'mood_check_in', 'message_text', 'notification_type', 'is_sent', 'sent_via', 'sent_at', 'created_at']
        read_only_fields = ['user', 'sent_at', 'created_at']


# ============ GRATITUDE SERIALIZERS ============
class GratitudeEntrySerializer(serializers.ModelSerializer):
    date = serializers.DateField(format='%Y-%m-%d', required=False, default=timezone.localdate)

    class Meta:
        model = GratitudeEntry
        fields = ['id', 'user', 'gratitude_1', 'gratitude_2', 'gratitude_3', 'date', 'created_at']
        read_only_fields = ['user', 'created_at']


class WorkspaceSerializer(serializers.ModelSerializer):
    owner_name = serializers.ReadOnlyField(source='owner.name')

    class Meta:
        model = Workspace
        fields = [
            'id', 'owner', 'owner_name', 'name', 'description', 'workspace_type', 'subscription_plan', 'slug',
            'invite_code', 'qr_code_data', 'join_url', 'is_approval_required',
            'is_active', 'created_at'
        ]
        read_only_fields = ['owner', 'slug', 'invite_code', 'join_url', 'created_at']


class WorkspaceMembershipSerializer(serializers.ModelSerializer):
    user_name = serializers.ReadOnlyField(source='user.name')
    workspace_name = serializers.ReadOnlyField(source='workspace.name')

    class Meta:
        model = WorkspaceMembership
        fields = [
            'id', 'workspace', 'workspace_name', 'user', 'user_name', 'role',
            'designation', 'status', 'invited_by', 'can_share_mood_with_manager',
            'can_receive_support_notifications', 'joined_at', 'created_at'
        ]
        read_only_fields = ['user', 'workspace', 'joined_at', 'created_at']


class WorkspaceSupportRequestSerializer(serializers.ModelSerializer):
    sender_name = serializers.ReadOnlyField(source='sender.name')
    receiver_name = serializers.ReadOnlyField(source='receiver.name')

    class Meta:
        model = WorkspaceSupportRequest
        fields = ['id', 'workspace', 'sender', 'sender_name', 'receiver', 'receiver_name', 'message', 'is_accepted', 'created_at']
        read_only_fields = ['sender', 'receiver', 'created_at']


class WorkspaceResourceSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkspaceResource
        fields = ['id', 'workspace', 'title', 'description', 'url', 'created_at']
        read_only_fields = ['created_at']

    def validate_url(self, value):
        if not value.startswith('https://'):
            raise serializers.ValidationError('Use an HTTPS resource link.')
        return value
