// SPDX-FileCopyrightText: 2026 Délia Cheminot <delia@cheminot.net>
//
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:flutter/material.dart';

class FormSpacer extends StatelessWidget {
  final double height;

  const FormSpacer({this.height = 16, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
