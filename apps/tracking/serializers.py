from rest_framework import serializers
from rest_framework.serializers import SerializerMethodField
from django.urls import reverse

from apps.tracking.models import (
    Mood, Relative, Suggestion, MoodCheckIn, ChatConversation, 
    ChatMessage, MoodNotification, NotificationTemplate, GratitudeEntry
)


class RelativeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Relative
        fields = "__all__"

    

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
        source='moods'
    )
    
    class Meta:
        model = MoodCheckIn
        fields = ['id', 'user', 'moods', 'mood_ids', 'notes', 'timestamp', 'date']
        read_only_fields = ['user', 'timestamp']


# ============ CHAT SERIALIZERS ============
class ChatMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatMessage
        fields = ['id', 'sender', 'message_text', 'timestamp']
        read_only_fields = ['timestamp']


class ChatConversationSerializer(serializers.ModelSerializer):
    messages = ChatMessageSerializer(many=True, read_only=True)
    
    class Meta:
        model = ChatConversation
        fields = ['id', 'user', 'mood_check_in', 'started_at', 'ended_at', 'is_active', 'summary', 'messages']
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
    class Meta:
        model = GratitudeEntry
        fields = ['id', 'user', 'gratitude_1', 'gratitude_2', 'gratitude_3', 'date', 'created_at']
        read_only_fields = ['user', 'created_at']