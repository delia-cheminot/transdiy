import 'package:mockito/annotations.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';

@GenerateMocks([SupplyItemProvider])
@GenerateMocks([MedicationIntakeProvider])
@GenerateMocks([MedicationScheduleProvider])
@GenerateMocks([SupplyItemManager])
void main() {}
