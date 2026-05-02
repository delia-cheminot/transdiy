import 'package:flutter/material.dart';
import 'package:mona/animations.dart';
import 'package:mona/transitions/bottom_bar_transition.dart';
import 'package:mona/ui/views/main_tabs.dart';

class DisappearingBottomNavigationBar extends StatelessWidget {
  const DisappearingBottomNavigationBar({
    super.key,
    required this.barAnimation,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final BarAnimation barAnimation;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return BottomBarTransition(
      animation: barAnimation,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: NavigationBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        destinations: getMainTabs(context).map<NavigationDestination>((d) {
          return NavigationDestination(icon: Icon(d.icon), label: d.title);
        }).toList(),
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
