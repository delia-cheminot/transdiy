// SPDX-FileCopyrightText: 2026 Délia Cheminot <delia@cheminot.net>
//
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/ester.dart';

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

    group('menuItems', () {
      test('contains all esters', () {
        // Act
        final items = Ester.menuItems;

        // Assert
        expect(items.length, Ester.all.length);
      });

      test('menu items have capitalized labels', () {
        // Act
        final items = Ester.menuItems;
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
