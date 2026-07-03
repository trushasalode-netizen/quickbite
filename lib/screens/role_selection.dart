import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/aesthetics.dart';
import '../widgets/live_background.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectCustomer() {
    _showTablePickerDialog();
  }

  void _selectKitchen() {
    _showKitchenPinDialog();
  }

  void _showTablePickerDialog() {
    final state = InheritedRestaurantState.of(context);
    int selectedTable = state.currentTableNumber;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: CafeTheme.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CafeTheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.table_restaurant,
                    color: CafeTheme.primary, size: 32),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose Your Table',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: CafeTheme.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Select the number shown on your table.',
                style: TextStyle(
                    color: CafeTheme.textMuted,
                    fontSize: 13,
                    fontFamily: 'Georgia'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(10, (index) {
              final tableNum = index + 1;
              final isSelected = tableNum == selectedTable;
              return GestureDetector(
                onTap: () => setDialogState(() => selectedTable = tableNum),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CafeTheme.primary
                        : CafeTheme.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? CafeTheme.primary
                          : CafeTheme.primary.withOpacity(0.3),
                      width: isSelected ? 2.5 : 1,
                    ),
                    boxShadow: isSelected ? CafeTheme.softShadow : null,
                  ),
                  child: Center(
                    child: Text(
                      '$tableNum',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: isSelected ? Colors.black : CafeTheme.textDark,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: CafeTheme.textMuted)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                final restaurantState = InheritedRestaurantState.of(context);
                restaurantState.updateTableNumber(selectedTable);
                restaurantState.setMode(AppMode.customer);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CafeTheme.primary,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Start Ordering',
                  style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  void _showKitchenPinDialog() {
    final pinController = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: CafeTheme.textDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CafeTheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.restaurant_outlined,
                    color: CafeTheme.primary, size: 32),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kitchen Access',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Enter your kitchen PIN to continue.',
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontFamily: 'Georgia'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pinController,
                autofocus: true,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, letterSpacing: 6),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '• • • •',
                  hintStyle:
                      const TextStyle(color: Colors.white38, fontSize: 20),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.08),
                  counterText: '',
                  errorText: errorText,
                  errorStyle:
                      const TextStyle(color: CafeTheme.accentRed, fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: CafeTheme.primary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: CafeTheme.accentRed, width: 2),
                  ),
                ),
                onSubmitted: (_) => _verifyPin(ctx, pinController, setDialogState),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () =>
                  _verifyPin(ctx, pinController, setDialogState),
              style: ElevatedButton.styleFrom(
                backgroundColor: CafeTheme.primary,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Enter Kitchen',
                  style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyPin(
    BuildContext dialogCtx,
    TextEditingController pinController,
    StateSetter setDialogState,
  ) {
    const correctPin = '1234';
    if (pinController.text == correctPin) {
      Navigator.pop(dialogCtx);
      final restaurantState = InheritedRestaurantState.of(context);
      restaurantState.setMode(AppMode.admin);
      restaurantState.initSupabaseSync();
    } else {
      setDialogState(() {});
      pinController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect PIN. Please try again.'),
          backgroundColor: CafeTheme.accentRed,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiveBackground(
        isDark: true,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo / Brand
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CafeTheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: CafeTheme.primary.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.restaurant,
                          color: Colors.black, size: 44),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'QUICKBITE',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Scan. Order. Enjoy.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 14,
                        fontFamily: 'Georgia',
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Customer Button
                    _RoleCard(
                      icon: Icons.qr_code_scanner,
                      title: 'Order Food',
                      subtitle: 'Select your table number, browse the menu & place orders',
                      primaryColor: CafeTheme.primary,
                      onTap: _selectCustomer,
                    ),

                    const SizedBox(height: 16),

                    // Kitchen Button
                    _RoleCard(
                      icon: Icons.restaurant_outlined,
                      title: 'Kitchen Dashboard',
                      subtitle: 'Manage incoming orders & table requests',
                      primaryColor: const Color(0xFF4CAF50),
                      onTap: _selectKitchen,
                      isDark: true,
                    ),

                    const SizedBox(height: 48),

                    Text(
                      'Scan the QR at your table, tap Order Food,\nthen select your table number to begin.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 11,
                        fontFamily: 'Georgia',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final VoidCallback onTap;
  final bool isDark;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.onTap,
    this.isDark = false,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(24),
          transform: _hovered
              ? (Matrix4.identity()..scale(1.02))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: widget.isDark
                ? Colors.white.withOpacity(0.07)
                : Colors.white.withOpacity(0.93),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _hovered
                  ? widget.primaryColor
                  : widget.primaryColor.withOpacity(0.25),
              width: _hovered ? 2 : 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.25),
                      blurRadius: 24,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(widget.icon, color: widget.primaryColor, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: widget.isDark ? Colors.white : CafeTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.isDark
                            ? Colors.white54
                            : CafeTheme.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: widget.isDark
                    ? Colors.white38
                    : CafeTheme.primary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
