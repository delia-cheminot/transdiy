import 'package:decimal/decimal.dart';

class MedicationSchedule {
  final int id;
  final String name;
  final Decimal dose;
  final int intervalDays;
  final DateTime lastGenerated;

  MedicationSchedule({
    int? id,
    required this.name,
    required this.dose,
    required this.intervalDays,
    DateTime? lastGenerated,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        lastGenerated = lastGenerated ?? DateTime.now();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose.toString(),
      'intervalDays': intervalDays,
      'lastGenerated': lastGenerated.toIso8601String(),
    };
  }

  factory MedicationSchedule.fromMap(Map<String, Object?> map) {
    return MedicationSchedule(
      id: map['id'] as int?,
      name: map['name'] as String,
      dose: Decimal.parse(map['dose'] as String),
      intervalDays: map['intervalDays'] as int,
      lastGenerated: DateTime.parse(map['lastGenerated'] as String),
    );
  }

  MedicationSchedule copy() {
    return MedicationSchedule(
      id: id,
      name: name,
      dose: dose,
      intervalDays: intervalDays,
      lastGenerated: lastGenerated,
    );
  }

  MedicationSchedule copyWith({
    int? id,
    String? name,
    Decimal? dose,
    int? intervalDays,
    DateTime? lastGenerated,
  }) {
    return MedicationSchedule(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      intervalDays: intervalDays ?? this.intervalDays,
      lastGenerated: lastGenerated ?? this.lastGenerated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationSchedule &&
          id == other.id &&
          name == other.name &&
          dose == other.dose &&
          intervalDays == other.intervalDays &&
          lastGenerated == other.lastGenerated;

  @override
  int get hashCode => Object.hash(id, name, dose, intervalDays, lastGenerated);

  @override
  String toString() {
    return 'MedicationSchedule{id: $id name: $name}';
  }

  String generateUid() {
    return '$name-$dose-$intervalDays-$DateTime.now()';
  }

  bool isValid() {
    return dose > Decimal.zero && intervalDays > 0 && name.isNotEmpty;
  }

  static String? validateName(String? name) {
    return name == null || name.isEmpty ? 'Champ obligatoire' : null;
  }

  static String? validateDose(String? dose) {
    if (dose == null || dose.isEmpty) {
      return 'Champ obligatoire';
    }
    final parsedDose = Decimal.tryParse(dose);
    return parsedDose == null || parsedDose <= Decimal.zero
        ? 'Doit être un nombre positif'
        : null;
  }

  static String? validateIntervalDays(String? intervalDays) {
    if (intervalDays == null || intervalDays.isEmpty) {
      return 'Champ obligatoire';
    }
    final parsedIntervalDays = int.tryParse(intervalDays);
    return (parsedIntervalDays == null || parsedIntervalDays <= 0)
        ? 'Doit être un nombre positif'
        : null;
  }

  //     |------------------------|
  //     |  TODO refactor parsers |
  //     |------------------------|
  //        ||
  // (\__/) ||
  // (•ㅅ•) ||
  // / 　 づ
}
