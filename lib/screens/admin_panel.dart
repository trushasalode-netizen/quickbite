import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/aesthetics.dart';
import '../widgets/live_background.dart';
import 'qr_table_screen.dart';

class AdminPanelScreen extends StatelessWidget {
  final VoidCallback onToggleCustomerView;
  const AdminPanelScreen({super.key, required this.onToggleCustomerView});

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    return ListenableBuilder(
      listenable: restaurantState,
      builder: (context, _) {
        final allOrdersMap = restaurantState.placedOrders;
        final activeTables = allOrdersMap.keys
            .where((k) => allOrdersMap[k]!.isNotEmpty)
            .toList();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: CafeTheme.textDark,
            elevation: 0,
            title: const Text(
              "Kitchen Dashboard",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              // QR Table Generator button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QrTableScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.qr_code, color: CafeTheme.primary),
                  label: const Text(
                    "Table QR",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: TextButton.icon(
                  onPressed: onToggleCustomerView,
                  icon: const Icon(Icons.shopping_bag_outlined, color: CafeTheme.primary),
                  label: const Text(
                    "Customer View",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: LiveBackground(
            isDark: true,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard Stats Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Live Table Orders",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Georgia',
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Manage active kitchen tickets & mark status.",
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: CafeTheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: CafeTheme.primary.withOpacity(0.5)),
                          ),
                          child: Text(
                            "Active Tables: ${activeTables.length}",
                            style: const TextStyle(
                              color: CafeTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // List of active table orders
                    Expanded(
                      child: activeTables.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.room_service_outlined,
                                    color: Colors.white24,
                                    size: 64,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "No active orders from any table.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Scan a table QR → Add items → Place Order to see it here.",
                                    style: TextStyle(color: Colors.white70, fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const QrTableScreen(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.qr_code_2),
                                    label: const Text("View Table QR Codes"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CafeTheme.primary,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: MediaQuery.of(context).size.width > 900
                                    ? 3
                                    : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.85,
                              ),
                              itemCount: activeTables.length,
                              itemBuilder: (context, index) {
                                final tableNum = activeTables[index];
                                final orders = allOrdersMap[tableNum]!;
                                return _buildTableOrderCard(context, restaurantState, tableNum, orders);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableOrderCard(
    BuildContext context,
    RestaurantState state,
    int tableNum,
    List<Order> orders,
  ) {
    bool hasUnprepared = orders.any((o) => o.status != OrderStatus.ready);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CafeTheme.textDark.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: CafeTheme.premiumShadow,
        border: Border.all(
          color: hasUnprepared ? CafeTheme.primary : CafeTheme.accentGreen.withOpacity(0.5),
          width: hasUnprepared ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: hasUnprepared ? CafeTheme.primary : CafeTheme.accentGreen,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: CafeTheme.softShadow,
                ),
                child: Text(
                  "TABLE $tableNum",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              Text(
                "${orders.length} tickets",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, idx) {
                final order = orders[idx];
                String statusLabel;
                Color labelColor;

                if (order.status == OrderStatus.pending) {
                  statusLabel = "Pending";
                  labelColor = CafeTheme.primary;
                } else if (order.status == OrderStatus.preparing) {
                  statusLabel = "Preparing";
                  labelColor = Colors.orange;
                } else {
                  statusLabel = "Ready";
                  labelColor = CafeTheme.accentGreen;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ticket #${order.id.substring(order.id.length - 5)}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: labelColor,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 12, thickness: 0.5, color: Colors.white24),
                      // List order items with network image thumbnail
                      ...order.items.map((ci) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.network(
                                          ci.item.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: CafeTheme.primary.withOpacity(0.3),
                                            child: const Icon(Icons.restaurant, color: Colors.white, size: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      ci.item.name,
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ],
                                ),
                                Text(
                                  "x${ci.quantity}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      if (order.status != OrderStatus.ready) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (order.status == OrderStatus.pending)
                              TextButton(
                                onPressed: () => state.updateOrderStatus(
                                  tableNum,
                                  order.id,
                                  OrderStatus.preparing,
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  minimumSize: Size.zero,
                                  backgroundColor: Colors.orange.withOpacity(0.2),
                                ),
                                child: const Text(
                                  "Prepare",
                                  style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            const SizedBox(width: 6),
                            TextButton(
                              onPressed: () => state.updateOrderStatus(
                                tableNum,
                                order.id,
                                OrderStatus.ready,
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: Size.zero,
                                backgroundColor: CafeTheme.accentGreen.withOpacity(0.2),
                              ),
                              child: const Text(
                                "Ready",
                                style: TextStyle(color: CafeTheme.accentGreen, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Action Button
          if (hasUnprepared)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  state.setTableOrdersReady(tableNum);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Table $tableNum notified: 'Order Ready, serving in few minutes!'"),
                      backgroundColor: CafeTheme.accentGreen,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CafeTheme.accentGreen,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.room_service_outlined, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "Order Ready - Serving to you",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CafeTheme.accentGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CafeTheme.accentGreen.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: CafeTheme.accentGreen, size: 16),
                  SizedBox(width: 6),
                  Text(
                    "All Tickets Served",
                    style: TextStyle(
                      color: CafeTheme.accentGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: 'Georgia',
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