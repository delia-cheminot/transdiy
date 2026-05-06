import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:mona/util/timezone_location.dart';
import 'package:mona/util/validators.dart';
import 'package:timezone/timezone.dart' as tz;

part 'medication_intake.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum InjectionSide {
  left,
  right,
}

@MappableClass(
  includeCustomMappers: [
    MoleculeJsonMapper(),
    AdministrationRouteNameMapper(),
    EsterNameMapper(),
    DecimalStringMapper(),
  ],
  generateMethods: GenerateMethods.all,
)
class MedicationIntake with MedicationIntakeMappable {
  final int id;
  final DateTime scheduledDateTime;
  final DateTime? takenDateTime;
  final String? takenTimeZone;
  final Decimal dose;
  final int? scheduleId;
  final InjectionSide? side;
  bool get isTaken => takenDateTime != null;
  @MappableField(
      key: 'moleculeJson') // TODO rename fields in db to match mapper
  final Molecule molecule;
  @MappableField(key: 'administrationRouteName')
  final AdministrationRoute administrationRoute;
  @MappableField(key: 'esterName')
  final Ester? ester;
  final int? supplyItemId;
  final String? notes;

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
    this.supplyItemId,
    this.notes,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch {
    if (takenDateTime != null && !takenDateTime!.isUtc) {
      throw ArgumentError('takenDateTime must be UTC');
    }
    if (takenDateTime != null && takenTimeZone == null) {
      throw ArgumentError('takenTimeZone must be provided');
    }
  }

  DateTime? get takenLocalDateTime {
    if (takenDateTime == null) return null;

    final location = timeZoneLocation(takenTimeZone!);
    return tz.TZDateTime.from(takenDateTime!, location);
  }

  Date? get takenLocalDate {
    return takenLocalDateTime?.toDate;
  }

  // coverage:ignore-start
  static String? validateDose(AppLocalizations l10n, String? value) =>
      requiredStrictlyPositiveDecimal(l10n, value);

  static String? validateDeadSpace(AppLocalizations l10n, String? value) =>
      positiveDecimal(l10n, value);
  // coverage:ignore-end
}

class MoleculeJsonMapper extends SimpleMapper<Molecule> {
  const MoleculeJsonMapper();

  @override
  Molecule decode(Object value) {
    if (value is String) {
      return Molecule.fromJson(
        jsonDecode(value) as Map<String, dynamic>,
      );
    }
    if (value is Map) {
      return Molecule.fromJson(Map<String, dynamic>.from(value));
    }
    throw FormatException(
        'Expected JSON for molecule, got ${value.runtimeType}');
  }

  @override
  Object? encode(Molecule self) {
    return jsonEncode(self.toJson());
  }
}

class AdministrationRouteNameMapper extends SimpleMapper<AdministrationRoute> {
  const AdministrationRouteNameMapper();

  @override
  AdministrationRoute decode(Object value) {
    return AdministrationRoute.fromName(value as String);
  }

  @override
  Object? encode(AdministrationRoute self) {
    return self.name;
  }
}

class EsterNameMapper extends SimpleMapper<Ester> {
  const EsterNameMapper();

  @override
  Ester decode(Object value) {
    return Ester.fromName(value as String)!;
  }

  @override
  Object? encode(Ester self) {
    return self.name;
  }
}

class DecimalStringMapper extends SimpleMapper<Decimal> {
  const DecimalStringMapper();

  @override
  Decimal decode(Object value) {
    return (value as String).toDecimal;
  }

  @override
  Object? encode(Decimal self) {
    return self.toString();
  }
}
