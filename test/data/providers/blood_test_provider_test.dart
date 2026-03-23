import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/blood_test.dart';
import 'package:mona/data/providers/blood_test_provider.dart';
import 'generic_repository_mock.dart';

void main() {
  late BloodTestProvider provider;
  late GenericRepositoryMock<BloodTest> repo;

  setUp(() {
    repo = GenericRepositoryMock<BloodTest>(
      withId: (i, id) => BloodTest(
        id: id,
        date: i.date,
        estradiolLevels: i.estradiolLevels,
        testosteroneLevels: i.testosteroneLevels,
      ),
    );
  });

  group('BloodTestProvider Tests', () {
    test('initialization loads bloodtests', () async {
      // Arrange
      await repo.insert(BloodTest(
        id: 1,
        date: DateTime(2025, 3, 14, 6, 7),
        estradiolLevels: Decimal.parse('167.1'),
        testosteroneLevels: Decimal.parse('1.67'),
      ));

      // Act
      provider = BloodTestProvider(repository: repo);
      await Future.doWhile(() async {
        if (provider.isLoading) {
          await Future.delayed(Duration(milliseconds: 10));
          return true;
        }
        return false;
      });

      // Assert
      expect(provider.bloodtests.length, repo.items.length);
    });

    test('add inserts a new test', () async {
      // Arrange
      final newDate = DateTime(2025, 1, 1, 1, 1);
      final newEstradiolLevels = Decimal.parse('111.1');
      final newTestosteroneLevels = Decimal.parse('1.1');
      provider = BloodTestProvider(repository: repo);

      // Act
      await provider.add(BloodTest(
        date: newDate,
        estradiolLevels: newEstradiolLevels,
        testosteroneLevels: newTestosteroneLevels,
      ));

      // Assert
      expect(
        provider.bloodtests.any((i) =>
            i.date == newDate &&
            i.estradiolLevels == newEstradiolLevels &&
            i.testosteroneLevels == newTestosteroneLevels),
        true,
      );
    });

    test('updateBloodTest updates an existing test', () async {
      // Arrange
      repo.insert(BloodTest(
        id: 1,
        date: DateTime(2025, 3, 14, 6, 7),
        estradiolLevels: Decimal.parse('167.1'),
        testosteroneLevels: Decimal.parse('1.67'),
      ));
      provider = BloodTestProvider(repository: repo);
      final bloodtestToUpdate = repo.items.first;
      final updatedBloodTest = BloodTest(
        id: bloodtestToUpdate.id,
        date: DateTime(2025, 2, 2, 2, 2),
        estradiolLevels: bloodtestToUpdate.estradiolLevels,
        testosteroneLevels: bloodtestToUpdate.testosteroneLevels,
      );

      // Act
      await provider.updateBloodTest(updatedBloodTest);

      // Assert
      final fetchedBloodTests =
          provider.bloodtests.firstWhere((i) => i.id == bloodtestToUpdate.id);
      expect(fetchedBloodTests.date, DateTime(2025, 2, 2, 2, 2));
    });

    test('deleteBloodTestFromId removes the test', () async {
      // Arrange
      repo.insert(BloodTest(
        id: 1,
        date: DateTime(2025, 3, 14, 6, 7),
        estradiolLevels: Decimal.parse('167.1'),
        testosteroneLevels: Decimal.parse('1.67'),
      ));
      provider = BloodTestProvider(repository: repo);

      // Act
      await provider.deleteBloodTestFromId(1);

      // Assert
      expect(provider.bloodtests.length, 0);
    });

    test('deleteBloodTest removes the test by object', () async {
      // Arrange
      final bloodtestToDelete = BloodTest(
        id: 1,
        date: DateTime(2025, 3, 14, 6, 7),
        estradiolLevels: Decimal.parse('167.1'),
        testosteroneLevels: Decimal.parse('1.67'),
      );

      repo.insert(bloodtestToDelete);
      provider = BloodTestProvider(repository: repo);

      // Act
      await provider.deleteBloodTest(bloodtestToDelete);

      // Assert
      expect(provider.bloodtests.length, 0);
    });

    test('bloodtestsSortedDesc returns test sorted descending', () async {
      provider = BloodTestProvider(repository: repo);
      provider.add(BloodTest(
        id: 666,
        date: DateTime(2025, 5, 4, 3, 0),
        estradiolLevels: Decimal.parse('234.5'),
        testosteroneLevels: Decimal.parse('2.34'),
      ));
      provider.add(BloodTest(
        id: 667, // ekip
        date: DateTime(2025, 6, 7, 8, 9),
        estradiolLevels: Decimal.parse('292.9'),
        testosteroneLevels: Decimal.parse('2.43'),
      ));
      provider.add(BloodTest(
        id: 668,
        date: DateTime(2025, 3, 2, 1, 0),
        estradiolLevels: Decimal.parse('261.2'),
        testosteroneLevels: Decimal.parse('3.3'),
      ));

      final sorted = provider.bloodtestsSortedDesc;

      expect(
        sorted.asMap().entries.every((entry) {
          final i = entry.key;
          final bloodtest = entry.value;
          if (i < sorted.length - 1) {
            final next = sorted[i + 1];
            if (bloodtest.date.isBefore(next.date)) {
              return false;
            }
          }
          return true;
        }),
        true,
      );
    });

    group('getDaysAndBloodTests', () {
      test('returns empty map when no bloodtests', () {
        // Arrange
        provider = BloodTestProvider(repository: repo);

        // Act
        final result = provider.getDaysAndBloodTests(DateTime(2025, 5, 4));

        // Assert
        expect(result, {});
      });

      test('includes only bloodtests with estradiolLevels', () async {
        // Arrange
        provider = BloodTestProvider(repository: repo);
        await provider.add(BloodTest(
          id: 666,
          date: DateTime(2025, 5, 4, 3, 0),
          estradiolLevels: Decimal.parse('234.5'),
          testosteroneLevels: Decimal.parse('2.34'),
        ));
        await provider.add(BloodTest(
          id: 667,
          date: DateTime(2025, 5, 5),
          estradiolLevels: null,
          testosteroneLevels: Decimal.parse('5.0'),
        ));

        // Act
        final result = provider.getDaysAndBloodTests(DateTime(2025, 5, 4));

        // Assert
        expect(result, {0: 234.5});
      });

      test('calculates correct days difference and normalizes time', () async {
        // Arrange
        provider = BloodTestProvider(repository: repo);
        await provider.add(BloodTest(
          id: 668,
          date: DateTime(2025, 5, 6, 23, 59),
          estradiolLevels: Decimal.parse('12.3'),
          testosteroneLevels: null,
        ));

        // Act
        final result =
            provider.getDaysAndBloodTests(DateTime(2025, 5, 4, 0, 0));

        // Assert
        expect(result, {2: 12.3});
      });
    });
  });
}
