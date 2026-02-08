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
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/services/notifications/notification_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService().initialize();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final preferencesService = await PreferencesService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SupplyItemProvider()),
        ChangeNotifierProvider(create: (_) => MedicationIntakeProvider()),
        ChangeNotifierProvider(create: (_) => MedicationScheduleProvider()),
        ChangeNotifierProvider.value(value: preferencesService),
      ],
      child: const MonaApp(),
    ),
  );
}

//  /|、 meow
//（ﾟ､ ｡ ７
//  l  ~ヽ
//  じしf_,)ノ
