@echo off
REM San Alejo Flutter Project Setup Script for Windows
REM This script initializes the Flutter project structure

setlocal enabledelayedexpansion

echo.
echo 🚀 San Alejo Flutter Project Setup
echo ====================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ ERROR: Flutter is not installed or not in PATH
    echo.
    echo To install Flutter:
    echo 1. Visit: https://flutter.dev/docs/get-started/install
    echo 2. Add Flutter to your PATH
    echo 3. Run: flutter doctor
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%A in ('flutter --version ^| find /v ""') do (
    echo ✅ Flutter is installed: %%A
    goto :flutter_ok
)

:flutter_ok
echo.

REM Get current directory
for %%A in (.) do set PROJECT_DIR=%%~fA
echo 📁 Project directory: !PROJECT_DIR!
echo.

REM Step 1: Check if we need to create platform-specific code
if not exist "!PROJECT_DIR!\android" (
    echo 📦 Creating platform-specific code (android, ios, web, etc^.)...
    cd /d "!PROJECT_DIR!"
    call flutter create . --platforms android,ios,web
    if %errorlevel% neq 0 (
        echo ❌ Failed to create platform code
        pause
        exit /b 1
    )
    echo ✅ Platform code created successfully
) else (
    echo ✅ Platform code already exists
)

echo.

REM Step 2: Get dependencies
echo 📚 Installing dependencies...
cd /d "!PROJECT_DIR!"
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)
echo ✅ Dependencies installed successfully

echo.

REM Step 3: Verify setup
echo 🔍 Verifying setup...
flutter doctor

echo.
echo ✅ Setup complete!
echo.
echo Next steps:
echo 1. Start an emulator: flutter emulators --launch ^<emulator_id^>
echo 2. Run the app: flutter run
echo.
echo For more information, see README.md and SETUP.md
echo.
pause
