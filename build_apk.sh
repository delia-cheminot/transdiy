#!/bin/bash

# SPDX-FileCopyrightText: 2026 Alice Lorido <alice@lori.do>
# SPDX-FileCopyrightText: 2026 Mel "Melinokey"
# SPDX-FileContributor: Délia Cheminot <delia@cheminot.net>
#
# SPDX-License-Identifier: AGPL-3.0-only

set -e
fvm flutter build apk --split-per-abi
mkdir -p ~/apk/
cp build/app/outputs/flutter-apk/*.apk ~/apk/
echo "APK copiés dans ~/apk"
