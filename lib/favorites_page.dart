import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('no favorites :('),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('your favorites :3 (you have ${appState.favorites.length})'),
        ),
        ...appState.favorites.map((pair) =>
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asCamelCase),
          )
        ),
      ],
    );
  }
}
