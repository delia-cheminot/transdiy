#!/bin/bash
set -e
fvm flutter build apk --split-per-abi
mkdir -p ~/apk/
cp build/app/outputs/flutter-apk/*.apk ~/apk/
echo "APK copiés dans ~/apk"
