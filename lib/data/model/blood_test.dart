import 'package:decimal/decimal.dart';
import 'package:mona/util/validators.dart';

class BloodTest {
  final int id;
  DateTime date;
  Decimal? estradiolLevels;
  Decimal? testosteroneLevels;

  BloodTest({
    int? id,
    required this.date,
    this.estradiolLevels,
    this.testosteroneLevels,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  factory BloodTest.fromMap(Map<String, Object?> map) {
    return BloodTest(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      estradiolLevels: map['estradiolLevels'] as Decimal?,
      testosteroneLevels: map['testosteroneLevels'] as Decimal?,
    );
  }
  BloodTest copyWith({
    int? id,
    DateTime? date,
    Decimal? estradiolLevels,
    Decimal? testosteroneLevels,
  }) {
    return BloodTest(
      id: id ?? this.id,
      date: date ?? this.date,
      estradiolLevels: estradiolLevels ?? this.estradiolLevels,
      testosteroneLevels: testosteroneLevels ?? this.testosteroneLevels,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'oestradiolLevels': estradiolLevels,
      'testosteroneLevels': testosteroneLevels,
    };
  }

  static String? validateDate(DateTime? value) => requiredDate(value);

  static String? validateDose(String? value) =>
      requiredStrictlyPositiveDecimal(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BloodTest &&
          (date == other.date) &&
          (estradiolLevels == other.estradiolLevels) &&
          (testosteroneLevels == other.testosteroneLevels);

  @override
  int get hashCode => id.hashCode;
}
