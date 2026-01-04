// main_tabs.dart
import 'package:flutter/material.dart';
import 'chart/chart_page.dart';
import 'home/home_page.dart';
import 'home/profile/profile_page.dart';
import 'intakes/intakes_page.dart';
import 'main_tab_config.dart';
import 'supplies/new_item_page.dart';
import 'supplies/pharmacy_page.dart';


final List<MainTabConfig> mainTabs = [
  MainTabConfig(
    title: 'Mona',
    page: HomePage(),
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    buildActions: (context) => [
      IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
      ),
    ],
  ),
  MainTabConfig(
    title: 'Prises',
    page: IntakesPage(),
    icon: Icons.event_outlined,
    selectedIcon: Icons.event_rounded,
    buildActions: (context) => [
      IconButton(
        icon: const Icon(Icons.calendar_month),
        onPressed: () {},
      ),
    ],
  ),
  MainTabConfig(
    title: 'Courbe',
    page: ChartPage(),
    icon: Icons.trending_up_outlined,
    selectedIcon: Icons.trending_up_rounded,
  ),
  MainTabConfig(
    title: 'Pharmacie',
    page: PharmacyPage(),
    icon: Icons.medication_outlined,
    selectedIcon: Icons.medication,
    buildFab: (context) => FloatingActionButton(
      tooltip: 'Add Item',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => NewItemPage(),
          ),
        );
      },
      child: const Icon(Icons.add),
    ),
  ),
];