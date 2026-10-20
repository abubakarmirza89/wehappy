# MindMenta Mobile

Flutter client for the MindMenta Django API.

## Run locally

From this directory, install Flutter dependencies and start the app with the API URL for the target device:

```powershell
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Use `http://127.0.0.1:8000` for Flutter web or an iOS simulator. For a physical phone, use the development machine's LAN IP.

## Structure

- `lib/core`: API client, session persistence, configuration, and theme tokens
- `lib/features`: auth, home, moods, therapists, appointments, and profile flows
- `lib/shared`: reusable buttons, loading/error states, and section headers
- `lib/page-1`: legacy generated screens kept for compatibility while the feature flow replaces them

The Django API uses token authentication. `SessionStore` persists the token and `ApiClient` adds the `Authorization: Token ...` header to authenticated requests.

## Firebase notifications

1. Register the Android app in Firebase with application ID `com.hearteli.app`, enable Firebase Cloud Messaging HTTP v1, and add `google-services.json` to `android/app/`. For iOS, add `GoogleService-Info.plist` and configure APNs.
2. Set `FIREBASE_CREDENTIALS_PATH` on the Django server to a Firebase service-account JSON file from the same Firebase project. Store this private key as a server secret; it is not the Android `google-services.json` and must never be placed in the mobile app or committed.
3. Keep the Celery worker and beat running (`celery -A config worker -l INFO` and `celery -A config beat -l INFO`), or run `python manage.py process_hearteli_notifications` every minute. The server sends three generic push prompts each day at randomized times between 08:00 and 22:00 in the selected timezone, at least four hours apart, to active accounts with an authorised device token. This schedule continues after check-in and ignores the in-app reminder toggle and quiet hours; device notification permission can still be revoked in Android settings.
4. Run the app on a real Android device, sign in, and allow notifications. It registers the FCM token at `/api/users/device-token/` and refreshes it when Firebase rotates the token. FCM notification messages display while the app is backgrounded; while it is open, the app shows an in-app banner.

Without Firebase files, the app remains usable and the backend stores no push token; delivery is reported as not configured rather than crashing.