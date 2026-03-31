// SPDX-FileCopyrightText: 2026 Délia Cheminot <delia@cheminot.net>
//
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:flutter/material.dart';

class MainTabConfig {
  final String title;
  final Widget page;
  final IconData icon;
  final IconData selectedIcon;
  final List<Widget> Function(BuildContext context)? buildActions;
  final FloatingActionButton? Function(BuildContext context)? buildFab;

  const MainTabConfig({
    required this.title,
    required this.page,
    required this.icon,
    required this.selectedIcon,
    this.buildActions,
    this.buildFab,
  });
}
