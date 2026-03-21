import 'package:mona/data/model/generic_supply.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/model/supply_type.dart';

abstract class SupplyItem {

  factory SupplyItem.fromMap(Map<String, Object?> map) {
    SupplyType type = SupplyType.fromName(map['type'] as String);

    switch (type) {
      case SupplyType.medication:
        return MedicationSupply.fromMap(map);
      case SupplyType.generic:
        return GenericSupply.fromMap(map);
    }
  }

  Map<String, Object?> toMap();
  SupplyType getType();
  int getId();
}