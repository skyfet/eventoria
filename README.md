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


This project is licensed under the MIT License. See [LICENSE](LICENSE) for
details.
