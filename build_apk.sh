#!/bin/bash
flutter build apk --split-per-abi || exit 1
mkdir -p ~/APK
cp build/app/outputs/flutter-apk/*.apk ~/APK/
echo "APK copiés dans ~/APK"
