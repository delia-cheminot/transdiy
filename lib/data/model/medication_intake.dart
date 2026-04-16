import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:mona/util/timezone_location.dart';
import 'package:mona/util/validators.dart';
import 'package:timezone/timezone.dart' as tz;

enum InjectionSide {
  left,
  right,
}

class MedicationIntake {
  final int id;
  final DateTime scheduledDateTime;
  final DateTime? takenDateTime;
  final String? takenTimeZone;
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
    this.takenTimeZone,
    this.scheduleId,
    this.side,
    required this.molecule,
    required this.administrationRoute,
    this.ester,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch {
    if (takenDateTime != null && !takenDateTime!.isUtc) {
      throw ArgumentError('takenDateTime must be UTC');
    }
    if (takenDateTime != null && takenTimeZone == null) {
      throw ArgumentError('takenTimeZone must be provided');
    }
  }

  factory MedicationIntake.fromMap(Map<String, Object?> map) {
    return MedicationIntake(
      id: map['id'] as int?,
      scheduledDateTime: (map['scheduledDateTime'] as String).toDateTime,
      takenDateTime: (map['takenDateTime'] as String?).toDateTimeOrNull,
      takenTimeZone: map['takenTimeZone'] as String?,
      dose: (map['dose'] as String).toDecimal,
      scheduleId: map['scheduleId'] as int?,
      side: map['side'] == null
          ? null
          : InjectionSide.values.byName(map['side'] as String),
      molecule: Molecule.fromJson(jsonDecode(map['moleculeJson'] as String)),
      administrationRoute: AdministrationRoute.fromName(
          map['administrationRouteName'] as String),
      ester: Ester.fromName(map['esterName'] as String?),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'takenDateTime': takenDateTime?.toIso8601String(),
      'takenTimeZone': takenTimeZone,
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
    String? takenTimeZone,
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
      takenTimeZone: takenTimeZone ?? this.takenTimeZone,
      dose: dose ?? this.dose,
      scheduleId: scheduleId ?? this.scheduleId,
      side: side ?? this.side,
      molecule: molecule ?? this.molecule,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      ester: ester ?? this.ester,
    );
  }

  DateTime? get takenLocalDateTime {
    if (takenDateTime == null) return null;

    final location = timeZoneLocation(takenTimeZone!);
    return tz.TZDateTime.from(takenDateTime!, location);
  }

  Date? get takenLocalDate {
    return takenLocalDateTime != null
        ? Date.fromDateTime(takenLocalDateTime!)
        : null;
  }

  // coverage:ignore-start
  static String? validateDose(String? value) =>
      requiredStrictlyPositiveDecimal(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MedicationIntake && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "$dose mg • ${molecule.name} "
        "${ester != null ? '${ester!.name} ' : ""}"
        "${administrationRoute.name}"
        "${side?.name != null ? ' • ${side!.name} side' : ''}";
  }
  // coverage:ignore-end
}
