from django.db import transaction
from rest_framework.exceptions import ValidationError,PermissionDenied
from .models import Appointment,Feedback

@transaction.atomic
def submit_review(user,therapist_id,appointment_id,rating,comment):
    from django.shortcuts import get_object_or_404
    a=get_object_or_404(Appointment.objects.select_for_update(),pk=appointment_id)
    if a.user_id!=user.pk or a.therapist_id!=int(therapist_id):
        raise PermissionDenied('Only the client who attended this therapist appointment can review it.')
    if a.status!='COMPLETED':
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
        return Response(list(Feedback.objects.filter(therapist_id=pk).order_by('-pk').values('id','rating','comment')[:100]))
