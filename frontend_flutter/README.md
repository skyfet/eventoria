# Flutter Frontend

This directory contains the Flutter web client managed by [melos](https://melos.invertase.dev/).

Install Flutter and melos globally:

```bash
dart pub global activate melos
melos bootstrap
```

Run the app locally with:

```bash
melos exec -- flutter run -d chrome
```

For production builds the provided Dockerfile compiles the web assets. You can also run

```bash
melos run build -- --dart-define=API_BASE=http://localhost:8080
```

The API endpoint is passed via the `API_BASE` compile-time constant.
