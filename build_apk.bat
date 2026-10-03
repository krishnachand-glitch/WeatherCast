@echo off
echo ============================================
echo   WeatherCast Pro - APK Builder
echo   "Forecasting Tomorrow, Today."
echo ============================================
echo.

REM Check if Flutter is available
where flutter >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Flutter is not in PATH.
    echo.
    echo Please install Flutter first:
    echo   1. Download from: https://docs.flutter.dev/get-started/install/windows/mobile
    echo   2. Extract to C:\src\flutter
    echo   3. Add C:\src\flutter\bin to your system PATH
    echo   4. Restart this terminal
    echo   5. Run this script again
    pause
    exit /b 1
)

echo [1/5] Generating Android project scaffolding...
flutter create --org com.weathercast --project-name weathercast_pro . --platforms android

echo.
echo [2/5] Adding Android permissions...
powershell -Command "(Get-Content 'android\app\src\main\AndroidManifest.xml') -replace '<manifest', '<manifest xmlns:tools=\"http://schemas.android.com/tools\"' -replace '</application>', '</application>' | Set-Content 'android\app\src\main\AndroidManifest.xml'"

REM Add permissions if not already present
powershell -Command "$xml = Get-Content 'android\app\src\main\AndroidManifest.xml' -Raw; if ($xml -notmatch 'ACCESS_FINE_LOCATION') { $xml = $xml -replace '(<manifest[^>]*>)', \"`$1`n    <uses-permission android:name=\"\"android.permission.INTERNET\"\"/>`n    <uses-permission android:name=\"\"android.permission.ACCESS_FINE_LOCATION\"\"/>`n    <uses-permission android:name=\"\"android.permission.ACCESS_COARSE_LOCATION\"\"/>\"; Set-Content 'android\app\src\main\AndroidManifest.xml' $xml; Write-Output '   Permissions added.' } else { Write-Output '   Permissions already present.' }"

echo.
echo [3/5] Installing dependencies...
flutter pub get

echo.
echo [4/5] Running analysis...
flutter analyze --no-fatal-infos --no-fatal-warnings

echo.
echo [5/5] Building release APK...
flutter build apk --release

echo.
echo ============================================
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo   SUCCESS! APK built successfully!
    echo.
    echo   APK Location:
    echo   build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo   Copy this file to your phone and install it.
    echo ============================================
    
    REM Open the folder
    explorer "build\app\outputs\flutter-apk"
) else (
    echo   Build may have encountered issues.
    echo   Check the output above for errors.
    echo ============================================
)
pause
