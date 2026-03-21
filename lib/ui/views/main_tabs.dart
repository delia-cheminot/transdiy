// main_tabs.dart
import 'package:flutter/material.dart';
import 'package:mona/ui/views/chart/blood_test_page.dart';
import 'package:mona/ui/views/supplies/supply_item_form_page.dart';
import 'chart/chart_page.dart';
import 'home/home_page.dart';
import 'home/settings/settings_page.dart';
import 'intakes/choose_schedule_page.dart';
import 'intakes/intakes_page.dart';
import 'main_tab_config.dart';
import 'supplies/pharmacy_page.dart';

final List<MainTabConfig> mainTabs = [
  MainTabConfig(
    title: 'Mona',
    page: HomePage(),
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    buildActions: (context) => [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
      ),
    ],
  ),
  MainTabConfig(
    title: 'Intakes',
    page: IntakesPage(),
    icon: Icons.event_outlined,
    selectedIcon: Icons.event_rounded,
    buildFab: (context) => FloatingActionButton(
      tooltip: 'Take an intake',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => ChooseSchedulePage(),
          ),
        );
      },
      child: const Icon(Icons.add),
    ),
  ),
  MainTabConfig(
    title: 'Levels',
    page: ChartPage(),
    icon: Icons.trending_up_outlined,
    selectedIcon: Icons.trending_up_rounded,
    buildActions: (context) => [
      IconButton(
        icon: const Icon(Icons.bloodtype_outlined),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => BloodTestPage()),
          );
        },
      ),
    ],
  ),
  MainTabConfig(
    title: 'Supplies',
    page: PharmacyPage(),
    icon: Icons.medication_outlined,
    selectedIcon: Icons.medication,
    buildFab: (context) => FloatingActionButton(
      tooltip: 'Add an item',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => SupplyItemFormPage(null),
          ),
        );
      },
      child: const Icon(Icons.add),
    ),
  ),
];
