import 'package:decimal/decimal.dart';

DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

class MedicationSchedule {
  final int id;
  final String name;
  final Decimal dose;
  final int intervalDays;
  final DateTime startDate;

  MedicationSchedule({
    int? id,
    required this.name,
    required this.dose,
    required this.intervalDays,
    DateTime? startDate,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        startDate = normalizeDate(startDate ?? DateTime.now());

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose.toString(),
      'intervalDays': intervalDays,
      'startDate': startDate.toIso8601String(),
    };
  }

  factory MedicationSchedule.fromMap(Map<String, Object?> map) {
    return MedicationSchedule(
      id: map['id'] as int?,
      name: map['name'] as String,
      dose: Decimal.parse(map['dose'] as String),
      intervalDays: map['intervalDays'] as int,
      startDate: DateTime.parse(map['startDate'] as String),
    );
  }

  MedicationSchedule copy() {
    return MedicationSchedule(
      id: id,
      name: name,
      dose: dose,
      intervalDays: intervalDays,
      startDate: startDate,
    );
  }

  MedicationSchedule copyWith({
    int? id,
    String? name,
    Decimal? dose,
    int? intervalDays,
    DateTime? startDate,
  }) {
    return MedicationSchedule(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      intervalDays: intervalDays ?? this.intervalDays,
      startDate: startDate ?? this.startDate,
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
          startDate == other.startDate;

  @override
  int get hashCode => Object.hash(id, name, dose, intervalDays, startDate);

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

  DateTime? getNextDate({DateTime? referenceDate}) {
    final today = normalizeDate(referenceDate ?? DateTime.now());

    if (!startDate.isBefore(today)) {
      return startDate;
    }

    final daysSinceStart = today.difference(startDate).inDays;

    if (daysSinceStart % intervalDays == 0) {
      return today;
    }

    final intervalsPassed = (daysSinceStart / intervalDays).ceil();
    return startDate.add(
      Duration(days: intervalsPassed * intervalDays),
    );
  }

  DateTime? getLastDate({DateTime? referenceDate}) {
    final today = normalizeDate(referenceDate ?? DateTime.now());

    if (!startDate.isBefore(today)) {
      return null;
    }

    final daysSinceStart = today.difference(startDate).inDays;

    if (daysSinceStart % intervalDays == 0) {
      return startDate.add(
        Duration(days: (daysSinceStart - intervalDays)),
      );
    }

    final intervalsPassed = (daysSinceStart / intervalDays).floor();
    return startDate.add(
      Duration(days: intervalsPassed * intervalDays),
    );
  }

  //     |------------------------|
  //     |  TODO refactor getters |
  //     |------------------------|
  //        ||
  // (\__/) ||
  // (•ㅅ•) ||
  // / 　 づ
}
