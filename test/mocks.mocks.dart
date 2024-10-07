// Mocks generated by Mockito 5.4.4 from annotations
// in transdiy/test/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:ui' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:transdiy/medication_intake/medication_intake.dart' as _i7;
import 'package:transdiy/medication_intake/medication_intake_state.dart' as _i6;
import 'package:transdiy/supply_item/supply_item.dart' as _i2;
import 'package:transdiy/supply_item/supply_item_manager.dart' as _i8;
import 'package:transdiy/supply_item/supply_item_state.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSupplyItem_0 extends _i1.SmartFake implements _i2.SupplyItem {
  _FakeSupplyItem_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SupplyItemState].
///
/// See the documentation for Mockito's code generation for more information.
class MockSupplyItemState extends _i1.Mock implements _i3.SupplyItemState {
  MockSupplyItemState() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i2.SupplyItem> get items => (super.noSuchMethod(
        Invocation.getter(#items),
        returnValue: <_i2.SupplyItem>[],
      ) as List<_i2.SupplyItem>);

  @override
  bool get isLoading => (super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: false,
      ) as bool);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i4.Future<void> fetchItems() => (super.noSuchMethod(
        Invocation.method(
          #fetchItems,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteItemFromId(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteItemFromId,
          [id],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteItem(_i2.SupplyItem? item) => (super.noSuchMethod(
        Invocation.method(
          #deleteItem,
          [item],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> addItem(
    double? totalAmount,
    String? name,
    double? dosagePerUnit,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addItem,
          [
            totalAmount,
            name,
            dosagePerUnit,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateItem(_i2.SupplyItem? item) => (super.noSuchMethod(
        Invocation.method(
          #updateItem,
          [item],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void addListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [MedicationIntakeState].
///
/// See the documentation for Mockito's code generation for more information.
class MockMedicationIntakeState extends _i1.Mock
    implements _i6.MedicationIntakeState {
  MockMedicationIntakeState() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i7.MedicationIntake> get intakes => (super.noSuchMethod(
        Invocation.getter(#intakes),
        returnValue: <_i7.MedicationIntake>[],
      ) as List<_i7.MedicationIntake>);

  @override
  bool get isLoading => (super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: false,
      ) as bool);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i4.Future<void> fetchIntakes() => (super.noSuchMethod(
        Invocation.method(
          #fetchIntakes,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteIntakeFromId(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteIntakeFromId,
          [id],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteIntake(_i7.MedicationIntake? intake) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteIntake,
          [intake],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> addIntake(
    DateTime? scheduledDateTime,
    double? dose,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addIntake,
          [
            scheduledDateTime,
            dose,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateIntake(_i7.MedicationIntake? intake) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateIntake,
          [intake],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void addListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [SupplyItemManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockSupplyItemManager extends _i1.Mock implements _i8.SupplyItemManager {
  MockSupplyItemManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.SupplyItem> setFields(
    _i2.SupplyItem? item, {
    String? newName,
    double? newTotalAmount,
    double? newUsedAmount,
    double? newDosagePerUnit,
    int? newQuantity,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #setFields,
          [item],
          {
            #newName: newName,
            #newTotalAmount: newTotalAmount,
            #newUsedAmount: newUsedAmount,
            #newDosagePerUnit: newDosagePerUnit,
            #newQuantity: newQuantity,
          },
        ),
        returnValue: _i4.Future<_i2.SupplyItem>.value(_FakeSupplyItem_0(
          this,
          Invocation.method(
            #setFields,
            [item],
            {
              #newName: newName,
              #newTotalAmount: newTotalAmount,
              #newUsedAmount: newUsedAmount,
              #newDosagePerUnit: newDosagePerUnit,
              #newQuantity: newQuantity,
            },
          ),
        )),
      ) as _i4.Future<_i2.SupplyItem>);

  @override
  _i4.Future<void> useAmount(
    _i2.SupplyItem? item,
    double? amountToUse,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #useAmount,
          [
            item,
            amountToUse,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
