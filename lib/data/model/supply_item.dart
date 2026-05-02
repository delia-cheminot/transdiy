import 'package:mona/data/model/generic_supply_item.dart';
import 'package:mona/data/model/medication_supply_item.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/util/validators.dart';

enum SupplyType {
  medication,
  generic,
}

abstract class SupplyItem {
  int get id;
  String get name;
  int get quantity;

  factory SupplyItem.fromMap(Map<String, Object?> map) {
    final SupplyType type = SupplyType.values.byName(map['type'] as String);

    switch (type) {
      case SupplyType.medication:
        return MedicationSupplyItem.fromMap(map);
      case SupplyType.generic:
        return GenericSupply.fromMap(map);
    }
  }

  Map<String, Object?> toMap();

  // coverage:ignore-start
  static String? validateName(AppLocalizations l10n, String? value) =>
      requiredString(l10n, value);
  // coverage:ignore-end
}
