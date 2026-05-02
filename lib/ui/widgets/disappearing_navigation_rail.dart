import 'package:flutter/material.dart';
import 'package:mona/animations.dart';
import 'package:mona/transitions/nav_rail_transition.dart';
import 'package:mona/ui/views/main_tabs.dart';
import 'animated_floating_action_button.dart';

class DisappearingNavigationRail extends StatelessWidget {
  const DisappearingNavigationRail({
    super.key,
    required this.railAnimation,
    required this.railFabAnimation,
    required this.backgroundColor,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.fab,
  });

  final RailAnimation railAnimation;
  final RailFabAnimation railFabAnimation;
  final Color backgroundColor;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final FloatingActionButton? fab;

  @override
  Widget build(BuildContext context) {
    return NavRailTransition(
      animation: railAnimation,
      backgroundColor: backgroundColor,
      child: NavigationRail(
        selectedIndex: selectedIndex,
        backgroundColor: backgroundColor,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        leading: fab == null
            ? const SizedBox(
                width: 45,
                height: 45,
              )
            : AnimatedFloatingActionButton(
                animation: railFabAnimation,
                elevation: 0,
                onPressed: fab!.onPressed,
                tooltip: fab!.tooltip,
                child: fab!.child,
              ),
        groupAlignment: 0,
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
