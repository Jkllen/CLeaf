# === CLeaf Flutter Quick Run Script ===
# This script cleans, fetches, builds, regenerates splash, and runs the app.
# Command to run: ./cleaf_run.ps1

Write-Host "Cleaning project..."
flutter clean

Write-Host "Getting dependencies..."
flutter pub get

Write-Host "Building web assets..."
flutter build web

Write-Host "Generating native splash..."
dart run flutter_native_splash:create

Write-Host "Running Flutter app..."
flutter run
