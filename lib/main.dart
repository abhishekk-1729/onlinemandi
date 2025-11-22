import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Required for Timer

/// DATA_MODEL
/// Represents a single vegetable product.
class Vegetable {
  final String nameEn;
  final String nameHi;
  final int marketPrice;
  final int ourPrice;
  final String emoji;

  Vegetable({
    required this.nameEn,
    required this.nameHi,
    required this.marketPrice,
    required this.ourPrice,
    required this.emoji,
  });

  // Override equality to correctly compare Vegetable objects in lists/sets
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vegetable &&
          runtimeType == other.runtimeType &&
          nameEn == other.nameEn &&
          nameHi == other.nameHi;

  @override
  int get hashCode => nameEn.hashCode ^ nameHi.hashCode;
}

/// Represents an item within the shopping cart or an order.
class CartItem {
  final Vegetable vegetable;
  int quantity;

  CartItem({required this.vegetable, this.quantity = 1});

  double get totalPrice => quantity * vegetable.ourPrice.toDouble();
}

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

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String authStep = 'phone';

  final List<Vegetable> vegetables = <Vegetable>[
    Vegetable(
      nameEn: "Tomato",
      nameHi: "टमाटर",
      marketPrice: 60,
      ourPrice: 45,
      emoji: "🍅",
    ),
    Vegetable(
      nameEn: "Potato",
      nameHi: "आलू",
      marketPrice: 40,
      ourPrice: 32,
      emoji: "🥔",
    ),
    Vegetable(
      nameEn: "Onion",
      nameHi: "प्याज",
      marketPrice: 50,
      ourPrice: 38,
      emoji: "🧅",
    ),
    Vegetable(
      nameEn: "Carrot",
      nameHi: "गाजर",
      marketPrice: 70,
      ourPrice: 55,
      emoji: "🥕",
    ),
    Vegetable(
      nameEn: "Spinach",
      nameHi: "पालक",
      marketPrice: 30,
      ourPrice: 20,
      emoji: "🍃",
    ),
    Vegetable(
      nameEn: "Cauliflower",
      nameHi: "फूलगोभी",
      marketPrice: 45,
      ourPrice: 35,
      emoji: "🥦",
    ),
    Vegetable(
      nameEn: "Cabbage",
      nameHi: "पत्ता गोभी",
      marketPrice: 35,
      ourPrice: 28,
      emoji: "🥬",
    ),
    Vegetable(
      nameEn: "Brinjal",
      nameHi: "बैंगन",
      marketPrice: 55,
      ourPrice: 40,
      emoji: "🍆",
    ),
  ];

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user == null ? _buildLoginUI() : _buildMainUI();
  }

  // ---------------- LOGIN SCREENS ----------------

  Widget _buildLoginUI() {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(blurRadius: 10, color: Colors.black12),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("🥬", style: TextStyle(fontSize: 50)),
                Text(
                  lang == 'en' ? "OnlineMandi" : "ऑनलाइनमंडी",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (authStep == 'phone') _buildPhoneInput(),
                if (authStep == 'otp') _buildOtpInput(),
                if (authStep == 'info') _buildInfoInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      children: <Widget>[
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: lang == 'en' ? "Phone Number" : "फोन नंबर",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (phoneController.text.length == 10) {
              setState(() => authStep = 'otp');
            } else {
              CustomToast.show(
                context,
                message: lang == 'en'
                    ? "Please enter a valid 10-digit phone number."
                    : "कृपया 10 अंकों का वैध फोन नंबर दर्ज करें।",
                icon: Icons.error_outline,
                backgroundColor: Colors.green.shade900, // Changed to green
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(lang == 'en' ? "Get OTP" : "OTP प्राप्त करें"),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      children: <Widget>[
        TextField(
          controller: otpController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: lang == 'en' ? "Enter OTP" : "OTP दर्ज करें",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (otpController.text.length == 6) {
              setState(() => authStep = 'info');
            } else {
              CustomToast.show(
                context,
                message: lang == 'en'
                    ? "Please enter a valid 6-digit OTP."
                    : "कृपया 6 अंकों का वैध OTP दर्ज करें।",
                icon: Icons.error_outline,
                backgroundColor: Colors.green.shade900, // Changed to green
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(lang == 'en' ? "Verify" : "सत्यापित करें"),
        ),
      ],
    );
  }

  Widget _buildInfoInput() {
    return Column(
      children: <Widget>[
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: lang == 'en' ? "Name" : "नाम",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: lang == 'en' ? "Address" : "पता",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final Map<String, String> currentInfo = <String, String>{
              "name": nameController.text,
              "email": emailController.text,
              "address": addressController.text,
            };

            if (currentInfo.values.every((String e) => e.isNotEmpty)) {
              setState(
                () => user = <String, dynamic>{
                  "phone": phoneController.text,
                  ...currentInfo,
                },
              );
              CustomToast.show(
                context,
                message: lang == 'en'
                    ? "Registration successful!"
                    : "पंजीकरण सफल!",
                icon: Icons.check_circle_outline,
                backgroundColor: Colors.green.shade700,
              );
            } else {
              CustomToast.show(
                context,
                message: lang == 'en'
                    ? "Please fill all fields."
                    : "कृपया सभी फ़ील्ड भरें।",
                icon: Icons.error_outline,
                backgroundColor: Colors.green.shade900, // Changed to green
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(lang == 'en' ? "Submit" : "जमा करें"),
        ),
      ],
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
              _buildHome(),
              CartScreen(
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
              _buildOrders(),
              ProfileScreen(
                user: user!,
                lang: lang,
                onLogout: () {
                  setState(() {
                    user = null;
                    authStep = 'phone';
                    phoneController.clear();
                    otpController.clear();
                    nameController.clear();
                    emailController.clear();
                    addressController.clear();
                  });
                  Provider.of<CartModel>(
                    context,
                    listen: false,
                  ).clearCart(); // Clear cart on logout
                  CustomToast.show(
                    context,
                    message: lang == 'en' ? "Logged out!" : "लॉग आउट किया गया!",
                    icon: Icons.info_outline,
                    backgroundColor: Colors.green.shade700, // Changed to green
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

  // ---------------- HOME SCREEN ----------------
  Widget _buildHome() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      childAspectRatio: 1.0, // Changed aspect ratio from .8 to 1.0
      children: vegetables.map<Widget>((Vegetable veg) {
        return GestureDetector(
          onTap: () => _showVegetablePopup(veg),
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
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content vertically
              children: <Widget>[
                Text(veg.emoji, style: const TextStyle(fontSize: 50)),
                // const SizedBox(height: 5), // REMOVED THIS LINE to prevent overflow
                Text(
                  lang == 'en' ? veg.nameEn : veg.nameHi,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹${veg.marketPrice}",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "₹${veg.ourPrice}/kg",
                  style: const TextStyle(fontSize: 18, color: Colors.green),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------- VEGETABLE POPUP ----------------
  void _showVegetablePopup(Vegetable veg) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext _) {
        // Use the new VegetableDetailsBottomSheet widget
        return VegetableDetailsBottomSheet(vegetable: veg, lang: lang);
      },
    );
  }

  // ---------------- ORDERS SCREEN ----------------
  Widget _buildOrders() {
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
        final Order order = cart.pastOrders[orderIndex];
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
            children: order.items.map<Widget>((CartItem item) {
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
                ), // Changed to green
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
                backgroundColor: Colors.green.shade700, // Changed to green
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
          const SizedBox(height: 10), // Add some padding below the button
        ],
      ),
    );
  }
}

/// Widget to display the shopping cart contents.
class CartScreen extends StatelessWidget {
  const CartScreen({
    required this.lang,
    required this.onProceedToCheckout,
    super.key,
  });

  final String lang;
  final VoidCallback onProceedToCheckout; // Callback to handle checkout action

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
              final CartItem item = cart.items[index];
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
                            ), // Changed to green
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
                            ), // Changed to green
                            onPressed: () {
                              cart.removeItem(item.vegetable);
                              CustomToast.show(
                                context,
                                message: lang == 'en'
                                    ? "${item.vegetable.nameEn} removed from cart."
                                    : "${item.vegetable.nameHi} कार्ट से हटा दिया गया।",
                                icon: Icons.delete_outline,
                                backgroundColor:
                                    Colors.green.shade700, // Changed to green
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
                  onPressed: () {
                    onProceedToCheckout(); // Call the callback provided by the parent
                  },
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

/// Widget to display and edit user profile information.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.user,
    required this.lang,
    required this.onLogout,
    required this.onProfileUpdated,
    super.key,
  });

  final Map<String, dynamic> user;
  final String lang;
  final VoidCallback onLogout;
  final ValueChanged<Map<String, dynamic>> onProfileUpdated;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.user['name'] as String,
    );
    _emailController = TextEditingController(
      text: widget.user['email'] as String,
    );
    _addressController = TextEditingController(
      text: widget.user['address'] as String,
    );
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user) {
      _nameController.text = widget.user['name'] as String;
      _emailController.text = widget.user['email'] as String;
      _addressController.text = widget.user['address'] as String;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // If exiting edit mode without saving, reset controllers to current widget.user data
        _nameController.text = widget.user['name'] as String;
        _emailController.text = widget.user['email'] as String;
        _addressController.text = widget.user['address'] as String;
      }
    });
  }

  void _saveProfile() {
    final Map<String, dynamic> updatedUser = <String, dynamic>{
      ...widget.user, // Keep existing fields like 'phone'
      "name": _nameController.text,
      "email": _emailController.text,
      "address": _addressController.text,
    };

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _addressController.text.isEmpty) {
      CustomToast.show(
        context,
        message: widget.lang == 'en'
            ? "Please fill all fields."
            : "कृपया सभी फ़ील्ड भरें।",
        icon: Icons.error_outline,
        backgroundColor: Colors.green.shade900, // Changed to green
      );
      return;
    }

    widget.onProfileUpdated(updatedUser);
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              widget.user['name'] as String,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    _isEditing
                        ? Column(
                            children: <Widget>[
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: widget.lang == 'en'
                                      ? "Name"
                                      : "नाम",
                                  prefixIcon: const Icon(Icons.person),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: const Icon(Icons.email),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                  labelText: widget.lang == 'en'
                                      ? "Address"
                                      : "पता",
                                  prefixIcon: const Icon(Icons.location_on),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _saveProfile,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        widget.lang == 'en' ? "Save" : "सहेजें",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _toggleEditMode,
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        side: const BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                      child: Text(
                                        widget.lang == 'en'
                                            ? "Cancel"
                                            : "रद्द करें",
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  widget.lang == 'en' ? "Name" : "नाम",
                                ),
                                subtitle: Text(widget.user['name'] as String),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),
                                title: const Text("Email"),
                                subtitle: Text(widget.user['email'] as String),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  widget.lang == 'en' ? "Phone" : "फ़ फ़ोन",
                                ),
                                subtitle: Text(widget.user['phone'] as String),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  widget.lang == 'en' ? "Address" : "पता",
                                ),
                                subtitle: Text(
                                  widget.user['address'] as String,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _toggleEditMode,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    widget.lang == 'en'
                                        ? "Edit Profile"
                                        : "प्रोफ़ाइल संपादित करें",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onLogout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(widget.lang == 'en' ? "Log Out" : "लॉग आउट करें"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .red, // Logout button can remain red for its specific meaning
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Toast for showing modern app-like notifications.
class CustomToast {
  static OverlayEntry? _currentOverlayEntry;

  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Remove any existing toast
    _currentOverlayEntry?.remove();

    _currentOverlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) => _ToastOverlayWidget(
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        duration: duration,
        onDismissed: () {
          _currentOverlayEntry?.remove();
          _currentOverlayEntry = null;
        },
      ),
    );

    Navigator.of(context).overlay!.insert(_currentOverlayEntry!);
  }
}

class _ToastOverlayWidget extends StatefulWidget {
  const _ToastOverlayWidget({
    required this.message,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  _ToastOverlayWidgetState createState() => _ToastOverlayWidgetState();
}

class _ToastOverlayWidgetState extends State<_ToastOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation =
        Tween<Offset>(
          begin: const Offset(0, -1.5), // Start much higher
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    _dismissTimer = Timer(widget.duration, () {
      _animationController.reverse().then((void value) {
        widget.onDismissed();
      });
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.icon != null) ...<Widget>[
                  Icon(widget.icon, color: widget.textColor),
                  const SizedBox(width: 8.0),
                ],
                Expanded(
                  child: Text(
                    widget.message,
                    style: TextStyle(color: widget.textColor, fontSize: 16.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
