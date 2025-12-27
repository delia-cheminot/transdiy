import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/ui/views/supplies/edit_item_page.dart';

class SupplyItemCard extends StatelessWidget {
  final SupplyItem item;

  const SupplyItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => EditItemPage(item: item),
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: SvgPicture.asset(
                      _getVialAsset(item.getRatio()),
                      fit: BoxFit.contain,
                      width: 72,
                      height: 72,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // text with description
                  Text(
                    'Contenance: ${item.totalDose.toString()}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '(${(item.getRemainingDose()).toString()} restants)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getVialAsset(double ratio) {
    final thresholds = <double, String>{
      0.10: '00',
      0.20: '02',
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

    return 'assets/pharmacie/fioles/fiole_1.svg';
  }
}
