import 'package:decimal/decimal.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:mona/util/validators.dart';

class BloodTest {
  final int id;
  final DateTime dateTime;
  final Decimal? estradiolLevels;
  final Decimal? testosteroneLevels;

  BloodTest({
    int? id,
    required this.dateTime,
    this.estradiolLevels,
    this.testosteroneLevels,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  factory BloodTest.fromMap(Map<String, Object?> map) {
    return BloodTest(
      id: map['id'] as int?,
      dateTime: (map['dateTime'] as String).toDateTime.toLocal(),
      estradiolLevels: (map['estradiolLevels'] as String?).toDecimalOrNull,
      testosteroneLevels:
          (map['testosteroneLevels'] as String?).toDecimalOrNull,
    );
  }

  BloodTest copyWith({
    int? id,
    DateTime? dateTime,
    Decimal? estradiolLevels,
    Decimal? testosteroneLevels,
  }) {
    return BloodTest(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      estradiolLevels: estradiolLevels ?? this.estradiolLevels,
      testosteroneLevels: testosteroneLevels ?? this.testosteroneLevels,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toUtc().toIso8601String(),
      'estradiolLevels': estradiolLevels.toString(),
      'testosteroneLevels': testosteroneLevels.toString(),
    };
  }

  // coverage:ignore-start
  static String? validateDate(DateTime? value) => requiredDate(value);

  static String? validateLevel(String? value) => strictlyPositiveDecimal(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BloodTest && (id == other.id);

  @override
  int get hashCode => id.hashCode;
  // coverage:ignore-end
}
