import 'package:flutter/material.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/helpers/molecule_l10n.dart';

List<DropdownMenuItem<Molecule>> moleculeDropdownMenuItems(
  List<Molecule> molecules,
  AppLocalizations localizations,
) =>
    molecules
        .map(
          (molecule) => DropdownMenuItem<Molecule>(
            value: molecule,
            child: Text(molecule.localizedName(localizations)),
          ),
        )
        .toList();
