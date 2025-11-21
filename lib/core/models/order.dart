import 'cart_item.dart';

/// Represents a completed order.
class Order {
  final List<CartItem> items;
  final DateTime orderDate;
  final double totalOrderPrice;

  Order({
    required this.items,
    required this.orderDate,
    required this.totalOrderPrice,
  });
}

