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
