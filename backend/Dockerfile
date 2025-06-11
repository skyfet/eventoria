FROM golang:1.21-alpine AS build
WORKDIR /src
COPY go.mod .
RUN go mod download
COPY . .
RUN go build -o server .

FROM alpine
WORKDIR /app
COPY --from=build /src/server ./server
CMD ["./server"]
