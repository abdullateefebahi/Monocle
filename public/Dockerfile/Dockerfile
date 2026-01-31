# STAGE 1: Build Flutter Web
FROM debian:latest AS flutter-builder

# Install Flutter dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"
RUN flutter doctor
RUN flutter config --enable-web

# Build the Web App
WORKDIR /app
COPY ./monocle_app .
RUN flutter pub get
RUN flutter build web --release

# STAGE 2: Build Go Backend
FROM golang:1.21-alpine AS go-builder
WORKDIR /app
COPY ./monocle_server/go.mod ./monocle_server/go.sum ./
RUN go mod download
COPY ./monocle_server .
RUN go build -o main main.go

# STAGE 3: Final Production Image
FROM alpine:latest
WORKDIR /root/

# Copy the Go binary from stage 2
COPY --from=go-builder /app/main .

# Copy the Flutter Web files from stage 1 into a 'public' folder
COPY --from=flutter-builder /app/build/web ./public

# Expose the port Railway/Northflank uses
EXPOSE 8080

# Start the Monocle server
CMD ["./main"]