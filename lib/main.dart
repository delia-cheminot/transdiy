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
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // make navigation bar transparent and draw behind it
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const TransDiyApp());
}

//  /|、 meow
//（ﾟ､ ｡ ７
//  l  ~ヽ
//  じしf_,)ノ
