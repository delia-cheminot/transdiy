import 'package:mockito/annotations.dart';
import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/providers/medication_intake_provider.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';

@GenerateMocks([SupplyItemProvider])
@GenerateMocks([MedicationIntakeProvider])
@GenerateMocks([MedicationScheduleProvider])
@GenerateMocks([SupplyItemManager])
void main() {}
