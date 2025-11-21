import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/vegetable.dart';
import '../../../../core/providers/cart_model.dart';
import '../../../../shared/widgets/custom_toast.dart';

/// Widget for displaying vegetable details and quantity selection in a bottom sheet.
class VegetableDetailsBottomSheet extends StatefulWidget {
  const VegetableDetailsBottomSheet({
    required this.vegetable,
    required this.lang,
    super.key,
  });

  final Vegetable vegetable;
  final String lang;

  @override
  State<VegetableDetailsBottomSheet> createState() =>
      _VegetableDetailsBottomSheetState();
}

class _VegetableDetailsBottomSheetState
    extends State<VegetableDetailsBottomSheet> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final CartModel cart = Provider.of<CartModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(widget.vegetable.emoji, style: const TextStyle(fontSize: 80)),
          Text(
            widget.lang == 'en'
                ? widget.vegetable.nameEn
                : widget.vegetable.nameHi,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            widget.lang == 'en'
                ? "Market Price: ₹${widget.vegetable.marketPrice}"
                : "बाजार मूल्य: ₹${widget.vegetable.marketPrice}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            widget.lang == 'en'
                ? "Our Price: ₹${widget.vegetable.ourPrice}/kg"
                : "हमारा मूल्य: ₹${widget.vegetable.ourPrice}/किग्रा",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.green,
                ),
                onPressed: () {
                  setState(() {
                    if (_quantity > 1) _quantity--;
                  });
                },
              ),
              Text(
                '$_quantity ${widget.lang == 'en' ? "kg" : "किग्रा"}',
                style: const TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              cart.addItem(widget.vegetable, _quantity);
              Navigator.pop(context);
              CustomToast.show(
                context,
                message: widget.lang == 'en'
                    ? "${_quantity}kg added to cart!"
                    : "${_quantity}किग्रा कार्ट में जोड़ा गया!",
                icon: Icons.shopping_cart_outlined,
                backgroundColor: Colors.green.shade700,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              widget.lang == 'en' ? "Add to Cart" : "कार्ट में जोड़ें",
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

