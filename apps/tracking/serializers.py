from rest_framework import serializers

from apps.tracking.models import Mood, Relative, Suggestion


class RelativeSerializer(serializers.ModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name="truck:relative-detail", lookup_field="pk")

    class Meta:
        model = Relative
        fields = "__all__"
        read_only_fields = ["id", "url"]

    

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