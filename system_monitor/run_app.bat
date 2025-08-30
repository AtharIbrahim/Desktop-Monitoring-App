@echo off
echo System Monitor - Flutter Desktop App
echo ====================================
echo.

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo Error: Flutter is not installed or not in PATH
    echo Please install Flutter and add it to your system PATH
    pause
    exit /b 1
)

echo.
echo Installing dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Starting System Monitor...
echo Note: The app will start in debug mode
echo Press Ctrl+C to stop the application
echo.

flutter run -d windows

pause
