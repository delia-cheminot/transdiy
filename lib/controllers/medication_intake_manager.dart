// SPDX-FileCopyrightText: 2026 Délia Cheminot <delia@cheminot.net>
// SPDX-FileContributor: Alice Lorido <alice@lori.do>
//
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:decimal/decimal.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import '../data/model/medication_intake.dart';
import '../data/providers/medication_intake_provider.dart';

class MedicationIntakeManager {
  final MedicationIntakeProvider _medicationIntakeProvider;
  final SupplyItemProvider _supplyItemProvider;

  MedicationIntakeManager(
      this._medicationIntakeProvider, this._supplyItemProvider);

  Future<void> takeMedication({
    required Decimal dose,
    required DateTime scheduledDate,
    required DateTime takenDate,
    SupplyItem? supplyItem,
    required MedicationSchedule schedule,
    InjectionSide? side,
    Decimal? deadSpace, //in μL
  }) async {
    await _medicationIntakeProvider.add(MedicationIntake(
      dose: dose,
      scheduledDateTime: scheduledDate,
      takenDateTime: takenDate,
      side: side,
      scheduleId: schedule.id,
      molecule: schedule.molecule,
      administrationRoute: schedule.administrationRoute,
      ester: schedule.ester,
    ));

    if (supplyItem != null) {
      if (deadSpace != null && deadSpace > Decimal.zero) {
        final deadSpaceMl = deadSpace * Decimal.parse('0.001');
        dose += supplyItem.getDose(deadSpaceMl);
      }

      await SupplyItemManager(_supplyItemProvider).useDose(supplyItem, dose);
    }
  }

  InjectionSide getNextSide() {
    final lastIntake = _medicationIntakeProvider.getLastTakenIntake();
    if (lastIntake == null || lastIntake.side == null) {
      return InjectionSide.left;
    }
    return lastIntake.side == InjectionSide.left
        ? InjectionSide.right
        : InjectionSide.left;
  }
}
