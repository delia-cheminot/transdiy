import 'package:mockito/annotations.dart';
import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/providers/medication_intake_provider.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import 'package:transdiy/services/generic_repository.dart';

@GenerateMocks([SupplyItemProvider])
@GenerateMocks([MedicationIntakeProvider])
@GenerateMocks([SupplyItemManager])
@GenerateMocks([GenericRepository<MedicationIntake>])
void main() {}
