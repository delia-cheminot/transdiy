class Ester {
  final String name;

  const Ester({
    required this.name,
  });

  static const enanthate = Ester(name: "enanthate");
  static const valerate = Ester(name: "valerate");
  static const cypionate = Ester(name: "cypionate");
  static const undecylate = Ester(name: "undecylate");
  static const benzoate = Ester(name: "benzoate");
  static const cypionateSuspension = Ester(name: "cypionate suspension");

  static const List<Ester> all = [
    enanthate,
    valerate,
    cypionate,
    undecylate,
    benzoate,
    cypionateSuspension,
  ];

  static Ester? fromName(String? name) {
    if (name == null) return null;
    return all.firstWhere((ester) => ester.name == name);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Ester && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
