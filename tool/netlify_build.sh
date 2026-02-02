#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define Flutter version
FLUTTER_VERSION="3.19.0" # or "stable"

echo "========================================================="
echo "  Setting up Flutter environment on Netlify"
echo "========================================================="

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
flutter build web --release --no-tree-shake-icons

echo "========================================================="
echo "  Build Complete!"
echo "========================================================="
