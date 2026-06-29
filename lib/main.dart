import 'package:flutter/material.dart';
import 'theme/aesthetics.dart';
import 'models/restaurant.dart';
import 'screens/customer_home.dart';
import 'screens/customer_menu.dart';
import 'screens/customer_cart.dart';
import 'screens/customer_account.dart';
import 'screens/admin_panel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase not initialized: $e');
  }
  runApp(const QuickBiteApp());
}

class QuickBiteApp extends StatefulWidget {
  const QuickBiteApp({super.key});

  @override
  State<QuickBiteApp> createState() => _QuickBiteAppState();
}

class _QuickBiteAppState extends State<QuickBiteApp> {
  final RestaurantState _restaurantState = RestaurantState();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();
    
    // Handle deep links when app is already open
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
    
    // Handle deep link when app is started from cold state
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
  }

  void _handleDeepLink(Uri uri) {
    // Android Deep Link: quickbite://table/N
    if (uri.scheme == 'quickbite' && uri.host == 'table') {
      if (uri.pathSegments.isNotEmpty) {
        final tableNum = int.tryParse(uri.pathSegments.first);
        if (tableNum != null) {
          _restaurantState.updateTableNumber(tableNum);
        }
      }
    }
    
    // Web URL parsing: https://my-quickbite.vercel.app/?table=N
    if (uri.queryParameters.containsKey('table')) {
      final tableNum = int.tryParse(uri.queryParameters['table']!);
      if (tableNum != null) {
        _restaurantState.updateTableNumber(tableNum);
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedRestaurantState(
      state: _restaurantState,
      child: MaterialApp(
        title: 'QuickBite',
        debugShowCheckedModeBanner: false,
        theme: CafeTheme.themeData,
        home: const AppNavigationWrapper(),
      ),
    );
  }
}

class AppNavigationWrapper extends StatefulWidget {
  const AppNavigationWrapper({super.key});

  @override
  State<AppNavigationWrapper> createState() => _AppNavigationWrapperState();
}

class _AppNavigationWrapperState extends State<AppNavigationWrapper> {
  int _selectedTabIndex = 0;
  bool _isAdminView = false;

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _navigateToMenu() {
    setState(() {
      _selectedTabIndex = 1; // Menu index
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    if (_isAdminView) {
      return AdminPanelScreen(
        onToggleCustomerView: () {
          setState(() {
            _isAdminView = false;
          });
        },
      );
    }

    // List of screens corresponding to customer navigation tabs
    final List<Widget> customerScreens = [
      CustomerHomeScreen(onNavigateToMenu: _navigateToMenu),
      const CustomerMenuScreen(),
      const CustomerCartScreen(),
      CustomerAccountScreen(
        onToggleAdmin: () {
          setState(() {
            _isAdminView = true;
          });
        },
      ),
    ];

    return ListenableBuilder(
      listenable: restaurantState,
      builder: (context, _) {
        final cartCount = restaurantState.cart.fold(0, (sum, item) => sum + item.quantity);

        return Scaffold(
          body: customerScreens[_selectedTabIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: CafeTheme.surface,
              border: Border(
                top: BorderSide(color: CafeTheme.primary.withOpacity(0.15)),
              ),
              boxShadow: CafeTheme.softShadow,
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedTabIndex,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: CafeTheme.surface,
              selectedItemColor: CafeTheme.primary,
              unselectedItemColor: CafeTheme.textMuted,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 11,
              ),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu_outlined),
                  activeIcon: Icon(Icons.restaurant_menu),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_bag_outlined),
                      if (cartCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: CafeTheme.accentRed,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$cartCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  activeIcon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_bag),
                      if (cartCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: CafeTheme.accentRed,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$cartCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: 'Cart',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
