import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:transdiy/data/model/medication_schedule.dart';
import 'package:transdiy/services/repository.dart';

class MedicationScheduleProvider extends ChangeNotifier {
  List<MedicationSchedule> _schedules = [];
  bool _isLoading = true;
  final Repository<MedicationSchedule> repository;

  static final defaultRepository = Repository<MedicationSchedule>(
    tableName: 'medication_schedules',
    toMap: (MedicationSchedule schedule) => schedule.toMap(),
    fromMap: (Map<String, Object?> map) => MedicationSchedule.fromMap(map),
  );

  List<MedicationSchedule> get schedules => _schedules;
  bool get isLoading => _isLoading;

  MedicationSchedule? getScheduleById(int id) {
    try {
      return _schedules.firstWhere((schedule) => schedule.id == id);
    } catch (e) {
      return null;
    }
  }

  MedicationScheduleProvider({Repository<MedicationSchedule>? repository})
      : repository = repository ?? defaultRepository {
    _init();
  }

  Future<void> _init() async {
    _schedules = await repository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSchedules() async {
    _schedules = await repository.getAll();
    notifyListeners();
  }

  Future<void> deleteScheduleFromId(int id) async {
    await repository.delete(id);
    await fetchSchedules();
  }

  Future<void> deleteSchedule(MedicationSchedule schedule) async {
    await repository.delete(schedule.id);
    await fetchSchedules();
  }

  Future<void> addSchedule(String name, Decimal dose, int intervalDays,
      {DateTime? startDate}) async {
    await repository.insert(MedicationSchedule(
      name: name,
      dose: dose,
      intervalDays: intervalDays,
      startDate: startDate ?? DateTime.now(),
    ));
    await fetchSchedules();
  }

  Future<void> updateSchedule(MedicationSchedule schedule) async {
    await repository.update(schedule, schedule.id);
    await fetchSchedules();
  }
}
