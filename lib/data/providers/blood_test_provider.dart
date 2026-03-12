import 'package:mona/data/model/blood_test.dart';
import 'package:mona/services/repository.dart';

class BloodTestProvider {
  List<BloodTest> _bloodtests = [];
  bool _isLoading = true;

  final Repository<BloodTest> repository;
  
  BloodTestProvider({Repository<BloodTest>? repository})
      : repository = repository ?? _bloodTestRepository {
    _init();
  }
  bool get isLoading => _isLoading;

  List<BloodTest> get bloodtests => _bloodtests;

  Future<void> _init() async {
    _bloodtests = await repository.getAll();
    _isLoading = false;
  }

  Future<void> fetchBloodTests() async {
    _bloodtests = await repository.getAll();
  }

  static final _bloodTestRepository = Repository<BloodTest>(
    tableName: 'blood_tests',
    toMap: (BloodTest bloodtest) => bloodtest.toMap(),
    fromMap: (Map<String, Object?> map) => BloodTest.fromMap(map),
  );

}