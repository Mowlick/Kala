# KALĀ — Creative Networking Platform

Kalā is a mobile-first platform built with Flutter and Supabase, designed to connect creative talents (singers, actors, dancers, etc.) with organizers hosting events and casting opportunities.

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.19.0 or higher)
- Dart SDK
- Android Studio or Xcode (for mobile development)

### Environment Setup
Kalā uses Supabase for backend services (Authentication, Database, Realtime). We use `--dart-define` for compile-time environment variables to keep credentials secure.

1. **Copy the example environment file**:
   A `.env.example` file is provided in the project root as a reference. You do not need a `.env` file to run the app if you pass variables directly, but you can copy it for your own reference:
   ```bash
   cp .env.example .env
   ```
   *Note: `.env` is ignored by Git.*

2. **Run the App**:
   To run the app locally, pass your Supabase credentials:
   ```bash
   flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```
   If credentials are not provided, the app will gracefully fall back to an "offline/mock" mode using seeded data.

## 🏗️ Architecture

- **State Management**: `Provider` is used for global state (e.g., `AuthController`, `EventController`, `OnboardingController`, `StudentProfileController`).
- **Backend**: Supabase provides Auth (Email/Phone), Postgres Database, and Realtime WebSocket subscriptions (e.g., for live application status updates).
- **Navigation**: Centralized named routes managed in `AppRoutes` and `AppRouter`.
- **UI/UX**: Custom design system defined in `core/theme/kala_theme.dart` and `kala_colors.dart`.

## 🧪 Testing

Run the test suite using:
```bash
flutter test
```

## 🔒 Security Notes
- **Never commit `.env` or hardcode API keys in the source code.**
- Authentication errors are sanitized to prevent leaking database details to the UI.
- Debug logging is sanitized and does not log full network error stack traces with credentials.

## 🤝 Contributing
Please read through the architecture overview and ensure you run `flutter analyze` and `flutter format .` before submitting pull requests.
