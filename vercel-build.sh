#!/bin/bash
set -e

echo "=== Celebrities App: Vercel Build Script ==="

# Define Flutter install directory in HOME to avoid repo pollution
FLUTTER_DIR="$HOME/flutter"

if [ -d "$FLUTTER_DIR/bin" ]; then
  echo "Using cached Flutter SDK at $FLUTTER_DIR"
else
  echo "Downloading Flutter SDK (stable channel)..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

echo "Flutter version:"
flutter --version

echo "Resolving dependencies..."
flutter pub get

# Check environment variables without printing secret values
if [ -n "$TMDB_API_KEY" ]; then
  echo "TMDB_API_KEY is configured in Vercel Environment Variables."
else
  echo "Notice: TMDB_API_KEY is not set. Using build-time fallback."
fi

if [ -n "$GEMINI_API_KEY" ]; then
  echo "GEMINI_API_KEY is configured in Vercel Environment Variables."
else
  echo "Notice: GEMINI_API_KEY is not set. Using build-time fallback."
fi

echo "Building Flutter Web release with --dart-define parameters..."
flutter build web --release \
  --dart-define=TMDB_API_KEY="${TMDB_API_KEY:-YOUR_TMDB_API_KEY}" \
  --dart-define=GEMINI_API_KEY="${GEMINI_API_KEY:-YOUR_GEMINI_API_KEY}"

echo "Build completed successfully. Output ready in build/web."
