#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "========================================================="
echo "  Setting up Flutter environment on Netlify"
echo "========================================================="

# Create .env file from Netlify environment variables
echo "Creating .env file from environment variables..."
cat > .env << EOF
SUPABASE_URL=$SUPABASE_URL
SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
GO_API_BASE_URL=$GO_API_BASE_URL
PAYSTACK_PUBLIC_KEY=$PAYSTACK_PUBLIC_KEY
EOF

echo ".env file created with contents:"
cat .env

# Create a directory for the Flutter SDK
mkdir -p _flutter

# Download Flutter SDK if not already cached
if [ ! -d "_flutter/bin" ]; then
  echo "Downloading Flutter SDK..."
  git clone https://github.com/flutter/flutter.git _flutter -b stable --depth 1
fi

# Add Flutter binary to PATH
export PATH="$PATH:`pwd`/_flutter/bin"

echo "Flutter version:"
flutter --version

echo "========================================================="
echo "  Building Flutter Web App"
echo "========================================================="

# Enable web support (just in case)
flutter config --enable-web

# Get dependencies
flutter pub get

# Build the web application
# Using HTML renderer for better compatibility and to avoid CORS issues with CanvasKit on Netlify
flutter build web --release --web-renderer html --no-tree-shake-icons --no-wasm-dry-run

echo "========================================================="
echo "  Build Complete!"
echo "========================================================="
