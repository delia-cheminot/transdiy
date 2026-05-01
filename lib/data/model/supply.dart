import 'package:mona/data/model/generic_supply.dart';
import 'package:mona/data/model/medication_supply.dart';

enum SupplyType {
  medication,
  generic,
}

abstract class Supply {
  int get id;
  String get name;
  int get quantity;
  SupplyType get type;

  factory Supply.fromMap(Map<String, Object?> map) {
    final SupplyType type = SupplyType.values.byName(map['type'] as String);

    switch (type) {
      case SupplyType.medication:
        return MedicationSupply.fromMap(map);
      case SupplyType.generic:
        return GenericSupply.fromMap(map);
    }
  }

  Map<String, Object?> toMap();
}
