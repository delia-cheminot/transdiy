import 'package:decimal/decimal.dart';

class MedicationSchedule {
  final int id;
  String name;
  Decimal dose;
  int intervalDays;
  DateTime lastTaken;

  MedicationSchedule({
    int? id,
    required this.name,
    required this.dose,
    required this.intervalDays,
    DateTime? lastTaken,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch,
       lastTaken = lastTaken ?? DateTime.now();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose.toString(),
      'intervalDays': intervalDays,
      'lastTaken': lastTaken.toIso8601String(),
    };
  }

  factory MedicationSchedule.fromMap(Map<String, Object?> map) {
    return MedicationSchedule(
      id: map['id'] as int?,
      name: map['name'] as String,
      dose: Decimal.parse(map['dose'] as String),
      intervalDays: map['intervalDays'] as int,
      lastTaken: DateTime.parse(map['lastTaken'] as String),
    );
  }

  MedicationSchedule copy() {
    return MedicationSchedule(
      id: id,
      name: name,
      dose: dose,
      intervalDays: intervalDays,
      lastTaken: lastTaken,
    );
  }

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
