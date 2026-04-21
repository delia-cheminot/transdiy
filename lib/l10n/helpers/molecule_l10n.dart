import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/helpers/ester_l10n.dart';

extension MoleculeL10n on Molecule {
  String localizedName(AppLocalizations localizations) =>
      _KnownMoleculeDisplayNames.resolve(this, localizations);

  String localizedNameWithEster(
    Ester? ester,
    AppLocalizations localizations,
  ) {
    if (ester == null) {
      return localizedName(localizations);
    }
    final compound = _compoundMedicationDisplayName(this, ester, localizations);
    return compound ??
        '${localizedName(localizations)} ${ester.localizedName(localizations)}';
  }
}

String? _compoundMedicationDisplayName(
  Molecule molecule,
  Ester ester,
  AppLocalizations localizations,
) {
  if (molecule == KnownMolecules.estradiol) {
    switch (ester.name) {
      case 'enanthate':
        return localizations.medicationEstradiolEnanthate;
      case 'valerate':
        return localizations.medicationEstradiolValerate;
      case 'cypionate':
        return localizations.medicationEstradiolCypionate;
      case 'undecylate':
        return localizations.medicationEstradiolUndecylate;
      case 'benzoate':
        return localizations.medicationEstradiolBenzoate;
      case 'cypionate suspension':
        return localizations.medicationEstradiolCypionateSuspension;
      default:
        return null;
    }
  }

  if (molecule == KnownMolecules.testosterone) {
    switch (ester.name) {
      case 'enanthate':
        return localizations.medicationTestosteroneEnanthate;
      case 'valerate':
        return localizations.medicationTestosteroneValerate;
      case 'cypionate':
        return localizations.medicationTestosteroneCypionate;
      case 'undecylate':
        return localizations.medicationTestosteroneUndecylate;
      case 'benzoate':
        return localizations.medicationTestosteroneBenzoate;
      case 'cypionate suspension':
        return localizations.medicationTestosteroneCypionateSuspension;
      default:
        return null;
    }
  }

  return null;
}

abstract final class _KnownMoleculeDisplayNames {
  static final Map<String, String Function(AppLocalizations)>
      _labelsByNormalizedName = {
    KnownMolecules.estradiol.normalizedName: (l) => l.estradiol,
    KnownMolecules.progesterone.normalizedName: (l) => l.progesterone,
    KnownMolecules.testosterone.normalizedName: (l) => l.testosterone,
    KnownMolecules.nandrolone.normalizedName: (l) => l.nandrolone,
    KnownMolecules.spironolactone.normalizedName: (l) => l.spironolactone,
    KnownMolecules.cyproteroneAcetate.normalizedName: (l) =>
        l.cyproteroneAcetate,
    KnownMolecules.leuprorelinAcetate.normalizedName: (l) =>
        l.leuprorelinAcetate,
    KnownMolecules.bicalutamide.normalizedName: (l) => l.bicalutamide,
    KnownMolecules.decapeptyl.normalizedName: (l) => l.decapeptyl,
    KnownMolecules.raloxifene.normalizedName: (l) => l.raloxifene,
    KnownMolecules.tamoxifen.normalizedName: (l) => l.tamoxifen,
    KnownMolecules.finasteride.normalizedName: (l) => l.finasteride,
    KnownMolecules.dutasteride.normalizedName: (l) => l.dutasteride,
    KnownMolecules.minoxidil.normalizedName: (l) => l.minoxidil,
    KnownMolecules.pioglitazone.normalizedName: (l) => l.pioglitazone,
  };

  static String resolve(Molecule molecule, AppLocalizations localizations) {
    final labelBuilder = _labelsByNormalizedName[molecule.normalizedName];
    if (labelBuilder != null) {
      return labelBuilder(localizations);
    }
    final n = molecule.name;
    return n[0].toUpperCase() + n.substring(1);
  }
}
