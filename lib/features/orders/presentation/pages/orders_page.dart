import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_model.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({
    required this.lang,
    super.key,
  });

  final String lang;

  @override
  Widget build(BuildContext context) {
    final CartModel cart = context.watch<CartModel>();

    if (cart.pastOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.list_alt, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              lang == 'en' ? "No past orders." : "कोई पिछला ऑर्डर नहीं।",
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cart.pastOrders.length,
      itemBuilder: (BuildContext context, int orderIndex) {
        final order = cart.pastOrders[orderIndex];
        final DateTime orderDate = order.orderDate;
        final String formattedDate =
            '${orderDate.day.toString().padLeft(2, '0')}/${orderDate.month.toString().padLeft(2, '0')}/${orderDate.year} '
            '${orderDate.hour.toString().padLeft(2, '0')}:${orderDate.minute.toString().padLeft(2, '0')}';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              lang == 'en'
                  ? "Order on $formattedDate"
                  : "ऑर्डर $formattedDate को",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              lang == 'en'
                  ? "Total: ₹${order.totalOrderPrice.toStringAsFixed(2)} (${order.items.length} items)"
                  : "कुल: ₹${order.totalOrderPrice.toStringAsFixed(2)} (${order.items.length} आइटम)",
              style: const TextStyle(color: Colors.green),
            ),
            children: order.items.map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      item.vegetable.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lang == 'en'
                            ? "${item.vegetable.nameEn} x ${item.quantity}kg"
                            : "${item.vegetable.nameHi} x ${item.quantity}किग्रा",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      "₹${item.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

