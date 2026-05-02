import 'package:flutter/material.dart';
import '../../animations.dart';
import '../../transitions/top_bar_transition.dart';

class DisappearingAppBar extends StatelessWidget {
  const DisappearingAppBar({
    super.key,
    required this.barAnimation,
    required this.title,
    this.actions,
    this.centerTitle,
  });

  final BarAnimation barAnimation;
  final Widget title;
  final List<Widget>? actions;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return TopBarTransition(
      animation: barAnimation,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: AppBar(
          title: title,
          actions: actions,
          centerTitle: centerTitle,
        ),
      ),
    );
  }
}
