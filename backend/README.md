# Go Backend

This service provides a minimal REST API using Gin and GORM. The SQLite database
location can be configured with the `DATABASE_PATH` environment variable (defaults
to `data.db`). The listening port can be changed with the `PORT` environment
variable (defaults to `8080`).

Available endpoints:

- `GET /` – health check
- `POST /objects`, `GET /objects`, `GET/PUT/DELETE /objects/:id`
- `POST /workorders`, `GET /workorders`, `GET/PUT/DELETE /workorders/:id`
- `POST /worklogs`, `GET /worklogs`, `GET/PUT/DELETE /worklogs/:id`

Run the service locally:

```bash
cd backend
# Customize database path and port if desired
DATABASE_PATH=data.db PORT=8080 go run .
```
