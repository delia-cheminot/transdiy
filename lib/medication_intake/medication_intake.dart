class MedicationIntake {
  final int? id;
  DateTime scheduledDateTime;
  DateTime? takenDateTime;
  bool get isTaken => takenDateTime != null;

  MedicationIntake({
    this.id,
    required this.scheduledDateTime,
    this.takenDateTime,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'takenDateTime': takenDateTime?.toIso8601String(),};
  }

  factory MedicationIntake.fromMap(Map<String, Object?> map) {
    return MedicationIntake(
      id: map['id'] as int?,
      scheduledDateTime: DateTime.parse(map['scheduledDateTime'] as String),
      takenDateTime: map['takenDateTime'] == null
          ? null
          : DateTime.parse(map['takenDateTime'] as String),
    );
  }

  MedicationIntake copy() {
    return MedicationIntake(
      id: id,
      scheduledDateTime: scheduledDateTime,
      takenDateTime: takenDateTime,
    );
  }

  @override
  String toString() {
    return 'MedicationIntake{id: $id dateTime: $scheduledDateTime} taken: $isTaken';
  }
}