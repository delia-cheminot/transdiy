#!/bin/bash
flutter build apk --split-per-abi || exit 1
cp build/app/outputs/flutter-apk/*.apk /apk
echo "APK copiés dans /apk"
