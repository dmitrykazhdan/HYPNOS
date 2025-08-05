#!/bin/bash

# Build script for Appetize.io deployment
# This script creates an optimized build for Appetize.io

set -e

echo "🚀 Building HYPNOS for Appetize.io..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="hypnos_app"
BUILD_DIR="build"
APK_NAME="hypnos-appetize.apk"
BUNDLE_NAME="hypnos-appetize.aab"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for Android (APK for Appetize)
echo "🔨 Building Android APK..."
flutter build apk \
  --release \
  --target-platform android-arm64 \
  --dart-define=USE_LOCAL_MODEL=true \
  --dart-define=DEMO_MODE=true \
  --output="$BUILD_DIR/$APK_NAME"

# Also build AAB for Play Store (optional)
echo "📦 Building Android App Bundle..."
flutter build appbundle \
  --release \
  --target-platform android-arm64 \
  --dart-define=USE_LOCAL_MODEL=true \
  --dart-define=DEMO_MODE=true \
  --output="$BUILD_DIR/$BUNDLE_NAME"

# Check if build was successful
if [ -f "$BUILD_DIR/$APK_NAME" ]; then
    echo "${GREEN}✅ Build successful!${NC}"
    echo "📱 APK: $BUILD_DIR/$APK_NAME"
    echo "📦 AAB: $BUILD_DIR/$BUNDLE_NAME"
    echo ""
    echo "📊 File sizes:"
    ls -lh "$BUILD_DIR/$APK_NAME"
    ls -lh "$BUILD_DIR/$BUNDLE_NAME"
    echo ""
    echo "🎯 Ready for Appetize.io upload!"
    echo "   Upload the APK file to: https://appetize.io/upload"
else
    echo "${RED}❌ Build failed!${NC}"
    exit 1
fi

echo ""
echo "📋 Next steps:"
echo "1. Go to https://appetize.io/upload"
echo "2. Upload: $BUILD_DIR/$APK_NAME"
echo "3. Configure using appetize.yml"
echo "4. Share the demo link!" 