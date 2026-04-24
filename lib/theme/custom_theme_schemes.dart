import 'package:flutter/material.dart';

import 'custom_theme_settings.dart';

/// Builds light/dark [ColorScheme]s from [CustomThemeSettings] using
/// [ColorScheme.fromSeed] (Flutter’s M3 pipeline).
class CustomThemeSchemes {
  CustomThemeSchemes._();

  static ({ColorScheme light, ColorScheme dark}) buildColorSchemes({
    required int seedArgb,
    required DynamicSchemeVariant variant,
    required double contrastLevel,
  }) {
    final color = Color(seedArgb);
    return (
      light: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.light,
        dynamicSchemeVariant: variant,
        contrastLevel: contrastLevel,
      ),
      dark: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.dark,
        dynamicSchemeVariant: variant,
        contrastLevel: contrastLevel,
      ),
    );
  }

  static ({ColorScheme light, ColorScheme dark}) fromSettings(
    CustomThemeSettings settings,
  ) {
    return buildColorSchemes(
      seedArgb: settings.seedArgb,
      variant: settings.variant,
      contrastLevel: settings.contrastLevel,
    );
  }
}
