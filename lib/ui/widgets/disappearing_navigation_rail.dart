import 'package:flutter/material.dart';
import '../../animations.dart';
import '../../transitions/nav_rail_transition.dart';
import '../views/main_tabs.dart';
import 'animated_floating_action_button.dart';

class DisappearingNavigationRail extends StatelessWidget {
  const DisappearingNavigationRail({
    super.key,
    required this.railAnimation,
    required this.railFabAnimation,
    required this.backgroundColor,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final RailAnimation railAnimation;
  final RailFabAnimation railFabAnimation;
  final Color backgroundColor;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return NavRailTransition(
      animation: railAnimation,
      backgroundColor: backgroundColor,
      child: NavigationRail(
        selectedIndex: selectedIndex,
        backgroundColor: backgroundColor,
        onDestinationSelected: onDestinationSelected,
        leading: Column(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            const SizedBox(height: 8),
            AnimatedFloatingActionButton(
              animation: railFabAnimation,
              elevation: 0,
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ],
        ),
        groupAlignment: -0.85,
        destinations: getMainTabs(context).map((d) {
          return NavigationRailDestination(
            icon: Icon(d.icon),
            label: Text(d.title),
          );
        }).toList(),
      ),
    );
  }
}
