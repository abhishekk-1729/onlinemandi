import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/cart_model.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/orders/presentation/pages/orders_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'shared/widgets/custom_toast.dart';

void main() {
  runApp(
    ChangeNotifierProvider<CartModel>(
      create: (BuildContext context) => CartModel(),
      builder: (BuildContext context, Widget? child) => const MaterialApp(
        home: OnlineMandiApp(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

/// Main application widget, handling authentication, language, and tab navigation.
class OnlineMandiApp extends StatefulWidget {
  const OnlineMandiApp({super.key});

  @override
  State<OnlineMandiApp> createState() => _OnlineMandiAppState();
}

class _OnlineMandiAppState extends State<OnlineMandiApp> {
  String lang = 'en';
  int currentTab = 0;
  Map<String, dynamic>? user;

  @override
  Widget build(BuildContext context) {
    return user == null ? _buildLoginUI() : _buildMainUI();
  }

  // ---------------- LOGIN SCREENS ----------------
  Widget _buildLoginUI() {
    return LoginPage(
      onLoginSuccess: (Map<String, dynamic> loggedInUser) {
        setState(() {
          user = loggedInUser;
        });
      },
    );
  }

  // ---------------- MAIN APP UI ----------------
  Widget _buildMainUI() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "🥬  ${lang == 'en' ? "OnlineMandi" : "ऑनलाइनमंडी"}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() => lang = lang == 'en' ? 'hi' : 'en');
            },
            child: Text(
              lang == 'en' ? "हिंदी" : "English",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: <Widget>[
              HomePage(lang: lang),
              CartPage(
                lang: lang,
                onProceedToCheckout: () {
                  final CartModel cart = Provider.of<CartModel>(
                    context,
                    listen: false,
                  );
                  cart.placeOrder(); // Place the order and clear the cart
                  setState(() {
                    currentTab = 2; // Navigate to the "Orders" tab
                  });
                  CustomToast.show(
                    context,
                    message: lang == 'en'
                        ? "Order placed successfully!"
                        : "ऑर्डर सफलतापूर्वक दिया गया!",
                    icon: Icons.check_circle_outline,
                    backgroundColor: Colors.green.shade700,
                  );
                },
              ),
              OrdersPage(lang: lang),
              ProfilePage(
                user: user!,
                lang: lang,
                onLogout: () {
                  setState(() {
                    user = null;
                  });
                  Provider.of<CartModel>(
                    context,
                    listen: false,
                  ).clearCart(); // Clear cart on logout
                  CustomToast.show(
                    context,
                    message: lang == 'en' ? "Logged out!" : "लॉग आउट किया गया!",
                    icon: Icons.info_outline,
                    backgroundColor: Colors.green.shade700,
                  );
                },
                onProfileUpdated: (Map<String, dynamic> updatedUser) {
                  setState(() {
                    user = updatedUser;
                  });
                  CustomToast.show(
                    context,
                    message: lang == 'en'
                        ? "Profile updated successfully!"
                        : "प्रोफ़ाइल सफलतापूर्वक अपडेट की गई!",
                    icon: Icons.check_circle_outline,
                    backgroundColor: Colors.green.shade700,
                  );
                },
              ),
            ][currentTab],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (int i) => setState(() => currentTab = i),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: lang == 'en' ? "Home" : "होम",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: lang == 'en' ? "Cart" : "कार्ट",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt),
            label: lang == 'en' ? "Orders" : "ऑर्डर",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: lang == 'en' ? "Profile" : "प्रोफाइल",
          ),
        ],
      ),
    );
  }
}
