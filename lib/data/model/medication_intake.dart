import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/molecule.dart';

enum InjectionSide {
  left,
  right,
}

class MedicationIntake {
  final int id;
  final DateTime scheduledDateTime;
  final DateTime? takenDateTime;
  final Decimal dose;
  final int? scheduleId;
  final InjectionSide? side;
  bool get isTaken => takenDateTime != null;
  final Molecule molecule;
  final AdministrationRoute administrationRoute;
  final Ester? ester;

  MedicationIntake({
    int? id,
    required this.scheduledDateTime,
    required this.dose,
    this.takenDateTime,
    this.scheduleId,
    this.side,
    required this.molecule,
    required this.administrationRoute,
    this.ester,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

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
      molecule: Molecule.fromJson(jsonDecode(map['moleculeJson'] as String)),
      administrationRoute: AdministrationRoute.fromName(
          map['administrationRouteName'] as String),
      ester: map['esterName'] != null
          ? Ester.values.byName(map['esterName'] as String)
          : null,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'takenDateTime': takenDateTime?.toIso8601String(),
      'dose': dose.toString(),
      'scheduleId': scheduleId,
      'side': side?.name,
      'moleculeJson': jsonEncode(molecule.toJson()),
      'administrationRouteName': administrationRoute.name,
      'esterName': ester?.name,
    };
  }

  MedicationIntake copyWith({
    int? id,
    DateTime? scheduledDateTime,
    DateTime? takenDateTime,
    Decimal? dose,
    int? scheduleId,
    InjectionSide? side,
    Molecule? molecule,
    AdministrationRoute? administrationRoute,
    Ester? ester,
  }) {
    return MedicationIntake(
      id: id ?? this.id,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      takenDateTime: takenDateTime ?? this.takenDateTime,
      dose: dose ?? this.dose,
      scheduleId: scheduleId ?? this.scheduleId,
      side: side ?? this.side,
      molecule: molecule ?? this.molecule,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      ester: ester ?? this.ester,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MedicationIntake && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MedicationIntake{id: $id dateTime: $scheduledDateTime} taken: $isTaken';
  }
}
