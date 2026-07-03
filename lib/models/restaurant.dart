import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
<<<<<<< HEAD
import 'package:supabase_flutter/supabase_flutter.dart';

// Conditional import: web alert sounds on browser, stub on mobile/desktop
import 'web_sync_stub.dart'
    if (dart.library.html) 'web_sync_web.dart';

// ─── ENUMS ──────────────────────────────────────────────────────────────────

enum AppMode { roleSelection, customer, admin }
enum WeatherMode { sunny, rainy, cold }
enum OrderStatus { pending, preparing, ready, served }

// ─── MODELS ─────────────────────────────────────────────────────────────────
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

enum WeatherMode { sunny, rainy, cold }
enum OrderStatus { pending, preparing, ready }
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
<<<<<<< HEAD
  final String imageUrl;
  final String imageAsset;
=======
  final String imageUrl;   // Primary high-quality Unsplash image
  final String imageAsset; // Local asset fallback
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.imageAsset,
  });
<<<<<<< HEAD

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: json['id'] as String,
        name: json['name'] as String,
        description: (json['description'] ?? '') as String,
        price: (json['price'] as num).toDouble(),
        category: json['category'] as String,
        imageUrl: (json['image_url'] ?? '') as String,
        imageAsset: (json['image_asset'] ?? '') as String,
      );
=======
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
}

class CartItem {
  final MenuItem item;
  int quantity;
  CartItem({required this.item, this.quantity = 1});
  double get totalPrice => item.price * quantity;
}

class Order {
  final String id;
<<<<<<< HEAD
  final int tableNumber;
  final List<CartItem> items;
  final DateTime timestamp;
  OrderStatus status;

  Order({
    required this.id,
    required this.tableNumber,
=======
  final List<CartItem> items;
  final DateTime timestamp;
  OrderStatus status;
  Order({
    required this.id,
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
    required this.items,
    required this.timestamp,
    this.status = OrderStatus.pending,
  });
<<<<<<< HEAD

  double get totalAmount =>
      items.fold(0, (sum, ci) => sum + ci.totalPrice);

  Map<String, dynamic> toInsertJson() => {
        'id': id,
        'table_number': tableNumber,
        'status': status.name,
        'total_amount': totalAmount,
      };
}

// ─── RESTAURANT STATE ────────────────────────────────────────────────────────

class RestaurantState extends ChangeNotifier {
  // ── App Mode ──────────────────────────────────────────────────────────────
  AppMode _currentMode = AppMode.roleSelection;
  AppMode get currentMode => _currentMode;

  void setMode(AppMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  // ── Weather ───────────────────────────────────────────────────────────────
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
  WeatherMode _currentWeather = WeatherMode.sunny;
  double _currentTemp = 32.0;
  bool _isFetchingWeather = false;

  WeatherMode get currentWeather => _currentWeather;
  double get currentTemp => _currentTemp;
  bool get isFetchingWeather => _isFetchingWeather;

<<<<<<< HEAD
=======
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

>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
  void updateWeather(WeatherMode mode, double temp) {
    _currentWeather = mode;
    _currentTemp = temp;
    notifyListeners();
  }

<<<<<<< HEAD
=======
  /// Fetches real temperature from wttr.in (free, no API key needed)
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
  Future<void> fetchRealWeather() async {
    _isFetchingWeather = true;
    notifyListeners();
    try {
<<<<<<< HEAD
      final response = await http
          .get(Uri.parse('https://wttr.in/?format=j1'))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tempC = double.tryParse(
                data['current_condition'][0]['temp_C'].toString()) ??
            30.0;
        final weatherDesc = data['current_condition'][0]['weatherDesc'][0]
            ['value']
            .toString()
            .toLowerCase();
        WeatherMode mode;
        if (weatherDesc.contains('rain') ||
            weatherDesc.contains('drizzle') ||
            weatherDesc.contains('shower')) {
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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
<<<<<<< HEAD
      // silently fall back to defaults
=======
      // silently fall back to defaults if network unavailable
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
    } finally {
      _isFetchingWeather = false;
      notifyListeners();
    }
  }

<<<<<<< HEAD
  // ── Table ─────────────────────────────────────────────────────────────────
  int _currentTableNumber = 1;
  int get currentTableNumber => _currentTableNumber;

=======
  // Active table selection (default is Table 1)
  int _currentTableNumber = 1;
  int get currentTableNumber => _currentTableNumber;
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
  void updateTableNumber(int number) {
    _currentTableNumber = number;
    notifyListeners();
  }

<<<<<<< HEAD
  // ── Cart ──────────────────────────────────────────────────────────────────
=======
  // Current Cart
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  void addToCart(MenuItem item) {
<<<<<<< HEAD
    final index = _cart.indexWhere((ci) => ci.item.id == item.id);
=======
    int index = _cart.indexWhere((cartItem) => cartItem.item.id == item.id);
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void removeFromCart(MenuItem item) {
<<<<<<< HEAD
    final index = _cart.indexWhere((ci) => ci.item.id == item.id);
=======
    int index = _cart.indexWhere((cartItem) => cartItem.item.id == item.id);
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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

<<<<<<< HEAD
  // ── Orders ────────────────────────────────────────────────────────────────
  final Map<int, List<Order>> _placedOrders = {};
  Map<int, List<Order>> get placedOrders => _placedOrders;

  List<Order> getOrdersForTable(int tableNum) =>
      _placedOrders[tableNum] ?? [];

  double getTableOrdersTotal(int tableNum) =>
      getOrdersForTable(tableNum)
          .fold(0.0, (sum, order) => sum + order.totalAmount);

  // ── Waiter / Bill Requests ────────────────────────────────────────────────
  final Map<int, bool> _waiterRequests = {};
  final Map<int, bool> _billRequests = {};

  Map<int, bool> get waiterRequests => _waiterRequests;
  Map<int, bool> get billRequests => _billRequests;

  bool isWaiterRequested(int tableNum) => _waiterRequests[tableNum] ?? false;
  bool isBillRequested(int tableNum) => _billRequests[tableNum] ?? false;

  Future<void> requestWaiter(int tableNum) async {
    _waiterRequests[tableNum] = true;
    notifyListeners();
    try {
      playWaiterAlert();
      await Supabase.instance.client
          .from('tables')
          .update({'waiter_requested': true})
          .eq('table_number', tableNum);
    } catch (_) {}
  }

  Future<void> clearWaiterRequest(int tableNum) async {
    _waiterRequests[tableNum] = false;
    notifyListeners();
    try {
      await Supabase.instance.client
          .from('tables')
          .update({'waiter_requested': false})
          .eq('table_number', tableNum);
    } catch (_) {}
  }

  Future<void> requestBill(int tableNum) async {
    _billRequests[tableNum] = true;
    notifyListeners();
    try {
      playWaiterAlert();
      await Supabase.instance.client
          .from('tables')
          .update({'bill_requested': true})
          .eq('table_number', tableNum);
    } catch (_) {}
  }

  Future<void> clearBillRequest(int tableNum) async {
    _billRequests[tableNum] = false;
    notifyListeners();
    try {
      await Supabase.instance.client
          .from('tables')
          .update({'bill_requested': false})
          .eq('table_number', tableNum);
    } catch (_) {}
  }

  Future<void> settleTable(int tableNum) async {
    _placedOrders[tableNum] = [];
    _waiterRequests[tableNum] = false;
    _billRequests[tableNum] = false;
    notifyListeners();
    try {
      await Supabase.instance.client
          .from('tables')
          .update({
            'waiter_requested': false,
            'bill_requested': false,
            'status': 'closed',
          })
          .eq('table_number', tableNum);
      // Mark all orders as served
      await Supabase.instance.client
          .from('orders')
          .update({'status': 'served', 'is_paid': true})
          .eq('table_number', tableNum)
          .eq('is_paid', false);
    } catch (_) {}
  }

  // ── Bill State ────────────────────────────────────────────────────────────
  bool get isBillPaid =>
      _billRequests[_currentTableNumber] == false &&
      _placedOrders[_currentTableNumber]?.isEmpty == false &&
      (_placedOrders[_currentTableNumber]
              ?.every((o) => o.status == OrderStatus.served) ??
          false);
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1

  void resetSession() {
    _cart.clear();
    _placedOrders[_currentTableNumber] = [];
<<<<<<< HEAD
    _waiterRequests[_currentTableNumber] = false;
    _billRequests[_currentTableNumber] = false;
    notifyListeners();
  }

  // ── Place Order ────────────────────────────────────────────────────────────
  Future<void> placeOrder() async {
    if (_cart.isEmpty) return;

    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final newOrder = Order(
      id: orderId,
      tableNumber: _currentTableNumber,
      items: List.from(_cart.map((ci) => CartItem(item: ci.item, quantity: ci.quantity))),
      timestamp: DateTime.now(),
    );

=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
    if (!_placedOrders.containsKey(_currentTableNumber)) {
      _placedOrders[_currentTableNumber] = [];
    }
    _placedOrders[_currentTableNumber]!.add(newOrder);
    _cart.clear();
<<<<<<< HEAD
    notifyListeners();

    // Sync to Supabase
    try {
      // Ensure table is open
      await Supabase.instance.client
          .from('tables')
          .update({'status': 'open'})
          .eq('table_number', _currentTableNumber);

      // Insert the order
      await Supabase.instance.client
          .from('orders')
          .insert(newOrder.toInsertJson());

      // Insert order items
      final orderItemRows = newOrder.items
          .map((ci) => {
                'order_id': orderId,
                'menu_item_id': ci.item.id,
                'quantity': ci.quantity,
              })
          .toList();
      await Supabase.instance.client
          .from('order_items')
          .insert(orderItemRows);
    } catch (_) {}
  }

  // ── Update Order Status (Kitchen action) ──────────────────────────────────
  Future<void> updateOrderStatus(
      int tableNum, String orderId, OrderStatus status) async {
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
    if (_placedOrders.containsKey(tableNum)) {
      for (var order in _placedOrders[tableNum]!) {
        if (order.id == orderId) {
          order.status = status;
<<<<<<< HEAD
=======
          if (Firebase.apps.isNotEmpty) {
            FirebaseFirestore.instance.collection('orders').doc(order.id).update({'status': order.status.name});
          }
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
          notifyListeners();
          break;
        }
      }
    }
<<<<<<< HEAD
    try {
      await Supabase.instance.client
          .from('orders')
          .update({'status': status.name})
          .eq('id', orderId);
    } catch (_) {}
  }

  Future<void> setTableOrdersReady(int tableNum) async {
    if (_placedOrders.containsKey(tableNum)) {
      for (var order in _placedOrders[tableNum]!) {
        if (order.status != OrderStatus.ready) {
          order.status = OrderStatus.ready;
        }
      }
      notifyListeners();
    }
    try {
      await Supabase.instance.client
          .from('orders')
          .update({'status': 'ready'})
          .eq('table_number', tableNum)
          .eq('status', 'pending');
    } catch (_) {}
  }

  // ── Supabase Real-Time Listeners ──────────────────────────────────────────
  RealtimeChannel? _ordersChannel;
  RealtimeChannel? _tablesChannel;
  bool _initialized = false;

  Future<void> initSupabaseSync() async {
    if (_initialized) return;
    _initialized = true;

    // Load current orders from Supabase
    await _loadOrdersFromSupabase();

    // Load table request states
    await _loadTableStatesFromSupabase();

    // Listen to orders changes
    _ordersChannel = Supabase.instance.client
        .channel('public:orders')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'orders',
          callback: (payload) => _handleOrderChange(payload),
        )
        .subscribe();

    // Listen to tables changes (waiter/bill requests)
    _tablesChannel = Supabase.instance.client
        .channel('public:tables')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tables',
          callback: (payload) => _handleTableChange(payload),
        )
        .subscribe();
  }

  Future<void> _loadOrdersFromSupabase() async {
    try {
      final response = await Supabase.instance.client
          .from('orders')
          .select('*, order_items(*, menu_items(*))')
          .neq('status', 'served')
          .neq('is_paid', true);

      _placedOrders.clear();
      for (final row in response as List) {
        final tableNum = row['table_number'] as int;
        final order = _parseOrderRow(row);
        if (order != null) {
          if (!_placedOrders.containsKey(tableNum)) {
            _placedOrders[tableNum] = [];
          }
          // Avoid duplicates
          if (!_placedOrders[tableNum]!.any((o) => o.id == order.id)) {
            _placedOrders[tableNum]!.add(order);
          }
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _loadTableStatesFromSupabase() async {
    try {
      final response = await Supabase.instance.client
          .from('tables')
          .select('table_number, waiter_requested, bill_requested');

      for (final row in response as List) {
        final tableNum = row['table_number'] as int;
        _waiterRequests[tableNum] = (row['waiter_requested'] ?? false) as bool;
        _billRequests[tableNum] = (row['bill_requested'] ?? false) as bool;
      }
      notifyListeners();
    } catch (_) {}
  }

  void _handleOrderChange(PostgresChangePayload payload) {
    final newRecord = payload.newRecord;
    final oldRecord = payload.oldRecord;

    if (payload.eventType == PostgresChangeEvent.insert ||
        payload.eventType == PostgresChangeEvent.update) {
      if (newRecord.isEmpty) return;
      // Reload fully on change to get order_items joined
      _loadOrdersFromSupabase();
      // Play alert for new order in admin mode
      if (_currentMode == AppMode.admin &&
          payload.eventType == PostgresChangeEvent.insert) {
        playKitchenAlert();
      }
    } else if (payload.eventType == PostgresChangeEvent.delete) {
      if (oldRecord.isEmpty) return;
      final tableNum = oldRecord['table_number'] as int?;
      final orderId = oldRecord['id'] as String?;
      if (tableNum != null && orderId != null) {
        _placedOrders[tableNum]?.removeWhere((o) => o.id == orderId);
        notifyListeners();
      }
    }
  }

  void _handleTableChange(PostgresChangePayload payload) {
    final record = payload.newRecord;
    if (record.isEmpty) return;
    final tableNum = record['table_number'] as int?;
    if (tableNum == null) return;

    final prevWaiter = _waiterRequests[tableNum] ?? false;
    final prevBill = _billRequests[tableNum] ?? false;

    _waiterRequests[tableNum] = (record['waiter_requested'] ?? false) as bool;
    _billRequests[tableNum] = (record['bill_requested'] ?? false) as bool;

    // Play alert in admin mode when a new waiter/bill request comes in
    if (_currentMode == AppMode.admin) {
      if ((_waiterRequests[tableNum]! && !prevWaiter) ||
          (_billRequests[tableNum]! && !prevBill)) {
        playWaiterAlert();
      }
    }
    notifyListeners();
  }

  Order? _parseOrderRow(Map<String, dynamic> row) {
    try {
      final statusStr = row['status'] as String;
      final status = OrderStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => OrderStatus.pending,
      );
      final rawItems = row['order_items'] as List? ?? [];
      final cartItems = rawItems
          .map((oi) {
            final menuData = oi['menu_items'] as Map<String, dynamic>?;
            if (menuData == null) return null;
            final menuItem = MenuItem.fromJson(menuData);
            return CartItem(item: menuItem, quantity: oi['quantity'] as int);
          })
          .whereType<CartItem>()
          .toList();

      return Order(
        id: row['id'] as String,
        tableNumber: row['table_number'] as int,
        items: cartItems,
        timestamp: DateTime.parse(row['created_at'] as String),
        status: status,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _ordersChannel?.unsubscribe();
    _tablesChannel?.unsubscribe();
    super.dispose();
  }

  // ── Smart Recommendations ──────────────────────────────────────────────────
=======
  }

  // ─── SMART RECOMMENDATION SYSTEM ───────────────────────────────────────────

  /// Returns a time-based greeting
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
  String get greetingText {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️ Good Morning! Here\'s what we suggest for you';
    if (hour < 17) return '🌤️ Good Afternoon! Today\'s perfect picks';
    return '🌙 Good Evening! End the day on a delicious note';
  }

<<<<<<< HEAD
=======
  /// Recommendation panel title based on time + weather
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
  String get recommendationTitle {
    final hour = DateTime.now().hour;
    if (_currentWeather == WeatherMode.rainy) return 'Rainy Day Comfort Food 🌧️';
    if (_currentWeather == WeatherMode.cold) return 'Warm Up Specials ❄️';
    if (hour < 12) return 'Breakfast & Brunch Picks 🍳';
    if (hour < 17) return 'Lunch Time Favourites 🍽️';
    return 'Dinner Delights 🍷';
  }

<<<<<<< HEAD
=======
  /// Recommendation panel subtitle
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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

<<<<<<< HEAD
  List<MenuItem> getRecommendations() {
    final hour = DateTime.now().hour;
    if (_currentWeather == WeatherMode.rainy) {
      return menuItems
          .where((item) =>
              ['Pizza', 'Burger', 'Beverages'].contains(item.category))
          .take(4)
          .toList();
    }
    if (_currentWeather == WeatherMode.cold) {
      return menuItems
          .where((item) =>
              ['Pizza', 'Burger', 'Beverages'].contains(item.category))
          .take(4)
          .toList();
    }
    if (hour < 12) {
      return menuItems
          .where((item) =>
              ['Beverages', 'Desserts', 'Softies'].contains(item.category))
          .take(4)
          .toList();
    } else if (hour < 17) {
      return menuItems
          .where((item) => ['Burger', 'Pizza'].contains(item.category))
          .take(4)
          .toList();
    } else {
      return menuItems
          .where((item) =>
              ['Softies', 'Desserts', 'Beverages'].contains(item.category))
          .take(4)
          .toList();
    }
  }

  // ── Static Menu Items ─────────────────────────────────────────────────────
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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
<<<<<<< HEAD
    // COMBOS
=======
    // COMBO DEALS
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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

<<<<<<< HEAD
// ─── INHERITED WIDGET ─────────────────────────────────────────────────────────
=======
// ─── INHERITED WIDGET for state sharing across the widget tree ───────────────
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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