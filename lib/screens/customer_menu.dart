import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/aesthetics.dart';
import '../widgets/food_card.dart';
import '../widgets/live_background.dart';

class CustomerMenuScreen extends StatefulWidget {
  const CustomerMenuScreen({super.key});

  @override
  State<CustomerMenuScreen> createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> {
  final List<String> _categories = ['Pizza', 'Burger', 'Beverages', 'Softies', 'Desserts'];
  String _selectedCategory = 'Pizza';

  // Icon and emoji data for each category shown in sidebar
  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Pizza':      return Icons.local_pizza;
      case 'Burger':     return Icons.lunch_dining;
      case 'Beverages':  return Icons.local_drink;
      case 'Softies':    return Icons.icecream;
      case 'Desserts':   return Icons.cake;
      default:           return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = RestaurantState.menuItems
        .where((item) => item.category == _selectedCategory)
        .toList();

    return Scaffold(
      body: LiveBackground(
        isDark: false,
        child: SafeArea(
          child: Row(
            children: [
              // ── Sidebar Navigation (Left Side) ── icon-based, no broken images ──
              Container(
                width: 80,
                decoration: BoxDecoration(
                  color: CafeTheme.surface.withOpacity(0.95),
                  border: Border(
                    right: BorderSide(color: CafeTheme.primary.withOpacity(0.2)),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? CafeTheme.primary
                                  : CafeTheme.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isSelected ? CafeTheme.softShadow : null,
                              border: Border.all(
                                color: isSelected
                                    ? CafeTheme.primary
                                    : CafeTheme.primary.withOpacity(0.15),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                            ),
                            child: Icon(
                              _categoryIcon(category),
                              color: isSelected ? Colors.black : CafeTheme.textMuted,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            category,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
                              color: isSelected ? CafeTheme.textDark : CafeTheme.textMuted,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Content Area (Right Side)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _categoryIcon(_selectedCategory),
                                color: CafeTheme.primary,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedCategory,
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontFamily: 'Georgia',
                                  color: CafeTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: CafeTheme.accentRed.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${items.length} choices",
                              style: const TextStyle(
                                color: CafeTheme.accentRed,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Grid list of items
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount = constraints.maxWidth > 550 ? 3 : 2;
                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.72,
                              ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return FoodCard(item: items[index]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
