import 'vegetable.dart';

/// Represents an item within the shopping cart or an order.
class CartItem {
  final Vegetable vegetable;
  int quantity;

  CartItem({required this.vegetable, this.quantity = 1});

  double get totalPrice => quantity * vegetable.ourPrice.toDouble();
}

