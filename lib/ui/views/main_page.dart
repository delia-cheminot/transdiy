import 'package:flutter/material.dart';
import 'package:mona/ui/views/main_tab_config.dart';
import 'main_tabs.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  MainTabConfig get currentTab => mainTabs[_selectedIndex];

  void _selectIndex(int index) {
    setState(() => _selectedIndex = index);
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
      bottomNavigationBar: NavigationBar(
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
      floatingActionButton: currentTab.buildFab?.call(context),
    );
  }
}
