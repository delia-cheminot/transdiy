import 'package:decimal/decimal.dart';

class MedicationIntake {
  final int? id;
  DateTime scheduledDateTime;
  DateTime? takenDateTime;
  Decimal dose;
  final int? scheduleId;
  bool get isTaken => takenDateTime != null;

  MedicationIntake({
    this.id,
    required this.scheduledDateTime,
    required this.dose,
    this.takenDateTime,
    this.scheduleId,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'takenDateTime': takenDateTime?.toIso8601String(),
      'dose': dose.toString(),
      'scheduleId': scheduleId,
    };
  }

  factory MedicationIntake.fromMap(Map<String, Object?> map) {
    return MedicationIntake(
      id: map['id'] as int?,
      scheduledDateTime: DateTime.parse(map['scheduledDateTime'] as String),
      takenDateTime: map['takenDateTime'] == null
          ? null
          : DateTime.parse(map['takenDateTime'] as String),
      dose: Decimal.parse(map['dose'] as String),
      scheduleId: map['scheduleId'] as int?,
    );
  }

  MedicationIntake copy() {
    return MedicationIntake(
      id: id,
      scheduledDateTime: scheduledDateTime,
      takenDateTime: takenDateTime,
      dose: dose,
      scheduleId: scheduleId,
    );
  }

  @override
  String toString() {
    return 'MedicationIntake{id: $id dateTime: $scheduledDateTime} taken: $isTaken';
  }
}
