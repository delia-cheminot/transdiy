import 'package:flutter/material.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/helpers/ester_l10n.dart';

List<DropdownMenuItem<Ester>> esterDropdownMenuItems(
  AppLocalizations localizations,
) =>
    Ester.all
        .map(
          (ester) => DropdownMenuItem<Ester>(
            value: ester,
            child: Text(ester.localizedName(localizations)),
          ),
        )
        .toList();
