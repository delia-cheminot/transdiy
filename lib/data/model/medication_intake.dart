import 'package:decimal/decimal.dart';

enum InjectionSide {
  left,
  right,
}

extension InjectionSideX on InjectionSide {
  String get label {
    switch (this) {
      case InjectionSide.left:
        return 'left';
      case InjectionSide.right:
        return 'right';
    }
  }
}

class MedicationIntake {
  final int id;
  final DateTime scheduledDateTime;
  final DateTime? takenDateTime;
  final Decimal dose;
  final int? scheduleId;
  final InjectionSide? side;
  bool get isTaken => takenDateTime != null;

  MedicationIntake({
    int? id,
    required this.scheduledDateTime,
    required this.dose,
    this.takenDateTime,
    this.scheduleId,
    this.side,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'takenDateTime': takenDateTime?.toIso8601String(),
      'dose': dose.toString(),
      'scheduleId': scheduleId,
      'side': side?.name,
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
      side: map['side'] == null
          ? null
          : InjectionSide.values.byName(map['side'] as String),
    );
  }

  MedicationIntake copy() {
    return MedicationIntake(
      id: id,
      scheduledDateTime: scheduledDateTime,
      takenDateTime: takenDateTime,
      dose: dose,
      scheduleId: scheduleId,
      side: side,
    );
  }

  MedicationIntake copyWith({
    int? id,
    DateTime? scheduledDateTime,
    DateTime? takenDateTime,
    Decimal? dose,
    int? scheduleId,
    InjectionSide? side,
  }) {
    return MedicationIntake(
      id: id ?? this.id,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      takenDateTime: takenDateTime ?? this.takenDateTime,
      dose: dose ?? this.dose,
      scheduleId: scheduleId ?? this.scheduleId,
      side: side ?? this.side,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationIntake &&
          id == other.id &&
          scheduledDateTime == other.scheduledDateTime &&
          takenDateTime == other.takenDateTime &&
          dose == other.dose &&
          scheduleId == other.scheduleId &&
          side == other.side;

  @override
  int get hashCode =>
      Object.hash(dose, id, scheduleId, scheduledDateTime, takenDateTime, side);

  @override
  String toString() {
    return 'MedicationIntake{id: $id dateTime: $scheduledDateTime} taken: $isTaken';
  }
}
