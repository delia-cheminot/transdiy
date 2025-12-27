import 'package:flutter/material.dart';
import 'main_tabs.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  get currentTab => mainTabs[_selectedIndex];

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: currentTab.page,
        ),
      ),
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
