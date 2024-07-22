//   _______
//  |_     _|.----.---.-.-----.-----.
//    |   |  |   _|  _  |     |__ --|
//    |___|  |__| |___._|__|__|_____|
//
//        _____ _______ ___ ___
//       |     \_     _|   |   |
//       |  --  ||   |_ \     /
//       |_____/_______| |___|
//
// Special Thanks to:
// - The Flutter Fairies for their enchanting SDK
// - The Dart Wizards for their spellbinding language
// - You, for being awesome and checking out the code! :3
//
// Developed by Délia Cheminot
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/providers/app_state.dart';
import 'package:transdiy/providers/supplies_state.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Make navigation bar transparent and draw behind it.
   SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => SuppliesState()),
      ],
      child: const TransDiyApp(),
    ),
  );
}

//  /|、 meow
//（ﾟ､ ｡ ７
//  l  ~ヽ
//  じしf_,)ノ
