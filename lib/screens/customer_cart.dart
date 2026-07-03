import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/aesthetics.dart';
import '../widgets/live_background.dart';

class CustomerCartScreen extends StatelessWidget {
  const CustomerCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantState = InheritedRestaurantState.of(context);

    return ListenableBuilder(
      listenable: restaurantState,
      builder: (context, _) {
        final cartItems = restaurantState.cart;
<<<<<<< HEAD
        final placedOrders =
            restaurantState.getOrdersForTable(restaurantState.currentTableNumber);
        final billRequested =
            restaurantState.isBillRequested(restaurantState.currentTableNumber);
=======
        final placedOrders = restaurantState.getOrdersForTable(restaurantState.currentTableNumber);
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1

        return Scaffold(
          body: LiveBackground(
            isDark: false,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      "Your Table Session",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: 'Georgia',
                        color: CafeTheme.textDark,
                      ),
                    ),
                    Text(
                      "Table ${restaurantState.currentTableNumber} • Active Orders & Cart",
                      style: const TextStyle(
                        color: CafeTheme.textMuted,
                        fontFamily: 'Georgia',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 1: Active Cart
                    _buildCartSection(context, restaurantState, cartItems),
                    const SizedBox(height: 24),

                    // Section 2: Kitchen Progress Status Tracker
                    _buildPlacedOrdersSection(context, restaurantState, placedOrders),
                    const SizedBox(height: 24),

                    // Section 3: Billing & Invoice Receipt (BK/KFC Styled receipt block)
                    if (placedOrders.isNotEmpty || cartItems.isNotEmpty)
<<<<<<< HEAD
                      _buildBillingSection(
                          context, restaurantState, placedOrders, billRequested),
=======
                      _buildBillingSection(context, restaurantState, placedOrders),
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1

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

  Widget _buildCartSection(
    BuildContext context,
    RestaurantState state,
    List<CartItem> items,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CafeTheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: CafeTheme.premiumShadow,
        border: Border.all(color: CafeTheme.primary.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current Cart",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Georgia',
                  color: CafeTheme.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CafeTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: CafeTheme.softShadow,
                ),
                child: Text(
                  "${items.length} pending",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Icon(Icons.shopping_bag_outlined, color: CafeTheme.primary, size: 48),
                  SizedBox(height: 12),
                  Text(
                    "Your cart is empty.\nGo to the Menu tab to add luxury treats!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CafeTheme.textMuted, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            )
          else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final cartItem = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      // Appetizing Image Thumbnail inside Cart
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: Image.network(
                            cartItem.item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              cartItem.item.imageAsset,
                              fit: BoxFit.cover,
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
                              cartItem.item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: CafeTheme.textDark,
                                fontFamily: 'Georgia',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "₹${cartItem.item.price.toStringAsFixed(0)} each",
                              style: const TextStyle(color: CafeTheme.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Plus/minus counts
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: CafeTheme.primary, size: 20),
                            onPressed: () => state.removeFromCart(cartItem.item),
                          ),
                          Text(
                            "${cartItem.quantity}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: CafeTheme.textDark,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: CafeTheme.primary, size: 20),
                            onPressed: () => state.addToCart(cartItem.item),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "₹${cartItem.totalPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: CafeTheme.textDark,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0x1B8C714B), height: 1),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  state.placeOrder();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Order sent to the kitchen!"),
                      backgroundColor: CafeTheme.accentGreen,
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_rounded, size: 18),
                    SizedBox(width: 8),
                    Text("Place Order to Kitchen"),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlacedOrdersSection(
    BuildContext context,
    RestaurantState state,
    List<Order> orders,
  ) {
    if (orders.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CafeTheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: CafeTheme.softShadow,
        border: Border.all(color: CafeTheme.primary.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kitchen Progress",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontFamily: 'Georgia',
              color: CafeTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              Color statusColor;
              String statusText;
              IconData statusIcon;

              switch (order.status) {
                case OrderStatus.pending:
                  statusColor = CafeTheme.primary;
                  statusText = "Received";
                  statusIcon = Icons.receipt_long;
                  break;
                case OrderStatus.preparing:
                  statusColor = Colors.orange;
                  statusText = "Preparing in Kitchen";
                  statusIcon = Icons.restaurant;
                  break;
                case OrderStatus.ready:
                  statusColor = CafeTheme.accentGreen;
                  statusText = "Serving to you in few minutes!";
                  statusIcon = Icons.room_service_outlined;
                  break;
<<<<<<< HEAD
                case OrderStatus.served:
                  statusColor = Colors.grey;
                  statusText = "Served";
                  statusIcon = Icons.check_circle_outline;
                  break;
=======
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CafeTheme.background.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order #${order.id.substring(order.id.length - 5)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CafeTheme.textDark,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(statusIcon, color: statusColor, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Items list
                    ...order.items.map((ci) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Image.network(
                                    ci.item.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                      ci.item.imageAsset,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${ci.item.name} x${ci.quantity}",
                                style: const TextStyle(
                                  color: CafeTheme.textDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              "Need more? Just add items in the Menu and place order again!",
              style: TextStyle(
                color: CafeTheme.textMuted,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingSection(
    BuildContext context,
    RestaurantState state,
    List<Order> orders,
<<<<<<< HEAD
    bool billRequested,
=======
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
  ) {
    final pendingTotal = state.cart.fold(0.0, (sum, cartItem) => sum + cartItem.totalPrice);
    final subtotal = state.getTableOrdersTotal(state.currentTableNumber) + pendingTotal;
    final tax = subtotal * 0.10;
    final serviceCharge = subtotal * 0.05;
    final grandTotal = subtotal + tax + serviceCharge;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F5), // Light warm parchment paper look
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: CafeTheme.primary, width: 2.0),
        boxShadow: CafeTheme.premiumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  "QUICKBITE BILLING",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Georgia',
                    letterSpacing: 3.0,
                    color: CafeTheme.textDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "Table ${state.currentTableNumber} • Consolidated Order Invoice",
                  style: const TextStyle(color: CafeTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Vintage dashed receipt line
          _buildDashedLine(),
          const SizedBox(height: 16),

          // consolidated list of items (placed + pending in cart)
          ...orders.expand((o) => o.items).map((ci) => _buildInvoiceItemRow(ci)),
          ...state.cart.map((ci) => _buildInvoiceItemRow(ci, isPending: true)),
          const SizedBox(height: 12),
          _buildDashedLine(),
          const SizedBox(height: 12),

          _buildReceiptRow("Subtotal", subtotal),
          _buildReceiptRow("Tax (10%)", tax),
          _buildReceiptRow("Service Charge (5%)", serviceCharge),
          const SizedBox(height: 8),
          _buildDashedLine(),
          const SizedBox(height: 12),

          // Total amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TOTAL AMOUNT",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: CafeTheme.textDark,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                "₹${grandTotal.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: CafeTheme.primary,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Status & Payment Button
<<<<<<< HEAD
          if (billRequested)
=======
          if (state.isBillPaid)
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
<<<<<<< HEAD
                color: CafeTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: CafeTheme.primary.withOpacity(0.4), width: 1.5),
=======
                color: CafeTheme.accentGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CafeTheme.accentGreen, width: 2.0),
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
<<<<<<< HEAD
                  Icon(Icons.hourglass_top_rounded,
                      color: CafeTheme.primary),
                  SizedBox(width: 8),
                  Text(
                    'Bill requested — Waiter coming to settle!',
                    style: TextStyle(
                      color: CafeTheme.primary,
=======
                  Icon(Icons.check_circle, color: CafeTheme.accentGreen),
                  SizedBox(width: 8),
                  Text(
                    "Paid & Settled. Thank you!",
                    style: TextStyle(
                      color: CafeTheme.accentGreen,
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              width: double.infinity,
<<<<<<< HEAD
              child: ElevatedButton.icon(
                onPressed: orders.isEmpty
                    ? null
                    : () async {
                        await state.requestBill(
                            state.currentTableNumber);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '💵 Bill requested! A waiter will come to settle your payment.'),
                              backgroundColor: CafeTheme.accentGreen,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                label: const Text('Request Bill & Pay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CafeTheme.textDark,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      CafeTheme.textDark.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
=======
              child: OutlinedButton(
                onPressed: () {
                  state.markBillAsPaid();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: CafeTheme.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      title: const Text(
                        "Payment Successful",
                        style: TextStyle(
                          color: CafeTheme.textDark,
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      content: const Text(
                        "Your transaction has been processed. The kitchen team has been notified. Thank you for dining at QuickBite!",
                        style: TextStyle(color: CafeTheme.textMuted),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            state.resetSession();
                          },
                          child: const Text(
                            "Done",
                            style: TextStyle(
                              color: CafeTheme.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, size: 18),
                    SizedBox(width: 8),
                    Text("Generate Bill & Pay"),
                  ],
>>>>>>> 0144f9cd9dd5d40fb5e548811681048cff3f63f1
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInvoiceItemRow(CartItem ci, {bool isPending = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: Image.network(
                    ci.item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      ci.item.imageAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${ci.item.name} x${ci.quantity}${isPending ? ' (Cart)' : ''}",
                style: TextStyle(
                  color: isPending ? CafeTheme.primary : CafeTheme.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            "₹${ci.totalPrice.toStringAsFixed(0)}",
            style: const TextStyle(
              color: CafeTheme.textDark,
              fontWeight: FontWeight.w900,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: CafeTheme.textMuted, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          Text(
            "₹${value.toStringAsFixed(0)}",
            style: const TextStyle(
              color: CafeTheme.textDark,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : CafeTheme.primary.withOpacity(0.4),
            height: 2,
          ),
        ),
      ),
    );
  }
}
