import 'package:flutter/material.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/services/update_service.dart';
import 'package:mona/ui/views/home/settings/schedules/schedules_page.dart';
import 'package:mona/ui/views/main_tab_config.dart';
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
  bool _hideUpdateDialog = false;

  MainTabConfig get currentTab => getMainTabs(context)[_selectedIndex];

  void _selectIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runAutomaticUpdateCheck();

      if (context.read<PreferencesService>().shouldShowScheduleDialog &&
          mounted) {
        _showUpdateDialog();
      }
    });
  }

  Future<void> _runAutomaticUpdateCheck() async {
    final prefs = context.read<PreferencesService>();
    if (!prefs.autoCheckUpdatesEnabled) return;

    final isAvailable = await UpdateService().isUpdateAvailable();

    if (isAvailable && mounted) {
      setState(() {
        _isUpdateAvailable = true;
      });
    }
  }

  void _showUpdateDialog() {
    final localizations = context.l10n;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.notificationsUpdated),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(localizations.notificationsUpdatedDescription,
                      textAlign: TextAlign.start),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _hideUpdateDialog,
                        onChanged: (value) {
                          setState(() {
                            _hideUpdateDialog = value ?? false;
                          });
                        },
                      ),
                      Text(localizations.dontShowAgain),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_hideUpdateDialog) {
                  final preferencesService = context.read<PreferencesService>();
                  await preferencesService.setShowScheduleDialog(false);
                }

                if (!context.mounted) return;

                Navigator.of(context).pop();
                if (!context.mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SchedulesPage(),
                  ),
                );
              },
              child: Text(localizations.scheduleSettings),
            ),
          ],
        );
      },
    );
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
            UpdateBanner(
              onClose: () {
                setState(() {
                  _hideUpdateBanner = true;
                });
              },
            ),
          NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectIndex,
            destinations: [
              for (final tab in getMainTabs(context))
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
