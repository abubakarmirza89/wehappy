from django.contrib.auth.views import LoginView
from django.urls import reverse
from django import forms
from django.contrib.auth.decorators import login_required
from django.db import transaction
from django.db.models import Q
from django.shortcuts import render,redirect,get_object_or_404
from django.contrib import messages
from django.views.decorators.http import require_POST
from .models import TherapistApplication,Therapist,Appointment,AppointmentMessage,WithdrawalRequest,User
from .therapy_services import balance

class ApplicationForm(forms.ModelForm):
    class Meta:
        model=TherapistApplication
        fields=['bio','credentials','license_number','location','modalities']

class ProfileForm(forms.ModelForm):
    class Meta:
        model=Therapist
        fields=['degrees','certifications','hourly_rate','is_available']
    def clean_hourly_rate(self):
        value=self.cleaned_data['hourly_rate']
        if value is None or value<=0: raise forms.ValidationError('Enter a positive hourly rate.')
        return value

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
    form=ProfileForm(request.POST or None,instance=request.user.therapist_profile)
    if request.method=='POST' and form.is_valid(): form.save();messages.success(request,'Practice profile saved.');return redirect('practice-dashboard')
    return render(request,'practice/profile.html',{'form':form})

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
        elif request.POST.get('action')=='message' and a.status!='CANCELED':
            text=request.POST.get('body','').strip()
            if 1<=len(text)<=2000: AppointmentMessage.objects.create(appointment=a,author=request.user,body=text)
        return redirect('practice-appointment',pk=pk)
    return render(request,'practice/appointment.html',{'appointment':a,'chat_messages':a.messages.select_related('author')})

class BookingForm(forms.Form):
    date=forms.DateField(widget=forms.DateInput(attrs={'type':'date'}))
    time=forms.TimeField(widget=forms.TimeInput(attrs={'type':'time'}))
    location=forms.ChoiceField(choices=[('Online','Online'),('In person','In person')])
    reason=forms.CharField(max_length=200,required=False)

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
    form=BookingForm(request.POST or None)
    if request.method=='POST' and form.is_valid():
        try:
            with transaction.atomic():
                User.objects.select_for_update().get(pk=pk)
                therapist.refresh_from_db()
                if request.user.pk==pk: raise ValidationError('Choose another provider.')
                if not therapist.is_available or not therapist.hourly_rate or therapist.hourly_rate<=0: raise ValidationError('This provider is not accepting bookings.')
                data=form.cleaned_data
                validate_appointment_slot(therapist.user,data['date'],data['time'])
                fee=therapist.hourly_rate;commission=(fee*Decimal('.10')).quantize(Decimal('.01'))
                a=Appointment.objects.create(user=request.user,therapist=therapist.user,fee=fee,commission=commission,therapist_earnings=fee-commission,**data)
            return redirect('practice-appointment',pk=a.pk)
        except ValidationError as exc: form.add_error(None,str(exc.detail))
    return render(request,'practice/provider.html',{'provider':therapist,'form':form})


class PracticeAwareLoginView(LoginView):
    template_name='practice/login.html'
    def get_success_url(self):
        return self.get_redirect_url() or reverse('practice-dashboard')


class WorkLoginView(LoginView):
    template_name='work/login.html'
    def get_success_url(self):
        return self.get_redirect_url() or reverse('hearteli-work-index')


def signup(request):
    from apps.tracking.work_web import OwnerRegistrationForm
    from django.contrib.auth import login
    if request.user.is_authenticated: return redirect('practice-apply')
    form=OwnerRegistrationForm(request.POST or None)
    if request.method=='POST' and form.is_valid():
        user=User.objects.create_user(name=form.cleaned_data['name'],email=form.cleaned_data['email'],phone_number=form.cleaned_data['phone_number'],password=form.cleaned_data['password'])
        login(request,user,backend='django.contrib.auth.backends.ModelBackend')
        return redirect('practice-apply')
    return render(request,'practice/signup.html',{'form':form})
