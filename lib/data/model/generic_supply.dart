import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/model/supply_type.dart';
import 'package:mona/util/validators.dart';

class GenericSupply implements SupplyItem {
  final int id;
  final String name;
  final int quantity;

  GenericSupply({
    int? id,
    required this.name,
    required this.quantity
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  factory GenericSupply.fromMap(Map<String, Object?> map) {
    return GenericSupply(
      id: map['id'] as int?,
      name: map['name'] as String,
      quantity: map['quantity'] as int
    );
  }

  bool get isInStock => quantity > 0;

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'type': getType().name,
    };
  }

  GenericSupply copyWith({
    int? id,
    String? name,
    int? quantity
  }) {
    return GenericSupply(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity
    );
  }

  static String? validateRemainingQuantity(String? value) => requiredPositiveInt(value);

  static String? validateName(String? value) => requiredString(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GenericSupply && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "$name $quantity";
  }

  @override
  SupplyType getType() {
    return SupplyType.generic;
  }

  @override
  int getId() {
    return id;
  }
}