# Eventoria

This repository contains a minimal maintenance management prototype.

## Services

- **Go backend** (`go-api` service) – simple Gin/GORM API in `backend/`.
- **Flutter frontend** (`flutter-web` service) – Flutter web app in
  `frontend_flutter/`.

The project can be started locally via Docker Compose:

```bash
docker-compose up --build
```

Run Go unit tests with:

```bash
cd backend && go test ./...
```

## Melos Workspace

The Flutter frontend is managed using [melos](https://melos.invertase.dev/).
Install melos (`flutter pub global activate melos`) then bootstrap packages:

```bash
melos bootstrap
```

The `build-web` script can be executed via `melos run build-web` to create a web
release build of the frontend.


This project is licensed under the MIT License. See [LICENSE](LICENSE) for
details.
