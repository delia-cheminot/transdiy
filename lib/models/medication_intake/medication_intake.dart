class MedicationIntake {
  final int? id;
  DateTime scheduledDateTime;
  DateTime? takenDateTime;
  double dose;
  bool get isTaken => takenDateTime != null;

  MedicationIntake({
    this.id,
    required this.scheduledDateTime,
    required this.dose,
    this.takenDateTime,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'takenDateTime': takenDateTime?.toIso8601String(),
      'dose': dose,
    };
  }

  factory MedicationIntake.fromMap(Map<String, Object?> map) {
    return MedicationIntake(
      id: map['id'] as int?,
      scheduledDateTime: DateTime.parse(map['scheduledDateTime'] as String),
      takenDateTime: map['takenDateTime'] == null
          ? null
          : DateTime.parse(map['takenDateTime'] as String),
      dose: map['dose'] as double,
    );
  }

  MedicationIntake copy() {
    return MedicationIntake(
      id: id,
      scheduledDateTime: scheduledDateTime,
      takenDateTime: takenDateTime,
      dose: dose,
    );
  }

  @override
  String toString() {
    return 'MedicationIntake{id: $id dateTime: $scheduledDateTime} taken: $isTaken';
  }

  static double roundDose(double dose) {
    // Rounds the dose to the closest integer.
    return dose.roundToDouble();
  }
}