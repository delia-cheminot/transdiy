import 'package:mona/l10n/app_localizations.dart';

class Molecule {
  final String name;
  final String unit;

  const Molecule({
    required this.name,
    required this.unit,
  });

  factory Molecule.fromJson(Map<String, dynamic> json) {
    return Molecule(
      name: json['name'],
      unit: json['unit'],
    );
  }

  String get normalizedName => name.trim().toLowerCase();

  Map<String, dynamic> toJson() => {
        'name': name,
        'unit': unit,
      };

  String localizedName(AppLocalizations localizations) =>
      _MoleculeLocalization.localize(this, localizations);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Molecule &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class KnownMolecules {
  // Estrogens
  static const estradiol = Molecule(name: 'estradiol', unit: 'mg');

  // Progestogens
  static const progesterone = Molecule(name: 'progesterone', unit: 'mg');

  // Androgens
  static const testosterone = Molecule(name: 'testosterone', unit: 'mg');
  static const nandrolone = Molecule(name: 'nandrolone', unit: 'mg');

  // Anti-androgens
  static const spironolactone = Molecule(name: 'spironolactone', unit: 'mg');
  static const cyproteroneAcetate =
      Molecule(name: 'cyproterone acetate', unit: 'mg');
  static const leuprorelinAcetate =
      Molecule(name: 'leuprorelin acetate', unit: 'mg');
  static const bicalutamide = Molecule(name: 'bicalutamide', unit: 'mg');
  static const decapeptyl = Molecule(name: 'decapeptyl', unit: 'mg');

  // SERMs
  static const raloxifene = Molecule(name: 'Raloxifene', unit: 'mg');
  static const tamoxifen = Molecule(name: 'Tamoxifen', unit: 'mg');

  // Other
  static const finasteride = Molecule(name: 'finasteride', unit: 'mg');
  static const dutasteride = Molecule(name: 'dutasteride', unit: 'mg');
  static const minoxidil = Molecule(name: 'minoxidil', unit: 'mg');
  static const pioglitazone = Molecule(name: 'pioglitazone', unit: 'mg');

  static const all = [
    estradiol,
    progesterone,
    testosterone,
    nandrolone,
    spironolactone,
    cyproteroneAcetate,
    leuprorelinAcetate,
    bicalutamide,
    decapeptyl,
    raloxifene,
    tamoxifen,
    finasteride,
    dutasteride,
    minoxidil,
    pioglitazone,
  ];
}

abstract final class _MoleculeLocalization {
  static final _strategies = {
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

  static String localize(Molecule molecule, AppLocalizations l10n) {
    final strategy = _strategies[molecule.normalizedName];
    if (strategy != null) return strategy(l10n);
    final n = molecule.name;
    return n[0].toUpperCase() + n.substring(1);
  }
}
