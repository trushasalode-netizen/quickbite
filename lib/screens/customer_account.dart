import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/aesthetics.dart';
import '../widgets/live_background.dart';

class CustomerAccountScreen extends StatelessWidget {
  final VoidCallback onToggleAdmin;
  const CustomerAccountScreen({super.key, required this.onToggleAdmin});

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    return ListenableBuilder(
      listenable: restaurantState,
      builder: (context, _) {
        return Scaffold(
          body: LiveBackground(
            isDark: false,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      "My Account",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: 'Georgia',
                        color: CafeTheme.textDark,
                      ),
                    ),
                    Text(
                      "Table ${restaurantState.currentTableNumber} • Session info",
                      style: const TextStyle(
                        color: CafeTheme.textMuted,
                        fontFamily: 'Georgia',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Table selector card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CafeTheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: CafeTheme.softShadow,
                        border: Border.all(color: CafeTheme.primary.withOpacity(0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Your Table",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Georgia',
                              color: CafeTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Switch to a different table number:",
                            style: TextStyle(color: CafeTheme.textMuted, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(10, (index) {
                              final tableNum = index + 1;
                              final isSelected = tableNum == restaurantState.currentTableNumber;
                              return GestureDetector(
                                onTap: () => restaurantState.updateTableNumber(tableNum),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isSelected ? CafeTheme.primary : CafeTheme.background,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? CafeTheme.primary : CafeTheme.primary.withOpacity(0.3),
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$tableNum',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isSelected ? Colors.black : CafeTheme.textDark,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Session Summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CafeTheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: CafeTheme.softShadow,
                        border: Border.all(color: CafeTheme.primary.withOpacity(0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Session Summary",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Georgia',
                              color: CafeTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            context,
                            icon: Icons.receipt_long,
                            label: "Orders Placed",
                            value: "${restaurantState.getOrdersForTable(restaurantState.currentTableNumber).length}",
                          ),
                          _buildSummaryRow(
                            context,
                            icon: Icons.shopping_bag_outlined,
                            label: "Items in Cart",
                            value: "${restaurantState.cart.fold(0, (sum, item) => sum + item.quantity)}",
                          ),
                          _buildSummaryRow(
                            context,
                            icon: Icons.currency_rupee,
                            label: "Total Spent",
                            value: "₹${restaurantState.getTableOrdersTotal(restaurantState.currentTableNumber).toStringAsFixed(0)}",
                          ),
                          _buildSummaryRow(
                            context,
                            icon: Icons.check_circle_outline,
                            label: "Bill Status",
                            value: restaurantState.isBillPaid ? "Paid ✓" : "Unpaid",
                            valueColor: restaurantState.isBillPaid ? CafeTheme.accentGreen : CafeTheme.accentRed,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // App Info card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CafeTheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: CafeTheme.softShadow,
                        border: Border.all(color: CafeTheme.primary.withOpacity(0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "About QuickBite",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Georgia',
                              color: CafeTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "QuickBite is a smart QR-based table ordering system. Scan your table QR, browse the menu, and place orders directly from your phone. The kitchen gets notified instantly.",
                            style: TextStyle(color: CafeTheme.textMuted, fontSize: 13, height: 1.5),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.info_outline, color: CafeTheme.primary, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                "v1.0.0 • Weather-Powered Recommendations",
                                style: TextStyle(color: Colors.grey[500], fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Admin Toggle Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onToggleAdmin,
                        icon: const Icon(Icons.admin_panel_settings_outlined),
                        label: const Text("Switch to Kitchen/Admin View"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CafeTheme.textDark,
                          side: BorderSide(color: CafeTheme.primary.withOpacity(0.4)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: CafeTheme.primary, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: CafeTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: valueColor ?? CafeTheme.textDark,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }
}
