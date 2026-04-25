import 'dart:math' show Random;
import 'package:flutter/material.dart';

import 'package:material_color_utilities/dislike/dislike_analyzer.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'custom_theme_settings.dart';

/// Builds light/dark [ColorScheme]s from [CustomThemeSettings] using
/// [ColorScheme.fromSeed] (Flutter’s M3 pipeline).
class CustomThemeSchemes {
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

  static int randomSourceArgb([Random? random]) {
    final rng = random ?? Random();
    final r = rng.nextInt(256);
    final g = rng.nextInt(256);
    final b = rng.nextInt(256);
    const opaque = 0xFF000000;
    final argb = opaque | (r << 16) | (g << 8) | b;
    final hct = DislikeAnalyzer.fixIfDisliked(Hct.fromInt(argb));
    return hct.toInt();
  }
}
