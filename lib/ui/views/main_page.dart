import 'package:flutter/material.dart';
import 'package:mona/distribution.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/services/update_service.dart';
import 'package:mona/ui/views/main_tab_config.dart';
import 'package:mona/ui/widgets/disappearing_bottom_navigation_bar.dart';
import 'package:mona/ui/widgets/disappearing_navigation_rail.dart';
import 'package:mona/ui/widgets/update_banner.dart';
import 'package:provider/provider.dart';
import 'main_tabs.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 800;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(currentTab.title),
          centerTitle: true,
          actions: currentTab.buildActions?.call(context),
        ),
        body: Row(
          children: [
            if (wideScreen)
              DisappearingNavigationRail(
                selectedIndex: _selectedIndex,
                backgroundColor: Colors.white,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            Expanded(
              child: SafeArea(
                child: currentTab.page,
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
        floatingActionButton: currentTab.buildFab?.call(context),
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
            if (!wideScreen)
              DisappearingBottomNavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
          ],
        ));
  }
}
