import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:material_color_utilities/dislike/dislike_analyzer.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/scheme/scheme_tonal_spot.dart';
import 'package:mona/theme/color_scheme_from_dynamic_scheme.dart';

class TonalSpotThemeGenerator {
  TonalSpotThemeGenerator._();

  static final Random _random = Random();

  /// Random opaque RGB, corrected with [DislikeAnalyzer] — the seed stored for
  /// [colorSchemesForSourceArgb] (which builds [SchemeTonalSpot] + [ColorScheme]s).
  static int randomSourceArgb([Random? random]) {
    final rng = random ?? _random;
    final r = rng.nextInt(256);
    final g = rng.nextInt(256);
    final b = rng.nextInt(256);
    const opaque = 0xFF000000;
    final argb = opaque | (r << 16) | (g << 8) | b;
    final hct = DislikeAnalyzer.fixIfDisliked(Hct.fromInt(argb));
    return hct.toInt();
  }

  static ({ColorScheme light, ColorScheme dark}) colorSchemesForSourceArgb(
    int sourceArgb,
  ) {
    final hct = Hct.fromInt(sourceArgb);
    final lightM3 = SchemeTonalSpot(
      sourceColorHct: hct,
      isDark: false,
      contrastLevel: 0.0,
    );
    final darkM3 = SchemeTonalSpot(
      sourceColorHct: hct,
      isDark: true,
      contrastLevel: 0.0,
    );
    return (
      light: colorSchemeFromDynamicScheme(lightM3),
      dark: colorSchemeFromDynamicScheme(darkM3),
    );
  }
}
