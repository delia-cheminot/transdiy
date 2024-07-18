import 'package:flutter/material.dart';
import 'favorites_page.dart';
import 'generator/generator_page.dart';
import 'supplies/new_item_dialog.dart';
import 'supplies/pharmacy_page.dart';

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

  SafeArea _getPage(int index) {
    switch (index) {
      case 0:
        return SafeArea(child: GeneratorPage());
      case 1:
        return SafeArea(child: FavoritesPage());
      case 2:
        return SafeArea(child: PharmacyPage());
      default:
        throw UnimplementedError('Unknown index: $index');
    }
  }

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

  FloatingActionButton? _buildFloatingActionButton() {
    void _newItem() {
      showDialog(
        context: context,
        builder: (context) => NewItemDialog(),
      );
    }

    return _selectedIndex == 2
        ? FloatingActionButton(
            onPressed: _newItem,
            tooltip: 'Add Item',
            child: Icon(Icons.add),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: _buildNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}
