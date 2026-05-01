import 'package:mona/data/model/medication_supply.dart';

enum SupplyType {
  medication,
}

abstract class Supply {
  int get id;
  String get name;
  int get quantity;
  SupplyType get type;

  factory Supply.fromMap(Map<String, Object?> map) {
    return MedicationSupply.fromMap(map);
  }

  Map<String, Object?> toMap();
}
