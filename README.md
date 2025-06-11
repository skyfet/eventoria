# Eventoria

A minimal maintenance management prototype consisting of a Go backend and a Flutter web client.

## Services

- **Go backend** (`go-api` service) – simple Gin/GORM API in `backend/`.
- **Flutter frontend** (`flutter-web` service) – Flutter web app in `frontend_flutter/` managed via [melos](https://melos.invertase.dev/).

Start the stack locally with Docker Compose:

```bash
docker-compose up --build
```

After cloning run `melos bootstrap` to install Flutter dependencies. The Flutter app can then be launched with `melos exec -- flutter run -d chrome`.

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
