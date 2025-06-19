FROM golang:1.20 AS builder
WORKDIR /app
COPY login.go .
RUN go build -ldflags="-s -w" -o login login.go

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/login /login
RUN chmod +x /login

ENTRYPOINT ["/login"]
