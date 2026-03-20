// SPDX-FileCopyrightText: 2026 Délia Cheminot <delia@cheminot.net>
//
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:decimal/decimal.dart';

Decimal parseDecimal(String text) {
  final sanitizedText = text.replaceAll(',', '.');
  return Decimal.parse(sanitizedText);
}

