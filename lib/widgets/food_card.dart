import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/aesthetics.dart';

class FoodCard extends StatelessWidget {
  final MenuItem item;
  final bool compact;

  const FoodCard({
    super.key,
    required this.item,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    if (compact) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CafeTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: CafeTheme.softShadow,
          border: Border.all(color: CafeTheme.primary.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    item.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: CafeTheme.background,
                      child: const Icon(Icons.restaurant, color: CafeTheme.primary),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CafeTheme.textDark,
                      fontFamily: 'Georgia',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "₹${item.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: CafeTheme.accentRed, // Popping Red Price tag
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                restaurantState.addToCart(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${item.name} added to cart"),
                    duration: const Duration(seconds: 1),
                    backgroundColor: CafeTheme.primary,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: CafeTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.black, size: 16),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CafeTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: CafeTheme.softShadow,
        border: Border.all(color: CafeTheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Food Picture (Unsplash Network -> Local Backup)
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        item.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: CafeTheme.background,
                          child: const Icon(Icons.restaurant, color: CafeTheme.primary, size: 32),
                        ),
                      ),
                    ),
                  ),
                ),
                // Floating red price tag pill (popping McDonald's style)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: CafeTheme.accentRed, // Vibrant Red
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: CafeTheme.softShadow,
                    ),
                    child: Text(
                      "₹${item.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 2. Title, Description, and Tactile '+' Button (McDonald's Kiosk style)
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: 'Georgia',
                          color: CafeTheme.textDark,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CafeTheme.textMuted,
                          fontSize: 10.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                // Tactile Kiosk '+' Button in Bottom-Right
                GestureDetector(
                  onTap: () {
                    restaurantState.addToCart(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${item.name} added to cart"),
                        duration: const Duration(seconds: 1),
                        backgroundColor: CafeTheme.accentRed,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CafeTheme.primary, // Yellow-Gold
                      shape: BoxShape.circle,
                      boxShadow: CafeTheme.softShadow,
                    ),
                    child: const Icon(Icons.add, color: Colors.black, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
