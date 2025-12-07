import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/ui/views/supplies/edit_item_dialog.dart';

class PharmacyItem extends StatelessWidget {
  final SupplyItem item;
  PharmacyItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
        trailing: SvgPicture.asset(_getVialAsset(item.getRatio())),
        title: Text(item.name),
        subtitle: Text(
            'Contenance: ${item.totalDose.toString()} (${(item.getRemainingDose()).toString()} restant)'),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => EditItemDialog(item: item),
          ));
        },
      ),
    ]);
  }

  String _getVialAsset(double ratio) {
    if (ratio == 0.0) return 'assets/pharmacie/fioles/fiole_vide.svg';
    if (ratio == 1.0) return 'assets/pharmacie/fioles/fiole_1.svg';

    final thresholds = <double, String>{
      0.25: '025',
      0.30: '03',
      0.40: '04',
      0.50: '05',
      0.60: '06',
      0.75: '075',
      0.80: '08',
      0.90: '09', 
    };

    for (final entry in thresholds.entries) {
      if (ratio < entry.key) {
        return 'assets/pharmacie/fioles/fiole_${entry.value}.svg';
      }
    }

    return 'assets/pharmacie/fioles/fiole_vide.svg';
  }
}
