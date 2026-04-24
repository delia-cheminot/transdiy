import 'dart:math' show Random;

import 'package:material_color_utilities/dislike/dislike_analyzer.dart';
import 'package:material_color_utilities/hct/hct.dart';

class TonalSpotThemeGenerator {
  TonalSpotThemeGenerator._();

  static final Random _random = Random();

  /// Random opaque RGB, corrected with [DislikeAnalyzer] — value to store as
  /// [CustomThemeSettings.seedArgb].
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
}
