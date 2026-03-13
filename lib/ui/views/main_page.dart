import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mona/ui/views/main_tab_config.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/ui/views/home/profile/profile_page.dart';
import 'main_tabs.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  bool _isUpdateAvailable = false;
  bool _hideUpdateBanner = false;

  MainTabConfig get currentTab => mainTabs[_selectedIndex];

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
    final prefs = context.read<PreferencesService>();
    if (!prefs.autoCheckUpdatesEnabled) return;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http.get(
        Uri.parse(
            'https://api.github.com/repos/melinokey/mona-hrt/releases/latest'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = data['tag_name'].toString().replaceAll('v', '');

        if (currentVersion != latestVersion && mounted) {
          setState(() {
            _isUpdateAvailable = true;
          });
        }
      }
    } catch (e) {
      // Silently ignore network or parsing errors during the automatic background check.
      // We don't want to show snackbars to the user just because they opened the app offline.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentTab.title),
        centerTitle: true,
        actions: currentTab.buildActions?.call(context),
      ),
      body: SafeArea(
        child: currentTab.page,
      ),
      //     |----------------------------------------------------|
      //     |  TODO implement indexed stack + correct scroll bug |
      //     |----------------------------------------------------|
      //        ||
      // (\__/) ||
      // (•ㅅ•) ||
      // / 　 づ
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isUpdateAvailable && !_hideUpdateBanner)
            Material(
              color: Theme.of(context).colorScheme.secondaryContainer,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.system_update_rounded,
                      color: Theme.of(context).colorScheme.onSecondaryContainer
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'A new update is available!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                      child: const Text('Go to Settings'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _hideUpdateBanner = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

          NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectIndex,
            destinations: [
              for (final tab in mainTabs)
                NavigationDestination(
                  label: tab.title,
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.selectedIcon),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: currentTab.buildFab?.call(context),
    );
  }
}
