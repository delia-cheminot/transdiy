import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/services/repository.dart';

class MedicationIntakeProvider extends ChangeNotifier {
  List<MedicationIntake> _intakes = [];
  bool _isLoading = true;
  final Repository<MedicationIntake> repository;

  static final defaultRepository = Repository<MedicationIntake>(
    tableName: 'medication_intakes',
    toMap: (MedicationIntake intake) => intake.toMap(),
    fromMap: (Map<String, Object?> map) => MedicationIntake.fromMap(map),
  );

  List<MedicationIntake> get intakes => _intakes;
  List<MedicationIntake> get takenIntakes =>
      _intakes.where((intake) => intake.isTaken).toList();
  List<MedicationIntake> get notTakenIntakes =>
      _intakes.where((intake) => !intake.isTaken).toList();
  bool get isLoading => _isLoading;

  MedicationIntakeProvider({Repository<MedicationIntake>? repository})
      : repository = repository ?? defaultRepository {
    _init();
  }

  Future<void> _init() async {
    _intakes = await repository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchIntakes() async {
    _intakes = await repository.getAll();
    notifyListeners();
  }

  Future<void> deleteIntakeFromId(int id) async {
    await repository.delete(id);
    await fetchIntakes();
  }

  Future<void> deleteIntake(MedicationIntake intake) async {
    assert(intake.id != null);
    await repository.delete(intake.id!);
    await fetchIntakes();
  }

  Future<void> addIntake(DateTime scheduledDateTime, Decimal dose) async {
    await repository.insert(
        MedicationIntake(scheduledDateTime: scheduledDateTime, dose: dose));
    await fetchIntakes();
  }

  Future<void> updateIntake(MedicationIntake intake) async {
    assert(intake.id != null);
    await repository.update(intake, intake.id!);
    await fetchIntakes();
  }
}
