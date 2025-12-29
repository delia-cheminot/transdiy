import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:flutter/material.dart';
import 'ui/views/main_page.dart';

class TransDiyApp extends StatelessWidget {
  const TransDiyApp({super.key});

  ColorScheme _getLightColorScheme(ColorScheme? lightDynamic) {
    return lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.deepPurple);
  }

  ColorScheme _getDarkColorScheme(ColorScheme? darkDynamic) {
    return darkDynamic ??
        ColorScheme.fromSeed(
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

        return MaterialApp(
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
          home: MainPage(),
        );
      },
    );
  }
}
