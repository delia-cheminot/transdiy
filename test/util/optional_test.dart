import 'package:flutter_test/flutter_test.dart';
import 'package:mona/util/optional.dart';

void main() {

  group('Optional class tests', () {
    late int callCountTrue;
    late int callCountFalse;

    void callbackTrue(dynamic value) {
      callCountTrue++;
    }

    void callbackFalse() {
      callCountFalse++;
    }

    setUp(() {
      callCountTrue = 0;
      callCountFalse = 0;
    });

    group('Optional starts empty', () {
      late Optional optional;

      int number() => 2026;

      setUp(() {
        optional = Optional.empty();
      });

      test("isn't set", () => expect(optional.isSet(), false));

      test("isn't present", () => expect(optional.isPresent(), false));

      test("get is null", () => expect(optional.get(), null));

      test("orElse return else", () => expect(optional.orElse(number()), 2026));

      test("orElseNullable return else", () => expect(optional.orElseNullable(200), 200));

      test("ifSet callback isn't called", () {
        optional.ifSet(callbackTrue);
        expect(callCountTrue, 0);
      });

      test("ifPresent callback isn't called", () {
        optional.ifPresent(callbackTrue);
        expect(callCountTrue, 0);
      });

      test("ifSetOrElse calls else callback", () {
        optional.ifSetOrElse(callbackTrue, callbackFalse);
        expect(callCountTrue, 0);
        expect(callCountFalse, 1);
      });

      test("ifPresentOrElse calls else callback", () {
        optional.ifPresentOrElse(callbackTrue, callbackFalse);
        expect(callCountTrue, 0);
        expect(callCountFalse, 1);
      });

      test("set sets the object", () {
        optional.set(null);
        expect(optional.get(), null);
        expect(optional.isSet(), true);
        expect(optional.isPresent(), false);
      });

      test("set sets the object and if not null is present", () {
        optional.set(20);
        expect(optional.get(), 20);
        expect(optional.isSet(), true);
        expect(optional.isPresent(), true);
      });

      test("unset remove the object", () {
        optional.set(20);
        optional.unset();
        expect(optional.get(), null);
        expect(optional.isSet(), false);
        expect(optional.isPresent(), false);
      });
    });

    group('Optional starts set to null', () {

      late Optional optional;

      setUp(() => optional = Optional.of(null));

      test("is set", () => expect(optional.isSet(), true));

      test("isn't present", () => expect(optional.isPresent(), false));

      test("get is null", () => expect(optional.get(), null));

      test("orElse should return else", () => expect(optional.orElse("banane"), "banane"));

      test("orElseNullable should return null", () => expect(optional.orElseNullable("banane"), null));

      test("function in ifSet should be called", () {
        optional.ifSet(callbackTrue);

        expect(callCountTrue, 1);
      });

      test("function in ifPresent shouldn't be called", () {
        optional.ifPresent(callbackTrue);

        expect(callCountTrue, 0);
      });

      test("ifSetOrElse calls set callback", () {
        optional.ifSetOrElse(callbackTrue, callbackFalse);
        expect(callCountTrue, 1);
        expect(callCountFalse, 0);
      });

      test("ifPresentOrElse calls else callback", () {
        optional.ifPresentOrElse(callbackTrue, callbackFalse);
        expect(callCountTrue, 0);
        expect(callCountFalse, 1);
      });

      test("unset remove the object", () {
        optional.unset();
        expect(optional.get(), null);
        expect(optional.isSet(), false);
        expect(optional.isPresent(), false);
      });
    });


    group('Optional starts set to "bonjour"', () {

      late Optional<String> optional;

      setUp(() => optional = Optional.of("Bonjour"));

      test("is set", () => expect(optional.isSet(), true));

      test("is present", () => expect(optional.isPresent(), true));

      test('get is "Bonjour"', () => expect(optional.get(), "Bonjour"));

      test('orElse return "Bonjour"', () => expect(optional.orElse("Vide"), "Bonjour"));

      test('orElseNullable return "Bonjour"', () => expect(optional.orElseNullable("Vide"), "Bonjour"));

      test("function in ifSet should be called", () {
        optional.ifSet(callbackTrue);

        expect(callCountTrue, 1);
      });

      test("function in ifPresent should be called", () {
        optional.ifPresent(callbackTrue);

        expect(callCountTrue, 1);
      });

      test("ifSetOrElse calls set callback", () {
        optional.ifSetOrElse(callbackTrue, callbackFalse);
        expect(callCountTrue, 1);
        expect(callCountFalse, 0);
      });

      test("ifPresentOrElse calls present callback", () {
        optional.ifPresentOrElse(callbackTrue, callbackFalse);
        expect(callCountTrue, 1);
        expect(callCountFalse, 0);
      });

      test("unset remove the object", () {
        optional.unset();
        expect(optional.get(), null);
        expect(optional.isSet(), false);
        expect(optional.isPresent(), false);
      });

    });
  });
}