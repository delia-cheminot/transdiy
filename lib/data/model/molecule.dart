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

  // Anti-androgens
  static const spironolactone = Molecule(name: 'spironolactone', unit: 'mg');
  static const cyproteroneAcetate =
      Molecule(name: 'cyproterone acetate', unit: 'mg');
  static const bicalutamide = Molecule(name: 'bicalutamide', unit: 'mg');
  static const decapeptyl = Molecule(name: 'decapeptyl', unit: 'mg');

  // Other
  static const finasteride = Molecule(name: 'finasteride', unit: 'mg');
  static const dutasteride = Molecule(name: 'dutasteride', unit: 'mg');
  static const minoxidil = Molecule(name: 'minoxidil', unit: 'mg');

  static const all = [
    estradiol,
    progesterone,
    testosterone,
    spironolactone,
    cyproteroneAcetate,
    bicalutamide,
    decapeptyl,
    finasteride,
    dutasteride,
    minoxidil,
  ];
}
