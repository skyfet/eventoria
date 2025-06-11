# Flutter Frontend

This directory contains the Flutter web client. The application shows
object and work log lists and allows creating, editing and deleting them.

This project uses [FVM](https://fvm.app/) and expects Flutter **3.32.2**.
Install FVM (`dart pub global activate fvm`) and run:

```bash
fvm flutter run -d chrome
```

For production builds the provided Dockerfile compiles the web assets.

The API endpoint can be configured via the `API_BASE` compile-time constant,
e.g. `fvm flutter build web --dart-define=API_BASE=http://localhost:8080`.
