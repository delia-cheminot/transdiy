import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/l10n/app_localizations.dart';

String localizedMolecule(
  Molecule molecule,
  Ester? ester,
  AppLocalizations localizations,
) {
  if (ester == null) {
    return molecule.localizedName(localizations);
  }
  final compound = _localizedCompound(molecule, ester, localizations);
  return compound ??
      '${molecule.localizedName(localizations)} '
          '${ester.localizedName(localizations)}';
}

String? _localizedCompound(
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
