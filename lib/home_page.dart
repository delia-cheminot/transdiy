import 'package:flutter/material.dart';
import 'favorites_page.dart';
import 'generator_page.dart';
import 'pharmacy_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedIndex = 0;

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return GeneratorPage();
      case 1:
        return FavoritesPage();
      case 2:
        return PharmacyPage();
      default:
        throw UnimplementedError('Unknown index: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildNavigationBar() {
      return NavigationBar(
        onDestinationSelected: _selectIndex,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Suivi',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Pharmacie',
          ),
        ],
      );
    }

    PreferredSizeWidget _buildAppBar() {
      return AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            semanticLabel: 'menu',
          ),
          onPressed: () {},
        ),
        title: Text('TransDIY'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {},
          ),
        ],
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(child: _getPage(_selectedIndex)),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }
}
