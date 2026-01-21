#!/bin/bash
flutter build apk --split-per-abi || exit 1
cp build/app/outputs/flutter-apk/*.apk android/apk/
echo "APK copiés dans android/apk"
