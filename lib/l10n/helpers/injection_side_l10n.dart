import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/l10n/app_localizations.dart';

extension InjectionSideL10n on InjectionSide {
  String localizedName(AppLocalizations localizations) =>
      _InjectionSideDisplayNames.resolve(this, localizations);
}

abstract final class _InjectionSideDisplayNames {
  static final Map<String, String Function(AppLocalizations)> _labelsByName = {
    InjectionSide.left.name: (l) => l.injectionSideLeft,
    InjectionSide.right.name: (l) => l.injectionSideRight,
  };

  static String resolve(
    InjectionSide side,
    AppLocalizations localizations,
  ) {
    final labelBuilder = _labelsByName[side.name];
    if (labelBuilder != null) {
      return labelBuilder(localizations);
    }
    final n = side.name;
    return n[0].toUpperCase() + n.substring(1);
  }
}
