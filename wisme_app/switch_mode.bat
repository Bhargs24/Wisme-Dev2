@echo off
REM Wisme Development Mode Switcher for Windows
REM This script switches between production and test main.dart files

set MAIN_PROD=lib\main.dart
set MAIN_TEST=lib\main_test.dart
set MAIN_BACKUP=lib\main_backup.dart

if "%1"=="test" (
    echo 🧪 Switching to TEST mode...
    echo    - Backing up production main.dart
    copy "%MAIN_PROD%" "%MAIN_BACKUP%" >nul
    echo    - Activating test main.dart
    copy "%MAIN_TEST%" "%MAIN_PROD%" >nul
    echo ✅ Test mode activated!
    echo    Run: flutter run
    echo    This bypasses all API dependencies for screen testing
    goto end
)

if "%1"=="prod" (
    echo 🚀 Switching to PRODUCTION mode...
    if exist "%MAIN_BACKUP%" (
        echo    - Restoring production main.dart
        copy "%MAIN_BACKUP%" "%MAIN_PROD%" >nul
        del "%MAIN_BACKUP%" >nul
        echo ✅ Production mode activated!
        echo    Run: flutter run
        echo    This requires API keys and full initialization
    ) else (
        echo ❌ No backup found. Production main.dart might already be active.
    )
    goto end
)

echo 🎯 Wisme Development Mode Switcher
echo.
echo Usage:
echo   switch_mode.bat test    - Switch to test mode (bypass APIs)
echo   switch_mode.bat prod    - Switch to production mode
echo.
echo Current status:
if exist "%MAIN_BACKUP%" (
    echo   📊 Currently in TEST mode
) else (
    echo   🚀 Currently in PRODUCTION mode
)

:end
