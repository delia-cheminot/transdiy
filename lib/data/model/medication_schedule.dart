import 'package:decimal/decimal.dart';
import 'package:transdiy/data/model/medication_intake.dart';

DateTime _normalizeDate(DateTime date) {
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
        startDate = _normalizeDate(startDate ?? DateTime.now());

  factory MedicationSchedule.fromMap(Map<String, Object?> map) {
    return MedicationSchedule(
      id: map['id'] as int?,
      name: map['name'] as String,
      dose: Decimal.parse(map['dose'] as String),
      intervalDays: map['intervalDays'] as int,
      startDate: DateTime.parse(map['startDate'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose.toString(),
      'intervalDays': intervalDays,
      'startDate': startDate.toIso8601String(),
    };
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

  static String? validateStartDate(DateTime? startDate) =>
      startDate == null ? 'Champ obligatoire' : null;

  /// Returns the next scheduled injection date relative to [referenceDate] (or today if null).
  ///
  /// - If the [startDate] is in the future or today, returns [startDate].
  /// - If today falls exactly on a scheduled injection date, returns today.
  /// - Otherwise, returns the next scheduled date after today.
  DateTime getNextDate({DateTime? referenceDate}) {
    final today = _normalizeDate(referenceDate ?? DateTime.now());

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

  /// Returns the last scheduled injection date relative to [referenceDate] (or today if null).
  ///
  /// - If the [startDate] is in the future or today, returns null.
  /// - If today falls exactly on a scheduled injection date, returns the scheduled date before today.
  /// - Otherwise, returns the last scheduled date before today.
  DateTime? getLastDate({DateTime? referenceDate}) {
    final today = _normalizeDate(referenceDate ?? DateTime.now());

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

  MedicationIntake getIntakeForDate(DateTime date) {
    return MedicationIntake(
      scheduledDateTime: date,
      dose: dose,
      scheduleId: id,
    );
  }

  String generateUid() {
    return '$name-$dose-$intervalDays-${DateTime.now().toIso8601String()}';
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

  //     |------------------------|
  //     |  TODO refactor getters |
  //     |------------------------|
  //        ||
  // (\__/) ||
  // (•ㅅ•) ||
  // / 　 づ
}
