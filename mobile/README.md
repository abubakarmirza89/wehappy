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