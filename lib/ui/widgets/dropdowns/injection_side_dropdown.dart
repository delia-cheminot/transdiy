import 'package:flutter/material.dart';
import 'package:mona/data/model/medication_intake.dart';

String _injectionSideMenuLabel(InjectionSide side) =>
    side.name[0].toUpperCase() + side.name.substring(1);

List<DropdownMenuItem<InjectionSide>> get injectionSideDropdownMenuItems =>
    InjectionSide.values
        .map(
          (side) => DropdownMenuItem<InjectionSide>(
            value: side,
            child: Text(_injectionSideMenuLabel(side)),
          ),
        )
        .toList();
