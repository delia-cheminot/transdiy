import 'package:mona/data/model/ester.dart';
import 'package:mona/l10n/app_localizations.dart';

extension EsterL10n on Ester {
  String localizedName(AppLocalizations localizations) =>
      _EsterDisplayNames.resolve(this, localizations);
}

abstract final class _EsterDisplayNames {
  static final Map<String, String Function(AppLocalizations)> _labelsByName = {
    Ester.enanthate.name: (l) => l.enanthate,
    Ester.valerate.name: (l) => l.valerate,
    Ester.cypionate.name: (l) => l.cypionate,
    Ester.undecylate.name: (l) => l.undecylate,
    Ester.benzoate.name: (l) => l.benzoate,
    Ester.cypionateSuspension.name: (l) => l.cypionateSuspension,
  };

  static String resolve(Ester ester, AppLocalizations localizations) {
    final labelBuilder = _labelsByName[ester.name];
    if (labelBuilder != null) {
      return labelBuilder(localizations);
    }
    final n = ester.name;
    return n[0].toUpperCase() + n.substring(1);
  }
}
