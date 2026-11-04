from decimal import Decimal
from django.db import transaction
from django.utils import timezone
from rest_framework import serializers
from rest_framework.exceptions import ValidationError,PermissionDenied
from .models import Therapist,SessionOffering,MarketplacePolicy,Appointment


def eligible_profiles():
    p=MarketplacePolicy.current();now=timezone.now()
    return Therapist.objects.filter(user__is_active=True,user__is_therapist=True,
        verification_status='verified',verification_expires_at__gt=now,is_available=True,
        availability_status='active',last_activity_confirmation__gt=now-timezone.timedelta(days=p.inactive_days))


def public_reviews(therapist_id):
    from .models import Feedback
    qs=Feedback.objects.filter(therapist_id=therapist_id,therapist__therapist_profile__public_reviews_permitted=True,therapist__therapist_profile__review_policy_reference__gt='',moderation_status='approved',public_visibility=True)
    return qs if MarketplacePolicy.current().public_reviews_enabled else qs.none()


def quote_booking(user,therapist,offering_id,referral_code=None):
    if not therapist.therapist_profile.searchable: raise ValidationError('This practitioner is not eligible for new bookings.')
    try: offering_id=int(offering_id)
    except (ValueError,TypeError):raise ValidationError('Choose an approved session option.')
    offering=SessionOffering.objects.filter(pk=offering_id,therapist=therapist.therapist_profile,approved=True,active=True).first()
    if not offering: raise ValidationError('Select an administrator-approved session duration and fee.')
    prior=Appointment.objects.filter(user=user,therapist=therapist).order_by('created_at').first()
    referred=prior.acquisition_source=='referral' if prior else referral_code and str(referral_code)==str(therapist.therapist_profile.referral_code)
    source='referral' if referred else 'platform';policy=MarketplacePolicy.current()
    rate=policy.referral_commission if referred else policy.platform_commission
    commission=(offering.fee*rate/Decimal(100)).quantize(Decimal('.01'))
    return dict(booking_credential_verified=True,fee=offering.fee,duration_minutes=offering.duration_minutes,commission_percent=rate,
        acquisition_source=source,commission=commission,therapist_earnings=offering.fee-commission)

class OfferingSerializer(serializers.ModelSerializer):
    class Meta:
        model=SessionOffering
        fields=['id','duration_minutes','fee','approved','active']
        read_only_fields=['id','approved']

from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

class SearchFilters(serializers.Serializer):
    q=serializers.CharField(required=False,allow_blank=True,max_length=100)
    specialty=serializers.CharField(required=False,allow_blank=True,max_length=100)
    practitioner_type=serializers.CharField(required=False,allow_blank=True,max_length=100)
    max_fee=serializers.DecimalField(required=False,max_digits=10,decimal_places=2,min_value=0)
    duration=serializers.IntegerField(required=False,min_value=10,max_value=240)
    modality=serializers.ChoiceField(required=False,choices=['Online','In person'])

class MarketplaceSearchView(APIView):
    permission_classes=[IsAuthenticated]
    def get(self,request):
        filters=SearchFilters(data=request.query_params);filters.is_valid(raise_exception=True)
        profiles=filtered_profiles(filters.validated_data)
        from .serializers import TherapistPublicSerializer
        from .monetisation import active_campaigns,campaign_eligible,ticket_payload,adult
        sponsored=[];seen=set()
        for campaign in (active_campaigns('search').filter(therapist__in=profiles) if adult(request.user) else []):
            if len(sponsored)>=3:break
            if campaign.therapist_id in seen or not campaign_eligible(campaign):continue
            payload=ticket_payload(campaign,request.user)
            if payload:
                data=TherapistPublicSerializer(campaign.therapist.user,context={'request':request}).data
                data['sponsor']=payload;sponsored.append(data);seen.add(campaign.therapist_id)
        organic=[TherapistPublicSerializer(p.user,context={'request':request}).data for p in profiles.exclude(pk__in=seen).order_by('user__name')[:50]]
        return Response({'sponsored':sponsored,'organic':organic})


def filtered_profiles(filters):
    qs=eligible_profiles().select_related('user')
    if filters.get('q'):qs=qs.filter(user__name__icontains=filters['q'])
    if filters.get('specialty'):qs=qs.filter(specialties__icontains=filters['specialty'])
    if filters.get('practitioner_type'):qs=qs.filter(practitioner_type__icontains=filters['practitioner_type'])
    if filters.get('modality'):qs=qs.filter(user__therapy_application__modalities__icontains=filters['modality'])
    offering_filters={'session_offerings__approved':True,'session_offerings__active':True}
    if 'max_fee' in filters:offering_filters['session_offerings__fee__lte']=filters['max_fee']
    if 'duration' in filters:offering_filters['session_offerings__duration_minutes']=filters['duration']
    return qs.filter(**offering_filters).distinct()


class OfferingView(APIView):
    permission_classes=[IsAuthenticated]
    def get(self,request):
        if not request.user.is_therapist:raise PermissionDenied('Practitioner access required.')
        return Response(OfferingSerializer(request.user.therapist_profile.session_offerings.all(),many=True).data)
    def post(self,request):
        from rest_framework.exceptions import PermissionDenied
        if not request.user.is_therapist:raise PermissionDenied('Practitioner access required.')
        serializer=OfferingSerializer(data=request.data);serializer.is_valid(raise_exception=True)
        serializer.save(therapist=request.user.therapist_profile,approved=False)
        return Response(serializer.data,status=201)

class ConfirmActivityView(APIView):
    permission_classes=[IsAuthenticated]
    def post(self,request):
        from rest_framework.exceptions import PermissionDenied
        if not request.user.is_therapist:raise PermissionDenied('Practitioner access required.')
        state=request.data.get('availability_status','active')
        if state not in ('active','not_accepting','temporary'):raise ValidationError('Choose a valid availability status.')
        p=request.user.therapist_profile;p.last_activity_confirmation=timezone.now();p.last_availability_update=timezone.now();p.availability_status=state;p.is_available=state=='active';p.save()
        return Response({'availability_status':state,'search_visible':p.searchable,'verified':p.verified})
