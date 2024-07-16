import 'package:flutter/material.dart';
import 'generator_page.dart';
import 'favorites_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('Unknown index: $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TransDIY'),
      ),
      body: Container(
        child: page,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedIndex: selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            // accueil : prises à venir & niveau d'œstrogène
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            // suivi : prises futures et passées, ajout manuel, régime habituel
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Suivi',
          ),
          NavigationDestination(
            // pharmacie : liste des médicaments, expiration, ajout de médicaments
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Pharmacie',
          ),
        ],
      ),
    );
  }
}
