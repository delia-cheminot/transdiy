import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/ui/views/supplies/edit_item_dialog.dart';


class PharmacyItem extends StatelessWidget {
  final SupplyItem item;
  PharmacyItem({required this.item});
  
  @override
  Widget build(BuildContext context) {
    final Decimal ratio = item.getRemainingDose() * item.totalDose.inverse.toDecimal(scaleOnInfinitePrecision: 10)  ;
    return Column(
      mainAxisSize: MainAxisSize.min,
        children : [ 
          ListTile(
            trailing: switch (ratio.toDouble()) {
              0.0 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_vide.svg'
              ),
              var r when r > 0.0 && r < 0.25 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_02.svg'
              ),
              var r when r >= 0.25 && r < 0.3 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_025.svg'
              ),
              var r when r >= 0.3 && r < 0.4 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_03.svg'
              ),
              var r when r >= 0.4 && r < 0.5 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_04.svg'
              ),
              var r when r >= 0.5 && r < 0.6 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_05.svg'
              ),
              var r when r >= 0.6 && r < 0.75 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_06.svg'
              ),
              var r when r >= 0.75 && r < 0.8 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_075.svg'
              ),
              var r when r >= 0.8 && r < 0.9 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_08.svg'
              ),
              var r when r >= 0.9 && r < 1.0 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_09.svg', width: 120, height: 120,
              ),
              1.0 => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_1.svg'
              ),
              _ => SvgPicture.asset(
              'assets/pharmacie/fioles/fiole_vide.svg'
              ), 
            }
            ,
            title: Text(item.name),
            subtitle: Text(
              'Contenance: ${item.totalDose.toString()} (${(item.getRemainingDose()).toString()} restant)'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                fullscreenDialog: true,
                builder: (context) => EditItemDialog(item: item),
                )
              );
            },
          ),
        ] 
    );
  }
}
