# --- STAGE 1: Build ---
# Menggunakan image official dari CirrusLabs (biasanya paling update)
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Copy file pubspec
COPY pubspec.yaml ./

# Install dependencies
RUN flutter pub get

# Copy seluruh sisa source code
COPY . .

# Build aplikasi web
RUN flutter build web --release

# --- STAGE 2: Serve ---
FROM nginx:alpine

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
