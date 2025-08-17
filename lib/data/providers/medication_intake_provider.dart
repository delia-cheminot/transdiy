import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import '../model/medication_intake.dart';
import '../repositories/medication_intake_repository.dart';

class MedicationIntakeProvider extends ChangeNotifier {
  List<MedicationIntake> _intakes = [];
  bool _isLoading = true;

  List<MedicationIntake> get intakes => _intakes;
  List<MedicationIntake> get takenIntakes =>
      _intakes.where((intake) => intake.isTaken).toList();
  List<MedicationIntake> get notTakenIntakes =>
      _intakes.where((intake) => !intake.isTaken).toList();
  bool get isLoading => _isLoading;

  MedicationIntakeProvider() {
    _init();
  }

  Future<void> _init() async {
    _intakes = await MedicationIntakeRepository.getIntakes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchIntakes() async {
    _intakes = await MedicationIntakeRepository.getIntakes();
    notifyListeners();
  }

  Future<void> deleteIntakeFromId(int id) async {
    await MedicationIntakeRepository.deleteIntakeFromId(id);
    fetchIntakes();
  }

  Future<void> deleteIntake(MedicationIntake intake) async {
    await MedicationIntakeRepository.deleteIntake(intake);
    fetchIntakes();
  }

  Future<void> addIntake(DateTime scheduledDateTime, Decimal dose) async {
    await MedicationIntakeRepository.insertIntake(MedicationIntake(
        scheduledDateTime: scheduledDateTime, dose: dose));
    fetchIntakes();
  }

  Future<void> updateIntake(MedicationIntake intake) async {
    await MedicationIntakeRepository.updateIntake(intake);
    fetchIntakes();
  }
}
