@echo off
echo ============================================
echo    Labubu Coloring App - Quick Setup
echo ============================================
echo.

echo [1/4] Checking Flutter installation...
flutter --version
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter not found! Please install Flutter first.
    echo Download from: https://flutter.dev/docs/get-started/install/windows
    pause
    exit /b 1
)

echo [2/4] Getting dependencies...
flutter pub get

echo [3/4] Checking for connected devices...
flutter devices

echo [4/4] Building APK...
flutter build apk --debug

if %ERRORLEVEL% EQU 0 (
    echo.
    echo SUCCESS! APK built successfully!
    echo Location: build\app\outputs\flutter-apk\app-debug.apk
    echo.
    echo You can now install this APK on your Android device.
) else (
    echo.
    echo BUILD FAILED! Please check the errors above.
    echo.
    echo Common solutions:
    echo - Run: flutter doctor
    echo - Run: flutter doctor --android-licenses
    echo - Make sure Android Studio is installed
)

pause