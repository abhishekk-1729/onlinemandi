import 'package:flutter/material.dart';
import '../../../../core/models/vegetable.dart';

class VegetableCard extends StatelessWidget {
  const VegetableCard({
    required this.vegetable,
    required this.lang,
    required this.onTap,
    super.key,
  });

  final Vegetable vegetable;
  final String lang;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const <BoxShadow>[
            BoxShadow(blurRadius: 10, color: Colors.black12),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(vegetable.emoji, style: const TextStyle(fontSize: 50)),
            Text(
              lang == 'en' ? vegetable.nameEn : vegetable.nameHi,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "₹${vegetable.marketPrice}",
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.red,
              ),
            ),
            Text(
              "₹${vegetable.ourPrice}/kg",
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

