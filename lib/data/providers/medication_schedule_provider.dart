import 'package:flutter/material.dart';
import '../model/medication_schedule.dart';
import '../repositories/medication_schedule_repository.dart';

class MedicationScheduleProvider extends ChangeNotifier {
  List<MedicationSchedule> _schedules = [];
  bool _isLoading = true;

  List<MedicationSchedule> get schedules => _schedules;
  bool get isLoading => _isLoading;

  MedicationScheduleProvider() {
    _init();
  }

  Future<void> _init() async {
    _schedules = await MedicationScheduleRepository.getSchedules();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSchedules() async {
    _schedules = await MedicationScheduleRepository.getSchedules();
    notifyListeners();
  }

  Future<void> deleteScheduleFromId(int id) async {
    await MedicationScheduleRepository.deleteScheduleFromId(id);
    fetchSchedules();
  }

  Future<void> deleteSchedule(MedicationSchedule schedule) async {
    await MedicationScheduleRepository.deleteSchedule(schedule);
    fetchSchedules();
  }

  Future<void> addSchedule(String name, double dose, int intervalDays) async {
    await MedicationScheduleRepository.insertSchedule(
        MedicationSchedule(name: name, dose: dose, intervalDays: intervalDays));
    // No need for id as it is auto-generated and retrieved on fetch
    fetchSchedules();
  }

  Future<void> updateSchedule(MedicationSchedule schedule) async {
    await MedicationScheduleRepository.updateSchedule(schedule);
    fetchSchedules();
  }
}
