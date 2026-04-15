import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/l10n/app_localizations_en.dart';
import 'package:mona/l10n/helpers/ester_l10n.dart';

void main() {
  group('Ester', () {
    group('fromName', () {
      test('returns correct ester', () {
        // Act
        final ester = Ester.fromName('valerate');

        // Assert
        expect(ester, Ester.valerate);
      });

      test('returns null if name is null', () {
        // Act
        final ester = Ester.fromName(null);

        // Assert
        expect(ester, null);
      });
    });

    group('esterDropdownMenuItems', () {
      test('contains all esters', () {
        // Act
        final items = esterDropdownMenuItems(AppLocalizationsEn());

        // Assert
        expect(items.length, Ester.all.length);
      });

      test('menu items labels match English localization', () {
        // Act
        final items = esterDropdownMenuItems(AppLocalizationsEn());
        final firstLabel = (items.first.child as Text).data;

        // Assert
        expect(firstLabel, 'Enanthate');
      });
    });

    group('equality', () {
      test('two esters with same name are equal', () {
        // Arrange
        const e1 = Ester.enanthate;
        const e2 = Ester(name: 'enanthate');

        // Act
        final equals = e1 == e2;

        // Assert
        expect(equals, true);
      });

      test('two esters with different names are not equal', () {
        // Arrange
        const e1 = Ester.enanthate;
        const e2 = Ester.valerate;

        // Act
        final equals = e1 == e2;

        // Assert
        expect(equals, false);
      });

      test('hashCode is equal for identical esters', () {
        // Arrange
        const e1 = Ester.enanthate;
        const e2 = Ester(name: 'enanthate');

        // Act
        final hash1 = e1.hashCode;
        final hash2 = e2.hashCode;

        // Assert
        expect(hash1, hash2);
      });

      test('hashCode is different for different esters', () {
        // Arrange
        const e1 = Ester.enanthate;
        const e2 = Ester.valerate;

        // Act
        final hashEquals = e1.hashCode == e2.hashCode;

        // Assert
        expect(hashEquals, false);
      });
    });
  });
}
