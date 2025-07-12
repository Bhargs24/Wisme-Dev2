@echo off
echo 🚀 Starting Wisme Test Mode on Android Emulator...
echo.
echo 📱 Target Device: Android Emulator
echo 📁 Entry Point: lib/main_test.dart
echo ⚡ Mode: Test Mode (No API Dependencies)
echo.

cd /d "d:\Startups\Wisme\Development\Wisme-Dev2\wisme_app"
flutter run lib/main_test.dart -d emulator-5554

pause
