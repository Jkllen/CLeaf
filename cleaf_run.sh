#!/bin/bash
# === CLeaf Flutter Quick Run Script ===
# This script cleans, fetches, builds, regenerates splash, and runs the app.
# Command to run: ./cleaf_run.sh

echo "Cleaning projects..."
flutter clean

echo "Getting dependencies..."
flutter pub get

echo "Generating native splash..."
dart run flutter_native_splash:create

echo "Running Flutter App..."
flutter run