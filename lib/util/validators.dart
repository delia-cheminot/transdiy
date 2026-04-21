import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/util/string_parsing.dart';

String? strictlyPositiveDecimal(AppLocalizations l10n, String? value) {
  if (value.isEmpty) return null;

  return value.toDecimalOrZero <= Decimal.zero
      ? l10n.mustBePositiveNumber
      : null;
}

String? positiveDecimal(AppLocalizations l10n, String? value) {
  if (value.isEmpty) return null;

  return (!value.isDecimal || value.toDecimalOrZero < Decimal.zero)
      ? l10n.mustBePositiveNumber
      : null;
}

String? positiveInt(AppLocalizations l10n, String? value) {
  if (value.isEmpty) return null;

  return value.toIntOrZero <= 0 ? l10n.mustBePositiveNumber : null;
}

String? requiredString(AppLocalizations l10n, String? value) =>
    value.isEmpty ? l10n.requiredField : null;

String? requiredDateTime(AppLocalizations l10n, DateTime? value) =>
    value == null ? l10n.requiredField : null;

String? requiredDate(AppLocalizations l10n, Date? value) =>
    value == null ? l10n.requiredField : null;

String? requiredStrictlyPositiveDecimal(AppLocalizations l10n, String? value) =>
    requiredString(l10n, value) ?? strictlyPositiveDecimal(l10n, value);

String? requiredPositiveDecimal(AppLocalizations l10n, String? value) =>
    requiredString(l10n, value) ?? positiveDecimal(l10n, value);

String? requiredPositiveInt(AppLocalizations l10n, String? value) =>
    requiredString(l10n, value) ?? positiveInt(l10n, value);

String? requiredMolecule(AppLocalizations l10n, Molecule? value) =>
    value == null ? l10n.requiredField : null;

String? requiredAdministrationRoute(
        AppLocalizations l10n, AdministrationRoute? value) =>
    value == null ? l10n.requiredField : null;
