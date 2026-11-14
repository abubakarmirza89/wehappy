from django.contrib.auth.views import LoginView
from django.contrib.auth.forms import AuthenticationForm
from django.urls import reverse
from django import forms
from django.contrib.auth.decorators import login_required
from django.db import transaction
from django.db.models import Q
from django.shortcuts import render,redirect,get_object_or_404
from django.contrib import messages
from django.views.decorators.http import require_POST
from django.utils import timezone
from .models import TherapistApplication,Therapist,Appointment,AppointmentMessage,WithdrawalRequest,User
from .therapy_services import balance

class ApplicationForm(forms.ModelForm):
    class Meta:
        model=TherapistApplication
        fields=['bio','credentials','license_number','location','modalities']

class ProfileForm(forms.ModelForm):
    class Meta:
        model=Therapist
        fields=['degrees','certifications','availability_status']

@login_required(login_url='/practice/login/')
def apply(request):
    app=TherapistApplication.objects.filter(user=request.user).first()
    form=ApplicationForm(request.POST or None,instance=app)
    if request.method=='POST' and (not app or app.status=='rejected') and form.is_valid():
        with transaction.atomic():
            User.objects.select_for_update().get(pk=request.user.pk)
            current=TherapistApplication.objects.filter(user=request.user).first()
            if current and current.status in ('pending','approved'): return redirect('practice-apply')
            obj=form.save(commit=False);obj.user=request.user;obj.status='pending';obj.review_note='';obj.save()
        return redirect('practice-apply')
    return render(request,'practice/apply.html',{'form':form,'application':app})

@login_required(login_url='/practice/login/')
def dashboard(request):
    if not request.user.is_therapist: return redirect('practice-apply')
    return render(request,'practice/dashboard.html',{'wallet':balance(request.user),
        'appointments':Appointment.objects.filter(therapist=request.user).select_related('user'),
        'withdrawals':WithdrawalRequest.objects.filter(therapist=request.user),
        'ledger':request.user.therapy_ledger.order_by('-created_at')[:50]})

@login_required(login_url='/practice/login/')
def profile(request):
    if not request.user.is_therapist: return redirect('practice-apply')
    from .marketplace import OfferingSerializer
    from .models import SessionOffering
    p=request.user.therapist_profile
    action=request.POST.get('action','profile')
    form=ProfileForm(request.POST if request.method=='POST' and action=='profile' else None,instance=p)
    if request.method=='POST':
        if action=='confirm':
            p.last_activity_confirmation=timezone.now();p.last_availability_update=timezone.now();p.availability_status='active';p.is_available=True;p.save()
            messages.success(request,'Availability confirmed. Search visibility also requires valid credentials and no account restrictions.')
            return redirect('practice-profile')
        if action=='offering':
            offering=OfferingSerializer(data=request.POST)
            if offering.is_valid():offering.save(therapist=p,approved=False);messages.success(request,'Session duration and fee submitted for administrator approval.')
            else:messages.error(request,str(offering.errors))
            return redirect('practice-profile')
        if action=='profile' and form.is_valid():
            p=form.save(commit=False);p.last_availability_update=timezone.now();p.is_available=p.availability_status=='active';p.save()
            messages.success(request,'Practice profile saved.');return redirect('practice-profile')
    return render(request,'practice/profile.html',{'form':form,'provider':p,'offerings':p.session_offerings.all()})


@login_required(login_url='/practice/login/')
@require_POST
def withdraw(request):
    if not request.user.is_therapist: return redirect('practice-apply')
    from .serializers import WithdrawalRequestSerializer
    serializer=WithdrawalRequestSerializer(data=request.POST)
    if serializer.is_valid():
        with transaction.atomic():
            User.objects.select_for_update().get(pk=request.user.pk)
            amount=serializer.validated_data['amount']
            if 0<amount<=balance(request.user)['available_balance']:
                serializer.save(therapist=request.user);messages.success(request,'Withdrawal requested for review.')
            else: messages.error(request,'Amount exceeds your available balance.')
    else: messages.error(request,'Enter a valid amount and payout account.')
    return redirect('practice-dashboard')

@login_required(login_url='/practice/login/')
def appointment(request,pk):
    a=get_object_or_404(Appointment.objects.filter(Q(user=request.user)|Q(therapist=request.user)),pk=pk)
    if request.method=='POST':
        if request.POST.get('action')=='checkout' and request.user.pk==a.user_id:
            from .billing import appointment_checkout
            from rest_framework.exceptions import ValidationError
            try:
                with transaction.atomic():
                    a=Appointment.objects.select_for_update().get(pk=pk)
                    return redirect(appointment_checkout(a))
            except ValidationError as exc: messages.error(request,str(exc.detail))
        elif request.POST.get('action')=='status' and request.user.pk==a.therapist_id:
            transitions={'BOOKED':{'IN_PROGRESS','CANCELED'},'IN_PROGRESS':{'COMPLETED'}}
            status=request.POST.get('status')
            if status in transitions.get(a.status,set()): a.status=status;a.save(update_fields=['status'])
        elif request.POST.get('action')=='review':
            from .serializers import FeedbackSerializer
            from .reviews import submit_review
            from rest_framework.exceptions import APIException
            review=FeedbackSerializer(data={'appointment_id':pk,'rating':request.POST.get('rating'),'comment':request.POST.get('comment','')})
            if review.is_valid():
                try:
                    submit_review(request.user,a.therapist_id,pk,review.validated_data['rating'],review.validated_data['comment'])
                    messages.success(request,'Thank you. Your review was saved.')
                except APIException as exc: messages.error(request,str(exc.detail))
            else: messages.error(request,'Choose a rating from 1 to 5 and keep your review under 2000 characters.')
        elif request.POST.get('action')=='message' and a.status!='CANCELED':
            text=request.POST.get('body','').strip()
            if 1<=len(text)<=2000: AppointmentMessage.objects.create(appointment=a,author=request.user,body=text)
        return redirect('practice-appointment',pk=pk)
    from .appointment_time import appointment_time_text
    return render(request,'practice/appointment.html', {
        'appointment': a,
        'appointment_time': appointment_time_text(a, request.user),
        'chat_messages': a.messages.select_related('author'),
        'has_review': hasattr(a, 'review'),
    })


@login_required(login_url='/practice/login/')
def appointment_calendar(request, pk):
    from datetime import timedelta
    from django.http import HttpResponse
    from .appointment_time import appointment_start

    appointment = get_object_or_404(
        Appointment.objects.filter(Q(user=request.user) | Q(therapist=request.user)),
        pk=pk,
    )
    start = appointment_start(appointment)
    end = start + timedelta(minutes=appointment.duration_minutes)
    stamp = lambda value: value.strftime('%Y%m%dT%H%M%SZ')
    body = '\r\n'.join([
        'BEGIN:VCALENDAR', 'VERSION:2.0', 'PRODID:-//Hearteli//Appointments//EN',
        'BEGIN:VEVENT', f'UID:appointment-{appointment.pk}@hearteli.com',
        f'DTSTAMP:{stamp(timezone.now())}', f'DTSTART:{stamp(start)}',
        f'DTEND:{stamp(end)}', 'SUMMARY:Hearteli appointment',
        'STATUS:CANCELLED' if appointment.status == 'CANCELED' else 'STATUS:CONFIRMED',
        'END:VEVENT', 'END:VCALENDAR', '',
    ])
    response = HttpResponse(body, content_type='text/calendar; charset=utf-8')
    response['Content-Disposition'] = 'attachment; filename="hearteli-appointment.ics"'
    response['Cache-Control'] = 'private, no-store'
    return response


class BookingForm(forms.Form):
    date=forms.DateField(widget=forms.DateInput(attrs={'type':'date'}))
    time=forms.TimeField(widget=forms.TimeInput(attrs={'type':'time'}))
    location=forms.ChoiceField(choices=[('Online','Online'),('In person','In person')])
    reason=forms.CharField(max_length=200,required=False)
    referral_code=forms.CharField(max_length=64,required=False,label='Therapist referral code (optional)')

@login_required(login_url='/practice/login/')
def directory(request):
    query=request.GET.get('q','').strip()
    providers=Therapist.objects.filter(user__is_active=True,user__is_therapist=True,is_available=True).select_related('user')
    if query: providers=providers.filter(user__name__icontains=query)
    return render(request,'practice/directory.html',{'providers':providers,'query':query})

@login_required(login_url='/practice/login/')
def provider(request,pk):
    from decimal import Decimal
    from .views import validate_appointment_slot
    from rest_framework.exceptions import ValidationError
    therapist=get_object_or_404(Therapist,user_id=pk,user__is_active=True,user__is_therapist=True)
    from .marketplace import eligible_profiles,quote_booking,public_reviews
    if not eligible_profiles().filter(pk=therapist.pk).exists():
        from django.http import Http404
        raise Http404()
    if request.method=='POST' and request.POST.get('action')=='report_review':
        from .models import ReviewReport
        review=get_object_or_404(public_reviews(therapist.user_id),pk=request.POST.get('review_id'))
        ReviewReport.objects.get_or_create(review=review,reporter=request.user,defaults={'reason':'Client requested moderation review'})
        messages.success(request,'Report sent for moderation.')
        return redirect('therapy-provider',pk=pk)
    form=BookingForm(request.POST or None)
    form.fields['offering_id']=forms.ModelChoiceField(queryset=therapist.session_offerings.filter(approved=True,active=True),label='Approved session duration and fee')
    if request.method=='POST' and form.is_valid():
        try:
            with transaction.atomic():
                User.objects.select_for_update().get(pk=pk)
                therapist.refresh_from_db()
                if request.user.pk==pk: raise ValidationError('Choose another provider.')
                if not therapist.searchable: raise ValidationError('This provider is not accepting bookings.')
                data=form.cleaned_data
                offering=data.pop('offering_id')
                referral=data.pop('referral_code',None) or request.GET.get('referral_code')
                quote=quote_booking(request.user,therapist.user,offering.pk,referral)
                validate_appointment_slot(therapist.user,data['date'],data['time'],duration=quote['duration_minutes'])
                a=Appointment.objects.create(user=request.user,therapist=therapist.user,**quote,**data)
                from .monetisation import attribute_booking
                attribute_booking(a,request.GET.get('sponsor_event_id'))
            return redirect('practice-appointment',pk=a.pk)
        except ValidationError as exc: form.add_error(None,str(exc.detail))
    from django.db.models import Avg
    reviews=public_reviews(therapist.user_id)
    return render(request,'practice/provider.html',{'provider':therapist,'form':form,'reviews':reviews,'average_rating':reviews.aggregate(value=Avg('rating'))['value'],'review_count':reviews.count()})


class VerifiedAuthenticationForm(AuthenticationForm):
    def confirm_login_allowed(self, user):
        super().confirm_login_allowed(user)
        from .email_verification import needs_verification
        if needs_verification(user):
            raise forms.ValidationError('Verify your email before signing in.')


class PracticeAwareLoginView(LoginView):
    authentication_form = VerifiedAuthenticationForm
    template_name='practice/login.html'
    def get_success_url(self):
        return self.get_redirect_url() or reverse('practice-dashboard')


class WorkLoginView(LoginView):
    authentication_form = VerifiedAuthenticationForm
    template_name='work/login.html'
    def get_success_url(self):
        return self.get_redirect_url() or reverse('hearteli-work-index')


def signup(request):
    from apps.tracking.work_web import OwnerRegistrationForm
    from .email_verification import queue_verification
    if request.user.is_authenticated: return redirect('practice-apply')
    form=OwnerRegistrationForm(request.POST or None)
    if request.method=='POST' and form.is_valid():
        user=User.objects.create_user(name=form.cleaned_data['name'],email=form.cleaned_data['email'],phone_number=form.cleaned_data['phone_number'],password=form.cleaned_data['password'],email_verification_required=True)
        queue_verification(user)
        return redirect('hearteli-verification-pending')
    return render(request,'practice/signup.html',{'form':form})
