import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_model.dart';
import '../../../../shared/widgets/custom_toast.dart';

/// Widget to display the shopping cart contents.
class CartPage extends StatelessWidget {
  const CartPage({
    required this.lang,
    required this.onProceedToCheckout,
    super.key,
  });

  final String lang;
  final VoidCallback onProceedToCheckout;

  @override
  Widget build(BuildContext context) {
    final CartModel cart = context.watch<CartModel>();

    if (cart.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              lang == 'en' ? "Your cart is empty!" : "आपकी कार्ट खाली है!",
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = cart.items[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      Text(
                        item.vegetable.emoji,
                        style: const TextStyle(fontSize: 30),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              lang == 'en'
                                  ? item.vegetable.nameEn
                                  : item.vegetable.nameHi,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              lang == 'en'
                                  ? "₹${item.vegetable.ourPrice} / kg"
                                  : "₹${item.vegetable.ourPrice} / किग्रा",
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              cart.updateItemQuantity(
                                item.vegetable,
                                item.quantity - 1,
                              );
                            },
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              cart.updateItemQuantity(
                                item.vegetable,
                                item.quantity + 1,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              cart.removeItem(item.vegetable);
                              CustomToast.show(
                                context,
                                message: lang == 'en'
                                    ? "${item.vegetable.nameEn} removed from cart."
                                    : "${item.vegetable.nameHi} कार्ट से हटा दिया गया।",
                                icon: Icons.delete_outline,
                                backgroundColor: Colors.green.shade700,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
                offset: Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    lang == 'en' ? "Total Items:" : "कुल आइटम:",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    '${cart.totalItems}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    lang == 'en' ? "Total Price:" : "कुल कीमत:",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    '₹${cart.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onProceedToCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    lang == 'en'
                        ? "Proceed to Checkout"
                        : "चेकआउट के लिए आगे बढ़ें",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

