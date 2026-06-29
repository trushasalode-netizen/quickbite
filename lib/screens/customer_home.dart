import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/aesthetics.dart';
import '../widgets/weather_banner.dart';
import '../widgets/live_background.dart';

class CustomerHomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToMenu;

  const CustomerHomeScreen({super.key, required this.onNavigateToMenu});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MenuItem> _searchResults = [];
  bool _isSearching = false;

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final results = RestaurantState.menuItems.where((item) {
      return item.name.toLowerCase().contains(lowercaseQuery) ||
             item.category.toLowerCase().contains(lowercaseQuery) ||
             item.description.toLowerCase().contains(lowercaseQuery);
    }).toList();

    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    // Combo items from menu
    final comboBox = RestaurantState.menuItems.firstWhere((item) => item.id == 'combo_box');
    final comboFeast = RestaurantState.menuItems.firstWhere((item) => item.id == 'combo_feast');
    final comboBucket = RestaurantState.menuItems.firstWhere((item) => item.id == 'combo_bucket');

    final List<Map<String, String>> quotes = [
      {
        "text": "One cannot think well, love well, sleep well, if one has not dined well.",
        "author": "Virginia Woolf"
      },
      {
        "text": "After a good dinner one can forgive anybody, even one's own relations.",
        "author": "Oscar Wilde"
      },
      {
        "text": "People who love to eat are always the best people.",
        "author": "Julia Child"
      },
      {
        "text": "Food is national character. It's history. It's regional. It's everything.",
        "author": "QuickBite Chef"
      }
    ];

    final quote = quotes[DateTime.now().minute % quotes.length];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan & Have a QuickBite', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: CafeTheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              "Table ${restaurantState.currentTableNumber}",
              style: const TextStyle(
                color: CafeTheme.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                fontFamily: 'Georgia',
              ),
            ),
          ),
        ],
      ),
      body: LiveBackground(
        isDark: false,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── 1. INTERACTIVE SEARCH BAR ───
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search burgers, pizza, drinks...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),

                // Search Results Block
                if (_isSearching) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Search Results (${_searchResults.length})",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  _searchResults.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            "No items found matching your search.",
                            style: TextStyle(color: CafeTheme.textMuted),
                          ),
                        )
                      : SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              return _buildHorizontalItem(context, _searchResults[index], restaurantState);
                            },
                          ),
                        ),
                  const SizedBox(height: 12),
                ],

                // ─── Real-time Weather Banner ───
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: WeatherBanner(),
                ),

                // ─── 2. DYNAMIC SMART RECOMMENDATION SYSTEM PANEL ───
                ListenableBuilder(
                  listenable: restaurantState,
                  builder: (context, _) {
                    final recommended = restaurantState.getRecommendations();

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CafeTheme.primary.withOpacity(0.15),
                            CafeTheme.accentRed.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: CafeTheme.primary.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantState.greetingText,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            restaurantState.recommendationTitle,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          Text(
                            restaurantState.recommendationSubtitle,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),

                          // Horizontal List updates dynamically
                          SizedBox(
                            height: 135,
                            child: recommended.isEmpty
                                ? const Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: recommended.length,
                                    itemBuilder: (context, index) {
                                      final item = recommended[index];
                                      return _buildHorizontalItem(context, item, restaurantState);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // ─── 3. NEW EXCITING OFFERS ───
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('New Exciting Offers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                GestureDetector(
                  onTap: widget.onNavigateToMenu,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/burger.png'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: CafeTheme.softShadow,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Super Saver Lunch Deal: Flat 30% OFF',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ─── 4. MEAL COMBOS OPTIONS ───
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Best Meal Combos & Family Options', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 195,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    children: [
                      _buildComboCard(context, comboBox, restaurantState),
                      _buildComboCard(context, comboFeast, restaurantState),
                      _buildComboCard(context, comboBucket, restaurantState),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Culinary Quote block
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: CafeTheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: CafeTheme.primary.withOpacity(0.12)),
                    boxShadow: CafeTheme.softShadow,
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.format_quote_rounded,
                        color: CafeTheme.primary,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "\"${quote['text']}\"",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          color: CafeTheme.textDark,
                          height: 1.5,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "— ${quote['author']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: CafeTheme.textMuted,
                          letterSpacing: 1.0,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Horizontal Recommended Items list builder with Tap-to-Add action (₹ currency)
  Widget _buildHorizontalItem(BuildContext context, MenuItem item, RestaurantState state) {
    return GestureDetector(
      onTap: () {
        state.addToCart(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${item.name} added to cart"),
            duration: const Duration(seconds: 1),
            backgroundColor: CafeTheme.accentRed,
          ),
        );
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.white,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      item.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error2, stackTrace2) => Container(
                        color: CafeTheme.background,
                        child: const Icon(Icons.restaurant, color: CafeTheme.primary),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Georgia'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "₹${item.price.toStringAsFixed(0)}",
              style: const TextStyle(color: CafeTheme.accentRed, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
            ),
          ],
        ),
      ),
    );
  }

  // Combos Card builder with Tap-to-Add action (₹ currency)
  Widget _buildComboCard(BuildContext context, MenuItem item, RestaurantState state) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Georgia'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${item.price.toStringAsFixed(0)}",
                        style: const TextStyle(color: CafeTheme.accentRed, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Georgia'),
                      ),
                      GestureDetector(
                        onTap: () {
                          state.addToCart(item);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${item.name} added to cart"),
                              duration: const Duration(seconds: 1),
                              backgroundColor: CafeTheme.accentRed,
                            ),
                          );
                        },
                        child: const Icon(Icons.add_circle, color: CafeTheme.accentRed, size: 24),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
