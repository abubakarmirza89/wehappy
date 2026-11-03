
from django.contrib import admin
from django.urls import path, include
from django.contrib.auth.views import LoginView as WebLoginView, LogoutView as WebLogoutView
from apps.tracking import work_web, business_web
from apps.users import billing, practice_web
from apps.users import notification_web
from apps.users.email_test_web import email_test
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from rest_framework.authtoken.views import obtain_auth_token
from django.conf import settings
from apps.users.views import (
    ForgotPasswordView,
    LoginView,
    LogoutView,
    ResetPasswordView,
    SignupView,
    landing_page,
    reset_password_page, forgot_password_page
)

urlpatterns = [
    path('practice/signup/',practice_web.signup,name='practice-signup'),
    path('therapy/',practice_web.directory,name='therapy-directory'),
    path('therapy/<int:pk>/',practice_web.provider,name='therapy-provider'),
    path('work/<int:pk>/pages/<str:section>/',business_web.page,name='business-page'),
    path('work/<int:pk>/deactivate/<int:member_id>/',business_web.deactivate,name='business-deactivate'),
    path('practice/',practice_web.dashboard,name='practice-dashboard'),
    path('practice/apply/',practice_web.apply,name='practice-apply'),
    path('practice/profile/',practice_web.profile,name='practice-profile'),
    path('practice/withdraw/',practice_web.withdraw,name='practice-withdraw'),
    path('practice/appointments/<int:pk>/',practice_web.appointment,name='practice-appointment'),
    path('work/<int:pk>/billing/',billing.billing_page,name='business-billing'),
    path('work/<int:pk>/billing/checkout/',billing.checkout,name='business-checkout'),
    path('work/<int:pk>/billing/portal/',billing.portal,name='business-portal'),
    path('', landing_page, name='landing_page'),

    path(settings.ADMIN_URL, admin.site.urls),
    path('test=email', email_test, name='email-test'),
    path('test=email/', email_test),


    # DRF URL
    path("api/users/", include("apps.users.urls", namespace="users")),
    path("api/tracking/", include("apps.tracking.urls", namespace="track")),

    # DRF auth token
    path('api/login/', LoginView.as_view(), name='login'),
    path('api/logout/', LogoutView.as_view(), name='logout'),
    path('api/signup/', SignupView.as_view(), name='signup'),
    path('api/forgot-password/', ForgotPasswordView.as_view(), name='forgot-password'),
    path('api/reset-password/', ResetPasswordView.as_view(), name='reset-password'),
    path('notifications/', notification_web.inbox, name='hearteli-notifications'),
    path('notifications/nudges/<int:pk>/', notification_web.nudge_detail, name='hearteli-nudge-detail'),
    path('forgot-password/', forgot_password_page, name='hearteli-forgot-password'),
    path('reset-password/', reset_password_page, name='reset-password-page'),
    path('work/login/', practice_web.PracticeAwareLoginView.as_view(), name='hearteli-work-login'),
    path('work/register/', work_web.register, name='hearteli-work-register'),
    path('work/logout/', WebLogoutView.as_view(next_page='/work/login/'), name='hearteli-work-logout'),
    path('work/', work_web.index, name='hearteli-work-index'),
    path('work/new/', work_web.create_workspace, name='hearteli-work-create'),
    path('work/<int:pk>/', work_web.dashboard, name='hearteli-work-dashboard'),
    path('work/<int:pk>/invite/', work_web.invite, name='hearteli-work-invite'),
    path('work/<int:pk>/approve/<int:member_id>/', work_web.approve, name='hearteli-work-approve'),
    path('work/<int:pk>/role/<int:member_id>/', work_web.role, name='hearteli-work-role'),
    path('work/<int:pk>/resources/', work_web.add_resource, name='hearteli-work-resource-add'),
    path('work/<int:pk>/resources/<int:resource_id>/remove/', work_web.remove_resource, name='hearteli-work-resource-remove'),

    path("auth-token/", obtain_auth_token),
    path("api/schema/", SpectacularAPIView.as_view(), name="api-schema"),
    path("api/docs/", SpectacularSwaggerView.as_view(url_name="api-schema"), name="api-docs")
]
