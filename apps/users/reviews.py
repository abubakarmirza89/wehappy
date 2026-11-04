from django.db import transaction
from rest_framework.exceptions import ValidationError,PermissionDenied
from .models import Appointment,Feedback

@transaction.atomic
def submit_review(user,therapist_id,appointment_id,rating,comment):
    from django.shortcuts import get_object_or_404
    a=get_object_or_404(Appointment.objects.select_for_update(),pk=appointment_id)
    if a.user_id!=user.pk or a.therapist_id!=int(therapist_id):
        raise PermissionDenied('Only the client who attended this therapist appointment can review it.')
    if a.status!='COMPLETED' or a.payment_status!='paid' or not a.booking_credential_verified:
        raise ValidationError('Complete the session before reviewing it.')
    if Feedback.objects.filter(appointment=a).exists():
        raise ValidationError('You have already reviewed this appointment.')
    return Feedback.objects.create(user=user,therapist=a.therapist,appointment=a,rating=rating,comment=comment)

from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

class TherapistReviewsView(APIView):
    permission_classes=[IsAuthenticated]
    def get(self,request,pk):
        return Response(list(__import__('apps.users.marketplace',fromlist=['public_reviews']).public_reviews(pk).order_by('-pk').values('id','rating','comment')[:100]))

class ReportReviewView(APIView):
    permission_classes=[IsAuthenticated]
    def post(self,request,pk):
        from .marketplace import public_reviews
        from .models import ReviewReport
        from rest_framework import serializers
        from django.shortcuts import get_object_or_404
        review=get_object_or_404(Feedback,pk=pk)
        if not public_reviews(review.therapist_id).filter(pk=pk).exists():raise PermissionDenied('Review is unavailable.')
        reason=serializers.CharField(max_length=500).run_validation(request.data.get('reason'))
        ReviewReport.objects.get_or_create(review=review,reporter=request.user,defaults={'reason':reason})
        return Response({'reported':True})
