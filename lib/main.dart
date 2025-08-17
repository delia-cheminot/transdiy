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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/providers/medication_intake_state.dart';
import 'package:transdiy/data/providers/medication_schedule_state.dart';
import 'package:transdiy/data/providers/supply_item_state.dart';
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
        ChangeNotifierProvider(create: (_) => SupplyItemState()),
        ChangeNotifierProvider(create: (_) => MedicationIntakeState()),
        ChangeNotifierProvider(create: (_) => MedicationScheduleState()),
      ],
      child: const TransDiyApp(),
    ),
  );
}

//  /|、 meow
//（ﾟ､ ｡ ７
//  l  ~ヽ
//  じしf_,)ノ
