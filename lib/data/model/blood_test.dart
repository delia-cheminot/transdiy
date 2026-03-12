import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:mona/util/validators.dart';

class BloodTest {
    final int id;
    DateTime date;
    Double? oestradiolLevels;
    Double? testosteroneLevels; 
    
    
    BloodTest({
        int? id,
        required this.date,
        this.oestradiolLevels,
        this.testosteroneLevels,
    }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

    factory BloodTest.fromMap(Map<String, Object?> map) {
      return BloodTest(
        id: map['id'] as int?,
        date: DateTime.parse(map['date'] as String),
        oestradiolLevels: map['oestradiolLevels'] as Double?,
        testosteroneLevels: map['testosteroneLevels'] as Double?,
        );
    }

    Map<String, Object?> toMap() {
      return {
        'id': id,
        'date': date.toIso8601String(),
        'oestradiolLevels': oestradiolLevels,
        'testosteroneLevels': testosteroneLevels,
      };
    }

    static String? validateDate(DateTime? value) =>
      requiredDate(value);


    @override
    bool operator ==(Object other) =>
    identical(this, other) || other is BloodTest && (date == other.date) && (oestradiolLevels == other.oestradiolLevels) && (testosteroneLevels == other.testosteroneLevels);

    @override
    int get hashCode => id.hashCode;

}