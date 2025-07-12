#!/bin/bash

# Wisme Development Mode Switcher
# This script switches between production and test main.dart files

MAIN_PROD="lib/main.dart"
MAIN_TEST="lib/main_test.dart"
MAIN_BACKUP="lib/main_backup.dart"

if [ "$1" = "test" ]; then
    echo "🧪 Switching to TEST mode..."
    echo "   - Backing up production main.dart"
    cp "$MAIN_PROD" "$MAIN_BACKUP"
    echo "   - Activating test main.dart"
    cp "$MAIN_TEST" "$MAIN_PROD"
    echo "✅ Test mode activated!"
    echo "   Run: flutter run"
    echo "   This bypasses all API dependencies for screen testing"
    
elif [ "$1" = "prod" ]; then
    echo "🚀 Switching to PRODUCTION mode..."
    if [ -f "$MAIN_BACKUP" ]; then
        echo "   - Restoring production main.dart"
        cp "$MAIN_BACKUP" "$MAIN_PROD"
        rm "$MAIN_BACKUP"
        echo "✅ Production mode activated!"
        echo "   Run: flutter run"
        echo "   This requires API keys and full initialization"
    else
        echo "❌ No backup found. Production main.dart might already be active."
    fi
    
else
    echo "🎯 Wisme Development Mode Switcher"
    echo ""
    echo "Usage:"
    echo "  ./switch_mode.sh test    - Switch to test mode (bypass APIs)"
    echo "  ./switch_mode.sh prod    - Switch to production mode"
    echo ""
    echo "Current status:"
    if [ -f "$MAIN_BACKUP" ]; then
        echo "  📊 Currently in TEST mode"
    else
        echo "  🚀 Currently in PRODUCTION mode"
    fi
fi
