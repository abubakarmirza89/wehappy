from .marketplace import MarketplaceSearchView,OfferingView,ConfirmActivityView
from .monetisation import NudgeSponsorView,SponsorEventView,RedeemOrganisationInvite
from .reviews import TherapistReviewsView,ReportReviewView
from .practice import ApplicationView, PracticeProfileView, AppointmentChatView, AppointmentPaymentView, AppointmentCheckoutView
from django.urls import path
from apps.users.views import (
    CreateAppointmentViewSet,
    FeedbackCreateView,
    TherapistListViewSet,
    TherapistProfileViewSet,
    UserHistoryListAPIView,
    AppointmentViewSet,
    NotificationViewSet,
    UserViewSet,
    DeviceTokenView,
    TherapistDashboardView,
    TherapistSettingsView,
    WithdrawalRequestView,
)

from .billing import webhook as stripe_webhook

app_name = "users"


urlpatterns = [
    path('reviews/<int:pk>/report/',ReportReviewView.as_view()),
    path('marketplace/search/',MarketplaceSearchView.as_view()),
    path('therapist/offerings/',OfferingView.as_view()),
    path('therapist/confirm-activity/',ConfirmActivityView.as_view()),
    path('nudges/<int:pk>/sponsor/',NudgeSponsorView.as_view()),
    path('sponsor-events/',SponsorEventView.as_view()),
    path('organisation-invitations/redeem/',RedeemOrganisationInvite.as_view()),
    path('therapists/<int:pk>/reviews/',TherapistReviewsView.as_view()),
    path('appointment/<int:pk>/checkout/',AppointmentCheckoutView.as_view()),
    path('therapist/application/', ApplicationView.as_view()),
    path('therapist/profile/', PracticeProfileView.as_view()),
    path('appointment/<int:pk>/payment/', AppointmentPaymentView.as_view()),
    path('appointment/<int:pk>/messages/', AppointmentChatView.as_view()),
    path('device-token/', DeviceTokenView.as_view(), name='device-token'),
    path('therapist/dashboard/', TherapistDashboardView.as_view(), name='therapist-dashboard'),
    path('therapist/settings/', TherapistSettingsView.as_view(), name='therapist-settings'),
    path('therapist/withdrawals/', WithdrawalRequestView.as_view(), name='therapist-withdrawals'),
    path('users/',
         UserViewSet.as_view({'get': 'list', }), name='users-list'),
    path('users/<int:pk>/', UserViewSet.as_view(
        {'get': 'retrieve', 'put': 'update', 'patch': 'partial_update', 'delete': 'destroy'}), name='users-detail'),

    path("therapists/", TherapistListViewSet.as_view(), name="api-therapist"),
        path("therapists/<int:pk>/", TherapistProfileViewSet.as_view(), name="api-therapist-profile"),

    path("feedback/<int:pk>/", FeedbackCreateView.as_view(), name="api-feedback"),
    path("create-appointment/<int:pk>/",
         CreateAppointmentViewSet.as_view(), name="api-create-appointment"),
    path("user-history/", UserHistoryListAPIView.as_view(), name="api-user-history"),

    path('appointment/<int:pk>/cancel/', AppointmentViewSet.as_view({'post': 'cancel'}), name='appointment-cancel'),
    path('appointment/',
         AppointmentViewSet.as_view({'get': 'list', }), name='appointment-list'),
    path('appointment/<int:pk>/', AppointmentViewSet.as_view(
        {'get': 'retrieve', 'put': 'update', 'patch': 'partial_update', 'delete': 'destroy'}), name='appointment-detail'),
    path('notifications/<int:pk>/read/', NotificationViewSet.as_view({'post': 'mark_read'}), name='notification-mark-read'),
    path('notifications/',
         NotificationViewSet.as_view({'get': 'list'}), name='notification-list'),
    path('notifications/<int:pk>/',
         NotificationViewSet.as_view({'get': 'retrieve'}), name='notification-detail'),


    path("webhook/stripe/", stripe_webhook, name="stripe_webhook"),
]
