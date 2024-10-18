import 'package:transdiy/utils/math_helper.dart';

class MedicationSchedule {
  final int? id;
  String name;
  double dose;
  int intervalDays;

  MedicationSchedule({
    this.id,
    required this.name,
    required this.dose,
    required this.intervalDays,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'intervalDays': intervalDays,
    };
  }

  factory MedicationSchedule.fromMap(Map<String, Object?> map) {
    return MedicationSchedule(
      id: map['id'] as int?,
      name: map['name'] as String,
      dose: map['dose'] as double,
      intervalDays: map['intervalDays'] as int,
    );
  }

  MedicationSchedule copy() {
    return MedicationSchedule(
      id: id,
      name: name,
      dose: dose,
      intervalDays: intervalDays,
    );
  }

  @override
  String toString() {
    return 'MedicationSchedule{id: $id name: $name}';
  }

  bool isValid() {
    return dose > 0 && intervalDays > 0 && name.isNotEmpty;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Champ obligatoire';
    }
    return null;
  }

  static String? validateDose(String? dose) {
    if (dose == null || dose.isEmpty) {
      return 'Champ obligatoire';
    }
    final parsedDose = MathHelper.parseDouble(dose);
    if (parsedDose == null || parsedDose <= 0) {
      return 'Doit être un nombre positif';
    }
    return null;
  }

  static String? validateIntervalDays(String? intervalDays) {
    if (intervalDays == null || intervalDays.isEmpty) {
      return 'Champ obligatoire';
    }
    final parsedIntervalDays = int.tryParse(intervalDays);
    if (parsedIntervalDays == null || parsedIntervalDays <= 0) {
      return 'Doit être un nombre positif';
    }
    return null;
  }
}
