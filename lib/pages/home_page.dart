import 'package:flutter/material.dart';
import 'package:transdiy/pages/intakes/intakes_page.dart';
import 'home/home_page.dart';
import 'supplies/new_item_dialog.dart';
import 'supplies/pharmacy_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _selectedIndex = 0;

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  SafeArea _getPage(int index) {
    switch (index) {
      case 0:
        return SafeArea(child: HomePage());
      case 1:
        return SafeArea(child: IntakesPage());
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
    switch (_selectedIndex) {
      case 0:
        return AppBar(
          title: Text('TransDIY'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {},
            )
          ],
        );
      case 1:
        return AppBar(
          title: Text('Suivi'),
          
        );
      case 2:
        return AppBar(
          title: Text('Pharmacie'),
        );
      default:
        throw UnimplementedError('Unknown index: $_selectedIndex');
    }
  }

  FloatingActionButton? _buildFloatingActionButton() {
    void newItem() {
      Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => NewItemDialog(),
      ));
    }

    return _selectedIndex == 2
        ? FloatingActionButton(
            onPressed: newItem,
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
