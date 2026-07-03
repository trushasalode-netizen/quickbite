import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/aesthetics.dart';
import '../widgets/live_background.dart';
import 'qr_table_screen.dart';

class AdminPanelScreen extends StatelessWidget {
<<<<<<< HEAD
  final VoidCallback onLogout;
  const AdminPanelScreen({super.key, required this.onLogout});
=======
  final VoidCallback onToggleCustomerView;
  const AdminPanelScreen({super.key, required this.onToggleCustomerView});
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    return ListenableBuilder(
      listenable: restaurantState,
      builder: (context, _) {
        final allOrdersMap = restaurantState.placedOrders;
<<<<<<< HEAD
        final waiterReqs = restaurantState.waiterRequests;
        final billReqs = restaurantState.billRequests;

        // Show a table card if it has orders OR any service request
        final activeTables = <int>{};
        for (int i = 1; i <= 10; i++) {
          final hasOrders = allOrdersMap[i]?.isNotEmpty ?? false;
          final hasWaiter = waiterReqs[i] ?? false;
          final hasBill = billReqs[i] ?? false;
          if (hasOrders || hasWaiter || hasBill) activeTables.add(i);
        }
        final sortedTables = activeTables.toList()..sort();
=======
        final activeTables = allOrdersMap.keys
            .where((k) => allOrdersMap[k]!.isNotEmpty)
            .toList();
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1

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
<<<<<<< HEAD
                padding: const EdgeInsets.symmetric(
                    horizontal: 4.0, vertical: 8.0),
=======
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
<<<<<<< HEAD
                          builder: (_) => const QrTableScreen()),
=======
                        builder: (_) => const QrTableScreen(),
                      ),
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                    );
                  },
                  icon: const Icon(Icons.qr_code, color: CafeTheme.primary),
                  label: const Text(
                    "Table QR",
<<<<<<< HEAD
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
=======
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
<<<<<<< HEAD
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              // Logout button
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 8.0),
                child: TextButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_rounded,
                      color: Colors.white70),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.06),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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
<<<<<<< HEAD
                    // Dashboard Header
=======
                    // Dashboard Stats Header
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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
<<<<<<< HEAD
                              "Manage kitchen tickets, waiter calls & bills.",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13),
=======
                              "Manage active kitchen tickets & mark status.",
                              style: TextStyle(color: Colors.white70, fontSize: 13),
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                            ),
                          ],
                        ),
                        Container(
<<<<<<< HEAD
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: CafeTheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: CafeTheme.primary.withOpacity(0.5)),
                          ),
                          child: Text(
                            "Active: ${sortedTables.length}",
=======
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: CafeTheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: CafeTheme.primary.withOpacity(0.5)),
                          ),
                          child: Text(
                            "Active Tables: ${activeTables.length}",
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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
<<<<<<< HEAD

                    // Grid of table order cards
                    Expanded(
                      child: sortedTables.isEmpty
=======
                    // List of active table orders
                    Expanded(
                      child: activeTables.isEmpty
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
<<<<<<< HEAD
                                  const Icon(Icons.room_service_outlined,
                                      color: Colors.white24, size: 64),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "No active orders or requests.",
=======
                                  const Icon(
                                    Icons.room_service_outlined,
                                    color: Colors.white24,
                                    size: 64,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "No active orders from any table.",
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
<<<<<<< HEAD
                                    "When customers scan their table QR and order, it will appear here.",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 13),
=======
                                    "Scan a table QR → Add items → Place Order to see it here.",
                                    style: TextStyle(color: Colors.white70, fontSize: 13),
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
<<<<<<< HEAD
                                            builder: (_) =>
                                                const QrTableScreen()),
                                      );
                                    },
                                    icon: const Icon(Icons.qr_code_2),
                                    label:
                                        const Text("View Table QR Codes"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CafeTheme.primary,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
<<<<<<< HEAD
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 900
                                        ? 3
                                        : (MediaQuery.of(context).size.width >
                                                600
                                            ? 2
                                            : 1),
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.78,
                              ),
                              itemCount: sortedTables.length,
                              itemBuilder: (context, index) {
                                final tableNum = sortedTables[index];
                                final orders = allOrdersMap[tableNum] ?? [];
                                final hasWaiter =
                                    waiterReqs[tableNum] ?? false;
                                final hasBill = billReqs[tableNum] ?? false;
                                return _buildTableCard(
                                  context,
                                  restaurantState,
                                  tableNum,
                                  orders,
                                  hasWaiter,
                                  hasBill,
                                );
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
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

<<<<<<< HEAD
  Widget _buildTableCard(
=======
  Widget _buildTableOrderCard(
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
    BuildContext context,
    RestaurantState state,
    int tableNum,
    List<Order> orders,
<<<<<<< HEAD
    bool hasWaiter,
    bool hasBill,
  ) {
    final hasUnprepared =
        orders.any((o) => o.status != OrderStatus.ready && o.status != OrderStatus.served);
    final total = state.getTableOrdersTotal(tableNum);

    // Alert priority: bill > waiter > orders pending
    Color borderColor;
    if (hasBill) {
      borderColor = CafeTheme.accentGreen;
    } else if (hasWaiter) {
      borderColor = CafeTheme.primary;
    } else if (hasUnprepared) {
      borderColor = CafeTheme.accentRed;
    } else {
      borderColor = CafeTheme.accentGreen.withOpacity(0.5);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CafeTheme.textDark.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: CafeTheme.premiumShadow,
        border: Border.all(color: borderColor, width: 2.0),
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          // Table header
=======
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
<<<<<<< HEAD
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: hasBill
                      ? CafeTheme.accentGreen
                      : hasWaiter
                          ? CafeTheme.primary
                          : hasUnprepared
                              ? CafeTheme.accentRed
                              : CafeTheme.accentGreen,
                  borderRadius: BorderRadius.circular(12),
=======
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: hasUnprepared ? CafeTheme.primary : CafeTheme.accentGreen,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: CafeTheme.softShadow,
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                ),
                child: Text(
                  "TABLE $tableNum",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
<<<<<<< HEAD
                    fontSize: 13,
=======
                    fontSize: 14,
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              Text(
<<<<<<< HEAD
                "${orders.length} ticket${orders.length == 1 ? '' : 's'}",
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── BILL REQUESTED ALERT ─────────────────────────────────────────
          if (hasBill)
            _buildAlertBanner(
              icon: Icons.receipt_long_rounded,
              label: "BILL REQUESTED",
              sublabel: "Grand Total: ₹${total.toStringAsFixed(0)}",
              color: CafeTheme.accentGreen,
              buttonLabel: "Settle & Clear Table",
              onAction: () async {
                await state.settleTable(tableNum);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Table $tableNum settled & cleared."),
                      backgroundColor: CafeTheme.accentGreen,
                    ),
                  );
                }
              },
            ),

          // ── WAITER CALLED ALERT ──────────────────────────────────────────
          if (hasWaiter && !hasBill)
            _buildAlertBanner(
              icon: Icons.notifications_active_rounded,
              label: "WAITER CALLED",
              sublabel: "Customer is requesting assistance.",
              color: CafeTheme.primary,
              buttonLabel: "Clear Alert",
              onAction: () => state.clearWaiterRequest(tableNum),
            ),

          // ── ORDER TICKETS ────────────────────────────────────────────────
          if (orders.isNotEmpty) ...[
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, idx) {
                  final order = orders[idx];
                  return _buildOrderTicket(context, state, tableNum, order);
                },
              ),
            ),
            const SizedBox(height: 8),

            // Mark All Ready button
            if (hasUnprepared && !hasBill)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await state.setTableOrdersReady(tableNum);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Table $tableNum — All orders marked ready!"),
                          backgroundColor: CafeTheme.accentGreen,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.room_service_outlined, size: 16),
                  label: const Text(
                    "Mark All Ready",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CafeTheme.accentGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              )
            else if (!hasUnprepared && !hasBill)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: CafeTheme.accentGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: CafeTheme.accentGreen.withOpacity(0.3)),
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
<<<<<<< HEAD
                    Icon(Icons.check_circle_outline,
                        color: CafeTheme.accentGreen, size: 16),
                    SizedBox(width: 6),
                    Text(
                      "All Tickets Served",
                      style: TextStyle(
                        color: CafeTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'Georgia',
                      ),
=======
                    Icon(Icons.room_service_outlined, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "Order Ready - Serving to you",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                    ),
                  ],
                ),
              ),
<<<<<<< HEAD
          ] else if (!hasWaiter && !hasBill)
            const Expanded(
              child: Center(
                child: Text(
                  "No orders yet.",
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertBanner({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required String buttonLabel,
    required VoidCallback onAction,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  fontFamily: 'Georgia',
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style:
                const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w900),
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTicket(
    BuildContext context,
    RestaurantState state,
    int tableNum,
    Order order,
  ) {
    String statusLabel;
    Color labelColor;

    switch (order.status) {
      case OrderStatus.pending:
        statusLabel = "Pending";
        labelColor = CafeTheme.accentRed;
        break;
      case OrderStatus.preparing:
        statusLabel = "Preparing";
        labelColor = Colors.orange;
        break;
      case OrderStatus.ready:
        statusLabel = "Ready ✓";
        labelColor = CafeTheme.accentGreen;
        break;
      case OrderStatus.served:
        statusLabel = "Served ✓";
        labelColor = Colors.white38;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
                "Ticket #${order.id.length >= 5 ? order.id.substring(order.id.length - 5) : order.id}",
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
          const Divider(height: 10, thickness: 0.5, color: Colors.white24),
          ...order.items.map(
            (ci) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
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
                            errorBuilder: (_, __, ___) => Container(
                              color: CafeTheme.primary.withOpacity(0.3),
                              child: const Icon(Icons.restaurant,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ci.item.name,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    "×${ci.quantity}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
=======
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
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                    ),
                  ),
                ],
              ),
            ),
<<<<<<< HEAD
          ),

          // Action buttons
          if (order.status != OrderStatus.ready &&
              order.status != OrderStatus.served) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.status == OrderStatus.pending)
                  TextButton(
                    onPressed: () => state.updateOrderStatus(
                        tableNum, order.id, OrderStatus.preparing),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      backgroundColor: Colors.orange.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Prepare",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: () => state.updateOrderStatus(
                      tableNum, order.id, OrderStatus.ready),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    backgroundColor:
                        CafeTheme.accentGreen.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Ready",
                    style: TextStyle(
                        color: CafeTheme.accentGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
=======
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
        ],
      ),
    );
  }
}