import 'package:flutter/material.dart';
import '../../../../core/data/vegetable_data.dart';
import '../widgets/vegetable_card.dart';
import '../widgets/vegetable_details_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.lang,
    super.key,
  });

  final String lang;

  void _showVegetablePopup(BuildContext context, vegetable) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext _) {
        return VegetableDetailsBottomSheet(
          vegetable: vegetable,
          lang: lang,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      children: VegetableData.vegetables.map<Widget>((vegetable) {
        return VegetableCard(
          vegetable: vegetable,
          lang: lang,
          onTap: () => _showVegetablePopup(context, vegetable),
        );
      }).toList(),
    );
  }
}
