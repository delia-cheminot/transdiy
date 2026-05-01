import 'package:mona/data/model/supply.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/util/validators.dart';

class GenericSupply implements Supply {
  @override
  final int id;
  @override
  final String name;
  @override
  final int quantity;
  final int amount;
  @override
  final SupplyType type = SupplyType.generic;

  GenericSupply({
    int? id,
    required this.name,
    this.quantity = 1,
    required this.amount,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  factory GenericSupply.fromMap(Map<String, Object?> map) {
    return GenericSupply(
      id: map['id'] as int?,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      amount: map['amount'] as int,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'amount': amount,
      'type': type.name,
    };
  }

  GenericSupply copyWith({
    int? id,
    String? name,
    int? quantity,
    int? amount,
  }) {
    return GenericSupply(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
    );
  }

  static String? validateAmount(AppLocalizations l10n, String? value) =>
      requiredPositiveInt(l10n, value);

  static String? validateName(AppLocalizations l10n, String? value) =>
      requiredString(l10n, value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GenericSupply && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GenericSupply(id: $id, name: $name, amount: $amount, quantity: $quantity)';
  }
}
