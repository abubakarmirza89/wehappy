from django.contrib.auth import get_user_model
from rest_framework import serializers

from apps.users.models import Appointment, Feedback, Notification, Therapist, UserHistory, WithdrawalRequest

User = get_user_model()


class FeedbackSerializer(serializers.ModelSerializer):
    appointment_id = serializers.IntegerField(write_only=True,min_value=1)
    comment = serializers.CharField(max_length=2000,allow_blank=True,required=False,default="")
    user = serializers.StringRelatedField(read_only=True)
    therapist = serializers.StringRelatedField(read_only=True)
    appointment = serializers.PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = Feedback
        fields = ["id","user","therapist","appointment","appointment_id","rating","comment"]


class TherapistProfileSerializer(serializers.ModelSerializer):
    def validate_hourly_rate(self,value):
        raise serializers.ValidationError('Submit session durations and fees for administrator approval.')

    def update(self,instance,validated_data):
        if 'is_available' in validated_data:
            from django.utils import timezone
            instance.last_availability_update=timezone.now()
        return super().update(instance,validated_data)

    class Meta:
        model = Therapist
        fields = (
            "degrees",
            "certifications",
            "card_id",
            "hourly_rate",
            "is_available",
        )
        extra_kwargs = {
            "degrees": {"required": False},
            "certifications": {"required": False},
            "card_id": {"required": False},
            "hourly_rate": {"required": False},
            "is_available": {"required": False},
        }


class UserHistorySerializer(serializers.ModelSerializer):
    appointment = serializers.PrimaryKeyRelatedField(read_only=True)
    user = serializers.StringRelatedField(read_only=True)
    therapist = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = UserHistory
        fields = "__all__"


class UserSerializer(serializers.ModelSerializer):
    # url = serializers.HyperlinkedIdentityField(
    #     view_name="users:users-detail", lookup_field="id"
    # )
    create_feedback = serializers.HyperlinkedIdentityField(
        view_name="users:api-feedback", lookup_field="pk", read_only=True
    )
    create_appointment = serializers.HyperlinkedIdentityField(
        view_name="users:api-create-appointment", lookup_field="pk", read_only=True
    )
    therapist_profile = TherapistProfileSerializer(required=False)
    feedback_therapist = FeedbackSerializer(many=True, read_only=True)
    feedbacks = FeedbackSerializer(many=True, read_only=True)
    therapist_history = UserHistorySerializer(many=True, read_only=True)
    user_history = UserHistorySerializer(many=True, read_only=True)

    class Meta:
        model = User
        fields = (
            # "url",
            "id",
            "name",
            "email",
            "profile_picture",
            "phone_number",
            "date_of_birth",
            "create_feedback",
            "create_appointment",
            "user_history",
            "therapist_history",
            "therapist_profile",
            "feedback_therapist",
            "feedbacks",
        )

    def to_representation(self, instance):
        data = super().to_representation(instance)

        if not instance.is_therapist:
            fields_to_exclude = [
                "create_feedback",
                "create_appointment",
                "feedback_therapist",
                "therapist_profile",
                "therapist_history",
            ]
        else:
            fields_to_exclude = ["user_history", "feedbacks"]

        # Create a new dictionary to store filtered data
        filtered_data = {key: value for key, value in data.items() if key not in fields_to_exclude}
        return filtered_data

    def update(self, instance, validated_data):
        therapist_profile_data = validated_data.pop("therapist_profile", None)
        instance = super().update(instance, validated_data)

        if therapist_profile_data and instance.is_therapist:
            therapist_profile_serializer = self.fields["therapist_profile"]
            therapist_profile_instance = instance.therapist_profile

            therapist_profile_serializer.update(
                therapist_profile_instance, therapist_profile_data)

        return instance


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ("id", "recipient", "verb", "created_at", "read")


class UserSignupSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["name", "email", "password",
                  "phone_number"]
        extra_kwargs = {"password": {"write_only": True}}

    def validate_email(self, value):
        value = value.strip().lower()
        if User.objects.filter(email__iexact=value).exists():
            raise serializers.ValidationError('An account with this email already exists.')
        return value

    def validate_password(self, value):
        from django.contrib.auth.password_validation import validate_password
        from django.core.exceptions import ValidationError
        try:
            validate_password(value)
        except ValidationError as exc:
            raise serializers.ValidationError(exc.messages)
        return value

    def create(self, validated_data):
        email = validated_data.get("email")
        if not User.objects.filter(email=email).exists():
            user = User.objects.create_user(**validated_data)
            return user
        else:
            raise serializers.ValidationError("Email already exists.")


class UserAppointmentSerializer(serializers.ModelSerializer):
    therapist_id = serializers.IntegerField(read_only=True)
    review_submitted = serializers.SerializerMethodField()
    def get_review_submitted(self,obj): return Feedback.objects.filter(appointment=obj).exists()
    display_time = serializers.SerializerMethodField()

    def get_display_time(self, obj):
        from .appointment_time import local_appointment
        request = self.context.get('request')
        return local_appointment(obj, request.user if request else None)

    url = serializers.HyperlinkedIdentityField(
        view_name="users:appointment-detail", lookup_field="pk")
    therapist = serializers.ReadOnlyField(source="therapist.name")

    class Meta:
        model = Appointment
        fields = ["id", "display_time", "duration_minutes", "therapist_id", "review_submitted", "url", "therapist", "date", "time", "location", "reason", "fee", "commission", "therapist_earnings", "payment_status", "status", "created_at"]
        read_only_fields = ["duration_minutes","fee", "commission", "therapist_earnings", "payment_status", "status", "created_at"]


class TherapistAppointmentSerializer(serializers.ModelSerializer):
    display_time = serializers.SerializerMethodField()

    def get_display_time(self, obj):
        from .appointment_time import local_appointment
        request = self.context.get('request')
        return local_appointment(obj, request.user if request else None)

    url = serializers.HyperlinkedIdentityField(
        view_name="users:appointment-detail", lookup_field="pk")
    user = serializers.ReadOnlyField(source="user.name")
    date = serializers.ReadOnlyField()
    time = serializers.ReadOnlyField()
    location = serializers.ReadOnlyField()
    reason = serializers.ReadOnlyField()

    class Meta:
        model = Appointment
        fields = ["id", "display_time", "url", "user", "date", "time", "location", "reason", "fee", "commission", "therapist_earnings", "payment_status", "status", "created_at"]
        read_only_fields = ["user", "date", "time", "location", "reason", "fee", "commission", "therapist_earnings", "payment_status", "created_at"]


class WithdrawalRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = WithdrawalRequest
        fields = ["id", "amount", "payout_account", "status", "admin_note", "created_at", "processed_at"]
        read_only_fields = ["status", "admin_note", "created_at", "processed_at"]


class TherapistPublicProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Therapist
        fields = ['degrees', 'certifications', 'is_available']


class TherapistPublicSerializer(serializers.ModelSerializer):
    verified=serializers.SerializerMethodField()
    offerings=serializers.SerializerMethodField()
    practitioner_type=serializers.CharField(source='therapist_profile.practitioner_type',read_only=True)
    specialties=serializers.CharField(source='therapist_profile.specialties',read_only=True)
    def get_verified(self,obj):return obj.therapist_profile.verified
    def get_offerings(self,obj):
        from .marketplace import OfferingSerializer
        return OfferingSerializer(obj.therapist_profile.session_offerings.filter(approved=True,active=True),many=True).data

    average_rating = serializers.SerializerMethodField()
    review_count = serializers.SerializerMethodField()
    def get_average_rating(self,obj):
        from django.db.models import Avg
        from .marketplace import public_reviews
        value=public_reviews(obj.pk).aggregate(value=Avg("rating"))["value"]
        return round(value,2) if value is not None else None
    def get_review_count(self,obj):
        from .marketplace import public_reviews
        return public_reviews(obj.pk).count()
    therapist_profile = TherapistPublicProfileSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'name', 'profile_picture', 'therapist_profile','average_rating','review_count','verified','offerings','practitioner_type','specialties']
