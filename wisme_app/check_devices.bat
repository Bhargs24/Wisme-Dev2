@echo off
echo 🔍 Checking available Flutter devices...
echo.
flutter devices
echo.
echo 📱 If your Android emulator is not listed above, start it with:
echo    flutter emulators --launch android
echo.
echo 🚀 To run on Android specifically, use:
echo    flutter run lib/main_test.dart -d emulator-5554
echo.
pause
