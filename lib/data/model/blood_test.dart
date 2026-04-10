import 'package:decimal/decimal.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:mona/util/timezone_location.dart';
import 'package:mona/util/validators.dart';
import 'package:timezone/timezone.dart' as tz;

class BloodTest {
  final int id;
  final DateTime dateTime;
  final String timeZone;
  final Decimal? estradiolLevels;
  final Decimal? testosteroneLevels;

  BloodTest({
    int? id,
    required this.dateTime,
    required this.timeZone,
    this.estradiolLevels,
    this.testosteroneLevels,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch {
    if (!dateTime.isUtc) {
      throw ArgumentError('dateTime must be UTC');
    }
  }

  factory BloodTest.fromMap(Map<String, Object?> map) {
    return BloodTest(
      id: map['id'] as int?,
      dateTime: (map['dateTime'] as String).toDateTime,
      timeZone: map['timeZone'] as String,
      estradiolLevels: (map['estradiolLevels'] as String?).toDecimalOrNull,
      testosteroneLevels:
          (map['testosteroneLevels'] as String?).toDecimalOrNull,
    );
  }

  DateTime get localDateTime {
    final location = timeZoneLocation(timeZone);
    return tz.TZDateTime.from(dateTime, location);
  }

  Date get localDate => Date.fromDateTime(localDateTime);

  BloodTest copyWith({
    int? id,
    DateTime? dateTime,
    String? timeZone,
    Decimal? estradiolLevels,
    Decimal? testosteroneLevels,
  }) {
    return BloodTest(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      timeZone: timeZone ?? this.timeZone,
      estradiolLevels: estradiolLevels ?? this.estradiolLevels,
      testosteroneLevels: testosteroneLevels ?? this.testosteroneLevels,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'timeZone': timeZone,
      'estradiolLevels': estradiolLevels?.toString(),
      'testosteroneLevels': testosteroneLevels?.toString(),
    };
  }

  // coverage:ignore-start
  static String? validateDate(DateTime? value) => requiredDateTime(value);

  static String? validateLevel(String? value) => positiveDecimal(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BloodTest && (id == other.id);

  @override
  int get hashCode => id.hashCode;
  // coverage:ignore-end
}
