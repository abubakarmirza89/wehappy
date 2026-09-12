# WeHappy API Documentation

This document lists the main API endpoints for the WeHappy app.

## Base URLs
- Local app: http://127.0.0.1:8000
- Auth endpoints live under /api/
- Tracking endpoints live under /api/tracking/

## Authentication

### 1) Signup
- POST /api/signup/
- Body:
  {
    "name": "Ali Khan",
    "email": "ali@example.com",
    "password": "StrongPass123",
    "phone_number": "+923001234567",
    "is_therapist": false
  }

### 2) Login
- POST /api/login/
- Body:
  {
    "email": "ali@example.com",
    "password": "StrongPass123"
  }

### 3) Logout
- POST /api/logout/
- Requires: authenticated user token/session

### 4) Forgot password
- POST /api/forgot-password/
- Body:
  {
    "email": "ali@example.com"
  }
- Sends a reset email if the account exists.

### 5) Reset password
- POST /api/reset-password/
- Body:
  {
    "uid": "<encoded-user-id>",
    "token": "<reset-token>",
    "new_password": "NewStrongPass456"
  }

## User APIs

### User list / detail
- GET /api/users/users/
- GET /api/users/users/<id>/
- PUT /api/users/users/<id>/
- PATCH /api/users/users/<id>/
- DELETE /api/users/users/<id>/

### Therapists
- GET /api/users/therapists/
- GET /api/users/therapists/<id>/

### Appointments
- GET /api/users/appointment/
- GET /api/users/appointment/<id>/
- POST /api/users/create-appointment/<therapist_id>/
- PUT /api/users/appointment/<id>/

### Feedback
- POST /api/users/feedback/<therapist_id>/

### Notifications
- GET /api/users/notifications/
- GET /api/users/notifications/<id>/

## Tracking APIs

### Relatives
- GET /api/tracking/relatives/
- POST /api/tracking/relatives/
- GET /api/tracking/relatives/<id>/
- PUT /api/tracking/relatives/<id>/
- DELETE /api/tracking/relatives/<id>/

### Mood endpoints
- GET /api/tracking/moods/
- GET /api/tracking/suggestions/by-mood/
- GET /api/tracking/check_user/

### Mood check-ins
- GET /api/tracking/mood-check-ins/
- POST /api/tracking/mood-check-ins/
- GET /api/tracking/mood-check-ins/<id>/
- PUT /api/tracking/mood-check-ins/<id>/

### Chat
- GET /api/tracking/chat-conversations/
- POST /api/tracking/chat-conversations/
- GET /api/tracking/chat/<conversation_id>/messages/

### Notifications to relatives
- GET /api/tracking/mood-notifications/
- POST /api/tracking/mood-notifications/send_to_relatives/

### Email / WhatsApp
- POST /api/tracking/notifications/send-email/
  Body:
  {
    "recipient_email": "partner@example.com",
    "subject": "Daily check-in",
    "message": "Please check in tonight."
  }
- POST /api/tracking/notifications/send-whatsapp/
  Body:
  {
    "to_phone": "+923001234567",
    "message": "Your loved one needs support."
  }

### Gratitude
- GET /api/tracking/gratitude-entries/
- POST /api/tracking/gratitude-entries/
- GET /api/tracking/gratitude-entries/today/

### Workspaces
- GET /api/tracking/workspaces/
- POST /api/tracking/workspaces/
- POST /api/tracking/workspaces/join/
- POST /api/tracking/workspaces/<id>/approve_member/
- POST /api/tracking/workspaces/<id>/toggle_consent/

### Workspace memberships / support requests
- GET /api/tracking/workspace-memberships/
- GET /api/tracking/support-requests/

## Email and SMS / WhatsApp config

### SMTP example
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
DEFAULT_FROM_EMAIL=your-email@gmail.com

### Twilio example
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_WHATSAPP_FROM=whatsapp:+14155238886

## Notes
- The project uses Django REST Framework with token authentication.
- The WhatsApp sender only sends when Twilio credentials are configured.
- Reset passwords and email notifications are safe and validated with Django’s token system.
