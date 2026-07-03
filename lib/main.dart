import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

import 'theme/aesthetics.dart';
import 'models/restaurant.dart';
import 'screens/role_selection.dart';
import 'screens/customer_home.dart';
import 'screens/customer_menu.dart';
import 'screens/customer_cart.dart';
import 'screens/customer_account.dart';
import 'screens/admin_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jjzysssvhmfmdgbsnbqp.supabase.co',
    anonKey: 'sb_publishable_-FQdQ3sjd_tmMg5GLTE-qw_J_RIUCQb',
  );

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
    // Always start Supabase sync so real-time works for both roles
    _restaurantState.initSupabaseSync();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle deep links when app is already open
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });

    // Handle deep link when app is started from cold state
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (_) {}
  }

  void _handleDeepLink(Uri uri) {
    // Web URL: https://my-quickbite.vercel.app/?table=N
    // Only pre-select the table number — the customer still picks their
    // table manually via the Role Selection → "Order Food" → table picker flow.
    if (uri.queryParameters.containsKey('table')) {
      final tableNum = int.tryParse(uri.queryParameters['table']!);
      if (tableNum != null) {
        // Pre-fill the table picker with the scanned table number
        _restaurantState.updateTableNumber(tableNum);
        // Keep on roleSelection — customer must confirm their table
      }
    }

    // Android Deep Link: quickbite://table/N
    if (uri.scheme == 'quickbite' && uri.host == 'table') {
      if (uri.pathSegments.isNotEmpty) {
        final tableNum = int.tryParse(uri.pathSegments.first);
        if (tableNum != null) {
          _restaurantState.updateTableNumber(tableNum);
          // Keep on roleSelection — customer must confirm their table
        }
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

// ─── Main Navigation Wrapper ──────────────────────────────────────────────────
class AppNavigationWrapper extends StatelessWidget {
  const AppNavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    return ListenableBuilder(
      listenable: restaurantState,
      builder: (context, _) {
        switch (restaurantState.currentMode) {
          case AppMode.roleSelection:
            return const RoleSelectionScreen();
          case AppMode.admin:
            return AdminPanelScreen(
              onLogout: () => restaurantState.setMode(AppMode.roleSelection),
            );
          case AppMode.customer:
            return const CustomerNavigationWrapper();
        }
      },
    );
  }
}

// ─── Customer Navigation Wrapper ──────────────────────────────────────────────
class CustomerNavigationWrapper extends StatefulWidget {
  const CustomerNavigationWrapper({super.key});

  @override
  State<CustomerNavigationWrapper> createState() =>
      _CustomerNavigationWrapperState();
}

class _CustomerNavigationWrapperState
    extends State<CustomerNavigationWrapper> {
  int _selectedTabIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _navigateToMenu() {
    setState(() {
      _selectedTabIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    final List<Widget> customerScreens = [
      CustomerHomeScreen(onNavigateToMenu: _navigateToMenu),
      const CustomerMenuScreen(),
      const CustomerCartScreen(),
      const CustomerAccountScreen(),
    ];

    return ListenableBuilder(
      listenable: restaurantState,
      builder: (context, _) {
        final cartCount =
            restaurantState.cart.fold(0, (sum, item) => sum + item.quantity);

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
                  icon: _cartIcon(cartCount, false),
                  activeIcon: _cartIcon(cartCount, true),
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

  Widget _cartIcon(int count, bool active) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(active ? Icons.shopping_bag : Icons.shopping_bag_outlined),
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: CafeTheme.accentRed,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$count',
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
    );
  }
}
