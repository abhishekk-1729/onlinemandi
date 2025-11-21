import 'package:flutter/material.dart';
import '../models/models.dart';

/// Manages the state of the shopping cart and past orders using ChangeNotifier.
class CartModel extends ChangeNotifier {
  final List<CartItem> _items = <CartItem>[];
  final List<Order> _pastOrders = <Order>[];

  List<CartItem> get items => List<CartItem>.unmodifiable(_items);
  List<Order> get pastOrders => List<Order>.unmodifiable(_pastOrders);

  int get totalItems =>
      _items.fold<int>(0, (int sum, CartItem item) => sum + item.quantity);

  double get totalPrice => _items.fold<double>(
    0.0,
    (double sum, CartItem item) => sum + item.totalPrice,
  );

  void addItem(Vegetable vegetable, int quantity) {
    final int index = _items.indexWhere(
      (CartItem item) => item.vegetable == vegetable,
    );
    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(vegetable: vegetable, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(Vegetable vegetable) {
    _items.removeWhere((CartItem item) => item.vegetable == vegetable);
    notifyListeners();
  }

  void updateItemQuantity(Vegetable vegetable, int newQuantity) {
    final int index = _items.indexWhere(
      (CartItem item) => item.vegetable == vegetable,
    );
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void placeOrder() {
    if (_items.isNotEmpty) {
      // Create a deep copy of current cart items for the order
      final List<CartItem> orderItems = _items
          .map<CartItem>(
            (CartItem item) =>
                CartItem(vegetable: item.vegetable, quantity: item.quantity),
          )
          .toList();

      final double orderTotalPrice = totalPrice;

      _pastOrders.insert(
        0, // Insert at the beginning to show most recent order first
        Order(
          items: orderItems,
          orderDate: DateTime.now(),
          totalOrderPrice: orderTotalPrice,
        ),
      );

      _items.clear(); // Clear the cart after placing the order
      notifyListeners();
    }
  }
}

