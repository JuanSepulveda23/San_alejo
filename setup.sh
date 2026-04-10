#!/bin/bash

# San Alejo Flutter Project Setup Script
# This script initializes the Flutter project structure

set -e

echo "🚀 San Alejo Flutter Project Setup"
echo "===================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ ERROR: Flutter is not installed or not in PATH"
    echo ""
    echo "To install Flutter:"
    echo "1. Visit: https://flutter.dev/docs/get-started/install"
    echo "2. Add Flutter to your PATH"
    echo "3. Run: flutter doctor"
    echo ""
    exit 1
fi

echo "✅ Flutter is installed: $(flutter --version | head -1)"
echo ""

# Get current directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📁 Project directory: $PROJECT_DIR"
echo ""

# Step 1: Check if we need to create platform-specific code
if [ ! -d "$PROJECT_DIR/android" ]; then
    echo "📦 Creating platform-specific code (android, ios, web, etc.)..."
    cd "$PROJECT_DIR"
    flutter create . --platforms android,ios,web
    echo "✅ Platform code created successfully"
else
    echo "✅ Platform code already exists"
fi

echo ""

# Step 2: Get dependencies
echo "📚 Installing dependencies..."
cd "$PROJECT_DIR"
flutter pub get
echo "✅ Dependencies installed successfully"

echo ""

# Step 3: Verify setup
echo "🔍 Verifying setup..."
flutter doctor -v | head -20

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Start an emulator: flutter emulators --launch <emulator_id>"
echo "2. Run the app: flutter run"
echo ""
echo "For more information, see README.md and SETUP.md"
