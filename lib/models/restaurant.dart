import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

enum WeatherMode { sunny, rainy, cold }
enum OrderStatus { pending, preparing, ready }

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;   // Primary high-quality Unsplash image
  final String imageAsset; // Local asset fallback

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.imageAsset,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;
  CartItem({required this.item, this.quantity = 1});
  double get totalPrice => item.price * quantity;
}

class Order {
  final String id;
  final List<CartItem> items;
  final DateTime timestamp;
  OrderStatus status;
  Order({
    required this.id,
    required this.items,
    required this.timestamp,
    this.status = OrderStatus.pending,
  });
  double get totalAmount => items.fold(0, (sum, cartItem) => sum + cartItem.totalPrice);

  Map<String, dynamic> toJson(int tableNum) => {
        'id': id,
        'tableNumber': tableNum,
        'timestamp': timestamp.toIso8601String(),
        'status': status.name,
        'items': items.map((ci) => {
          'itemId': ci.item.id,
          'quantity': ci.quantity,
        }).toList(),
      };

  factory Order.fromJson(Map<String, dynamic> json, List<MenuItem> fullMenu) {
    return Order(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      status: OrderStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => OrderStatus.pending),
      items: (json['items'] as List).map((i) {
        final item = fullMenu.firstWhere((m) => m.id == i['itemId']);
        return CartItem(item: item, quantity: i['quantity']);
      }).toList(),
    );
  }
}

class RestaurantState extends ChangeNotifier {
  // Weather state
  WeatherMode _currentWeather = WeatherMode.sunny;
  double _currentTemp = 32.0;
  bool _isFetchingWeather = false;

  WeatherMode get currentWeather => _currentWeather;
  double get currentTemp => _currentTemp;
  bool get isFetchingWeather => _isFetchingWeather;

  RestaurantState() {
    _initFirebaseSync();
  }

  void _initFirebaseSync() {
    if (Firebase.apps.isEmpty) return; // Skip if Firebase not configured
    
    FirebaseFirestore.instance.collection('orders').snapshots().listen((snapshot) {
      _placedOrders.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final tableNum = data['tableNumber'] as int;
        final order = Order.fromJson(data, menuItems);
        
        if (!_placedOrders.containsKey(tableNum)) {
          _placedOrders[tableNum] = [];
        }
        _placedOrders[tableNum]!.add(order);
      }
      notifyListeners();
    });
  }

  void updateWeather(WeatherMode mode, double temp) {
    _currentWeather = mode;
    _currentTemp = temp;
    notifyListeners();
  }

  /// Fetches real temperature from wttr.in (free, no API key needed)
  Future<void> fetchRealWeather() async {
    _isFetchingWeather = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('https://wttr.in/?format=j1'),
      ).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tempC = double.tryParse(
          data['current_condition'][0]['temp_C'].toString(),
        ) ?? 30.0;
        final weatherDesc = data['current_condition'][0]['weatherDesc'][0]['value']
            .toString()
            .toLowerCase();

        WeatherMode mode;
        if (weatherDesc.contains('rain') || weatherDesc.contains('drizzle') || weatherDesc.contains('shower')) {
          mode = WeatherMode.rainy;
        } else if (tempC < 20) {
          mode = WeatherMode.cold;
        } else {
          mode = WeatherMode.sunny;
        }
        _currentTemp = tempC;
        _currentWeather = mode;
      }
    } catch (_) {
      // silently fall back to defaults if network unavailable
    } finally {
      _isFetchingWeather = false;
      notifyListeners();
    }
  }

  // Active table selection (default is Table 1)
  int _currentTableNumber = 1;
  int get currentTableNumber => _currentTableNumber;
  void updateTableNumber(int number) {
    _currentTableNumber = number;
    notifyListeners();
  }

  // Current Cart
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  void addToCart(MenuItem item) {
    int index = _cart.indexWhere((cartItem) => cartItem.item.id == item.id);
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void removeFromCart(MenuItem item) {
    int index = _cart.indexWhere((cartItem) => cartItem.item.id == item.id);
    if (index >= 0) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Placed Orders by Table Number
  final Map<int, List<Order>> _placedOrders = {};
  Map<int, List<Order>> get placedOrders => _placedOrders;

  List<Order> getOrdersForTable(int tableNum) {
    return _placedOrders[tableNum] ?? [];
  }

  double getTableOrdersTotal(int tableNum) {
    return getOrdersForTable(tableNum).fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Combined Active Bill Status
  bool _isBillPaid = false;
  bool get isBillPaid => _isBillPaid;

  void resetSession() {
    _cart.clear();
    _placedOrders[_currentTableNumber] = [];
    _isBillPaid = false;
    notifyListeners();
  }

  void markBillAsPaid() {
    _isBillPaid = true;
    notifyListeners();
  }

  // Place Order Action
  void placeOrder() {
    if (_cart.isEmpty) return;
    final newOrder = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(_cart.map((ci) => CartItem(item: ci.item, quantity: ci.quantity))),
      timestamp: DateTime.now(),
    );
    if (!_placedOrders.containsKey(_currentTableNumber)) {
      _placedOrders[_currentTableNumber] = [];
    }
    _placedOrders[_currentTableNumber]!.add(newOrder);
    _cart.clear();
    _isBillPaid = false;
    notifyListeners();
    
    // Sync to Firebase if available
    if (Firebase.apps.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('orders')
          .doc(newOrder.id)
          .set(newOrder.toJson(_currentTableNumber));
    }
  }

  // Admin Action: Update status of all orders of a table
  void setTableOrdersReady(int tableNum) {
    if (_placedOrders.containsKey(tableNum)) {
      for (var order in _placedOrders[tableNum]!) {
        if (order.status != OrderStatus.ready) {
          order.status = OrderStatus.ready;
          if (Firebase.apps.isNotEmpty) {
            FirebaseFirestore.instance.collection('orders').doc(order.id).update({'status': order.status.name});
          }
        }
      }
      notifyListeners();
    }
  }

  // Admin Action: Update status of individual order
  void updateOrderStatus(int tableNum, String orderId, OrderStatus status) {
    if (_placedOrders.containsKey(tableNum)) {
      for (var order in _placedOrders[tableNum]!) {
        if (order.id == orderId) {
          order.status = status;
          if (Firebase.apps.isNotEmpty) {
            FirebaseFirestore.instance.collection('orders').doc(order.id).update({'status': order.status.name});
          }
          notifyListeners();
          break;
        }
      }
    }
  }

  // ─── SMART RECOMMENDATION SYSTEM ───────────────────────────────────────────

  /// Returns a time-based greeting
  String get greetingText {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️ Good Morning! Here\'s what we suggest for you';
    if (hour < 17) return '🌤️ Good Afternoon! Today\'s perfect picks';
    return '🌙 Good Evening! End the day on a delicious note';
  }

  /// Recommendation panel title based on time + weather
  String get recommendationTitle {
    final hour = DateTime.now().hour;
    if (_currentWeather == WeatherMode.rainy) return 'Rainy Day Comfort Food 🌧️';
    if (_currentWeather == WeatherMode.cold) return 'Warm Up Specials ❄️';
    if (hour < 12) return 'Breakfast & Brunch Picks 🍳';
    if (hour < 17) return 'Lunch Time Favourites 🍽️';
    return 'Dinner Delights 🍷';
  }

  /// Recommendation panel subtitle
  String get recommendationSubtitle {
    final temp = _currentTemp.toStringAsFixed(0);
    final hour = DateTime.now().hour;
    if (_currentWeather == WeatherMode.rainy) {
      return 'It\'s rainy outside — comfort food awaits!';
    }
    if (_currentWeather == WeatherMode.cold) {
      return '${temp}°C outside — warm your soul with hot picks';
    }
    if (hour < 12) return 'Start your morning right with our top picks';
    if (hour < 17) return '${temp}°C • The perfect lunch to power your afternoon';
    return '${temp}°C • Unwind with our evening signature dishes';
  }

  /// Smart recommendation based on real time + temperature
  List<MenuItem> getRecommendations() {
    final hour = DateTime.now().hour;

    // Weather-based overrides
    if (_currentWeather == WeatherMode.rainy) {
      // Rainy day: hot food — pizza, hot drinks, burgers
      return menuItems.where((item) =>
        ['Pizza', 'Burger', 'Beverages'].contains(item.category)).take(4).toList();
    }

    if (_currentWeather == WeatherMode.cold) {
      // Cold: hot fills — pizza, burgers, hot beverages
      return menuItems.where((item) =>
        ['Pizza', 'Burger', 'Beverages'].contains(item.category)).take(4).toList();
    }

    // Time-based recommendations (sunny/default)
    if (hour < 12) {
      // Morning: beverages, desserts (light)
      return menuItems.where((item) =>
        ['Beverages', 'Desserts', 'Softies'].contains(item.category)).take(4).toList();
    } else if (hour < 17) {
      // Afternoon / lunch: burgers, pizza (heavy)
      return menuItems.where((item) =>
        ['Burger', 'Pizza'].contains(item.category)).take(4).toList();
    } else {
      // Evening: softies, desserts, beverages (after dinner)
      return menuItems.where((item) =>
        ['Softies', 'Desserts', 'Beverages'].contains(item.category)).take(4).toList();
    }
  }

  // ─── MENU ITEMS ────────────────────────────────────────────────────────────
  static final List<MenuItem> menuItems = [
    // PIZZAS
    MenuItem(
      id: 'p1',
      name: 'Truffle Mushroom Pizza',
      description: 'Gourmet wild mushrooms, premium mozzarella, white truffle oil & microgreens.',
      price: 349.0,
      category: 'Pizza',
      imageUrl: 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/truffle_pizza.png',
    ),
    MenuItem(
      id: 'p2',
      name: 'Burrata & Pesto Pizza',
      description: 'Creamy burrata ball, fresh basil pesto sauce, heirloom tomatoes & balsamic glaze.',
      price: 299.0,
      category: 'Pizza',
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/pizza.png',
    ),
    MenuItem(
      id: 'p3',
      name: 'Classic Margherita',
      description: 'San Marzano tomato sauce, fresh buffalo mozzarella, fresh basil & olive oil.',
      price: 229.0,
      category: 'Pizza',
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/pizza.png',
    ),
    // BURGERS
    MenuItem(
      id: 'b1',
      name: 'The Signature Burger',
      description: 'Prime Angus beef patty, black truffle mayo, aged cheddar in a brioche bun.',
      price: 399.0,
      category: 'Burger',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/burger.png',
    ),
    MenuItem(
      id: 'b2',
      name: 'Avocado & Haloumi Burger',
      description: 'Grilled Cypriot haloumi cheese, smashed avocado, leaf lettuce & heirloom tomato sauce.',
      price: 279.0,
      category: 'Burger',
      imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/burger.png',
    ),
    MenuItem(
      id: 'b3',
      name: 'Smoked BBQ Chicken Burger',
      description: 'Crispy fried chicken breast, house hickory smoked BBQ, purple slaw & brioche.',
      price: 259.0,
      category: 'Burger',
      imageUrl: 'https://images.unsplash.com/photo-1521305916504-4a1121188589?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/burger.png',
    ),
    // DESSERTS
    MenuItem(
      id: 'd1',
      name: 'Signature Tiramisu',
      description: 'Espresso-soaked ladyfingers, rich mascarpone cream, dark cocoa powder dusting.',
      price: 199.0,
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/dessert.png',
    ),
    MenuItem(
      id: 'd2',
      name: 'Classic Waffle with Berries',
      description: 'Warm freshly baked waffle, mixed berry compote, double vanilla whipped cream.',
      price: 179.0,
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/dessert.png',
    ),
    MenuItem(
      id: 'd3',
      name: 'Nutella & Waffle',
      description: 'Warm waffle, premium Nutella drizzle, vanilla bean gelato & crushed roasted hazelnuts.',
      price: 219.0,
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1484723091739-30990c52b851?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/dessert.png',
    ),
    // SOFTIES
    MenuItem(
      id: 's1',
      name: 'Pistachio Soft Serve',
      description: 'Rich Sicilian pistachio milk soft ice cream with crushed pistachios on top.',
      price: 129.0,
      category: 'Softies',
      imageUrl: 'https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/softie.png',
    ),
    MenuItem(
      id: 's2',
      name: 'Salted Caramel Softie',
      description: 'Vanilla bean soft serve, house-made salted caramel sauce, Maldon sea salt flakes.',
      price: 109.0,
      category: 'Softies',
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/softie.png',
    ),
    // BEVERAGES
    MenuItem(
      id: 'v1',
      name: 'Cold Brew Latte',
      description: 'Slow-dripped cold brew coffee, creamy organic milk, premium vanilla bean.',
      price: 149.0,
      category: 'Beverages',
      imageUrl: 'https://images.unsplash.com/photo-1461023058043-03348144b8b8?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/beverage.png',
    ),
    MenuItem(
      id: 'v2',
      name: 'Rosemary & Peach Tonic',
      description: 'Cold-pressed peach puree, fresh organic rosemary sprigs, premium tonic water.',
      price: 129.0,
      category: 'Beverages',
      imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/beverage.png',
    ),
    MenuItem(
      id: 'v3',
      name: 'Espresso Romano',
      description: 'Double shot of signature roasted espresso served with a fresh organic lemon twist.',
      price: 99.0,
      category: 'Beverages',
      imageUrl: 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/beverage.png',
    ),
    // COMBO DEALS
    MenuItem(
      id: 'combo_box',
      name: 'Solo Box Deal',
      description: 'Margherita Pizza + Cold Brew Latte + Pistachio Softie. Perfect for one!',
      price: 399.0,
      category: 'Combos',
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/pizza.png',
    ),
    MenuItem(
      id: 'combo_feast',
      name: 'Couple Feast',
      description: 'Truffle Pizza + 2 Signature Burgers + 2 Beverages. Perfect date night!',
      price: 699.0,
      category: 'Combos',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/burger.png',
    ),
    MenuItem(
      id: 'combo_bucket',
      name: 'Family Bucket',
      description: '2 Pizzas + 4 Burgers + 4 Softies + 4 Beverages. Feed the whole family!',
      price: 1299.0,
      category: 'Combos',
      imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&w=600&q=80',
      imageAsset: 'assets/images/burger.png',
    ),
  ];
}

// ─── INHERITED WIDGET for state sharing across the widget tree ───────────────
class InheritedRestaurantState extends InheritedNotifier<RestaurantState> {
  const InheritedRestaurantState({
    super.key,
    required RestaurantState state,
    required super.child,
  }) : super(notifier: state);

  static RestaurantState of(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<InheritedRestaurantState>();
    assert(widget != null, 'No InheritedRestaurantState found in context');
    return widget!.notifier!;
  }
}