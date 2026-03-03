enum Ester {
  enanthate,
  valerate,
  cypionate,
  undecylate,
}

extension EsterX on Ester {
  String get label {
    switch (this) {
      case Ester.enanthate:
        return 'enanthate';
      case Ester.valerate:
        return 'valerate';
      case Ester.cypionate:
        return 'cypionate';
      case Ester.undecylate:
        return 'undecylate';
    }
  }
}

class Molecule {
  final String name;
  final String unit;

  const Molecule({
    required this.name,
    required this.unit,
  });

  String get normalizedName => name.trim().toLowerCase();

  Map<String, dynamic> toJson() => {
        'name': name,
        'unit': unit,
      };

  factory Molecule.fromJson(Map<String, dynamic> json) {
    return Molecule(
      name: json['name'],
      unit: json['unit'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Molecule &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          unit == other.unit;

  @override
  int get hashCode => name.hashCode ^ unit.hashCode;
}

class KnownMolecules {
  static const estradiol = Molecule(name: 'estradiol', unit: 'mg');
  static const testosterone = Molecule(name: 'testosterone', unit: 'mg');
  static const progesterone = Molecule(name: 'progesterone', unit: 'mg');

  static const all = [
    estradiol,
    testosterone,
    progesterone,
  ];
}
