# Eventoria

This repository contains a minimal maintenance management prototype.

## Services

- **FastAPI backend** (`api` service) – existing Python service serving REST
  endpoints for objects and work logs.
- **Go backend** (`go-api` service) – simple Gin/GORM API in `backend/`.
- **React frontend** (`frontend` service) – existing web UI.
- **Flutter frontend** (`flutter-web` service) – Flutter web app in
  `frontend_flutter/`.

The project can be started locally via Docker Compose:

```bash
docker-compose up --build
```

Run unit tests with `pytest`.
