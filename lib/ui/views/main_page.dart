import 'package:flutter/material.dart';
import 'package:mona/animations.dart';
import 'package:mona/distribution.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/services/update_service.dart';
import 'package:mona/ui/views/main_tab_config.dart';
import 'package:mona/ui/widgets/animated_floating_action_button.dart';
import 'package:mona/ui/widgets/disappearing_app_bar.dart';
import 'package:mona/ui/widgets/disappearing_bottom_navigation_bar.dart';
import 'package:mona/ui/widgets/disappearing_navigation_rail.dart';
import 'package:mona/ui/widgets/update_banner.dart';
import 'package:provider/provider.dart';
import 'main_tabs.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  bool _isUpdateAvailable = false;
  bool _hideUpdateBanner = false;

  MainTabConfig get currentTab => getMainTabs(context)[_selectedIndex];

  void _selectIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runAutomaticUpdateCheck();
    });
  }

  Future<void> _runAutomaticUpdateCheck() async {
    if (isPlayStoreDistribution) return;
    final prefs = context.read<PreferencesService>();
    if (!prefs.autoCheckUpdatesEnabled) return;

    final isAvailable = await UpdateService().isUpdateAvailable();

    if (isAvailable && mounted) {
      setState(() {
        _isUpdateAvailable = true;
      });
    }
  }

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 1250),
    value: 0,
    vsync: this,
  );

  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);
  late final _barAnimation = BarAnimation(parent: _controller);

  bool controllerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;

    final AnimationStatus status = _controller.status;
    if (width > 700) {
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      _controller.value = width > 700 ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fab = currentTab.buildFab?.call(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
            body: Row(
              children: [
                DisappearingNavigationRail(
                  railAnimation: _railAnimation,
                  railFabAnimation: _railFabAnimation,
                  selectedIndex: _selectedIndex,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  fab: fab,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      DisappearingAppBar(
                        barAnimation: _barAnimation,
                        title: Text(currentTab.title),
                        centerTitle: true,
                        actions: currentTab.buildActions?.call(context),
                      ),
                      Expanded(
                        child: SafeArea(
                          top: false,
                          child: currentTab.page,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //     |----------------------------------------------------|
            //     |  TODO implement indexed stack + correct scroll bug |
            //     |----------------------------------------------------|
            //        ||
            // (\__/) ||
            // (•ㅅ•) ||
            // / 　 づ

            floatingActionButton: fab == null
                ? null
                : AnimatedFloatingActionButton(
                    animation: _barAnimation,
                    onPressed: fab.onPressed,
                    tooltip: fab.tooltip,
                    child: fab.child,
                  ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isUpdateAvailable && !_hideUpdateBanner)
                  UpdateBanner(
                    onClose: () {
                      setState(() {
                        _hideUpdateBanner = true;
                      });
                    },
                  ),
                DisappearingBottomNavigationBar(
                  barAnimation: _barAnimation,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ],
            ));
      },
    );
  }
}
