import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'home_page.dart';

class TransDiyApp extends StatelessWidget {
  const TransDiyApp({super.key});

  ColorScheme _getLightColorScheme(ColorScheme? lightDynamic) {
    return lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.deepPurple);
  }

  ColorScheme _getDarkColorScheme(ColorScheme? darkDynamic) {
    return darkDynamic ?? ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final lightColorScheme = _getLightColorScheme(lightDynamic);
        final darkColorScheme = _getDarkColorScheme(darkDynamic);

        return ChangeNotifierProvider(
          create: (context) => AppState(),
          child: MaterialApp(
            title: 'TransDIY',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
            ),
            themeMode: ThemeMode.system,
            home: HomePage(),
          ),
        );
      },
    );
  }
}
