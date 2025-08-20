# syntax=docker/dockerfile:1

# ----- Build stage -----
FROM golang:1.24 AS builder

WORKDIR /src

# Enable reproducible and smaller static builds
ENV CGO_ENABLED=0

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source
COPY . .

# Build the app binary
RUN --mount=type=cache,target=/root/.cache/go-build \
    go build -ldflags="-s -w" -o /out/server ./...

# ----- Runtime stage -----
FROM gcr.io/distroless/static:nonroot

WORKDIR /app

# Copy binary and templates
COPY --from=builder /out/server /app/server
COPY --from=builder /src/templates /app/templates

# App listens on port 1323
EXPOSE 1323

# Optional: allow overriding GREETING_NAME at runtime via env (set by tofu)
ENV GREETING_NAME=""

USER nonroot:nonroot
ENTRYPOINT ["/app/server"]
