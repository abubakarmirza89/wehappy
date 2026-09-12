
from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from rest_framework.authtoken.views import obtain_auth_token
from django.conf import settings
from apps.users.views import (
    ForgotPasswordView,
    LoginView,
    LogoutView,
    ResetPasswordView,
    SignupView,
    landing_page
)

urlpatterns = [
    path('', landing_page, name='landing_page'),

    path(settings.ADMIN_URL, admin.site.urls),


    # DRF URL
    path("api/users/", include("apps.users.urls", namespace="users")),
    path("api/tracking/", include("apps.tracking.urls", namespace="track")),

    # DRF auth token
    path('api/login/', LoginView.as_view(), name='login'),
    path('api/logout/', LogoutView.as_view(), name='logout'),
    path('api/signup/', SignupView.as_view(), name='signup'),
    path('api/forgot-password/', ForgotPasswordView.as_view(), name='forgot-password'),
    path('api/reset-password/', ResetPasswordView.as_view(), name='reset-password'),

    path("auth-token/", obtain_auth_token),
    path("api/schema/", SpectacularAPIView.as_view(), name="api-schema"),
    path("api/docs/", SpectacularSwaggerView.as_view(url_name="api-schema"), name="api-docs")
]
