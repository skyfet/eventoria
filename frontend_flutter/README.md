# Flutter Frontend

This directory contains the Flutter web client. The application shows
object and work log lists and allows creating, editing and deleting them.

To run locally you need Flutter SDK installed. Then execute:

```bash
flutter run -d chrome
```

For production builds the provided Dockerfile compiles the web assets.

The API endpoint can be configured via the `API_BASE` compile-time constant,
e.g. `flutter build web --dart-define=API_BASE=http://localhost:8080`.
