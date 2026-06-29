import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/aesthetics.dart';
import '../models/restaurant.dart';

class QrTableScreen extends StatefulWidget {
  const QrTableScreen({super.key});

  @override
  State<QrTableScreen> createState() => _QrTableScreenState();
}

class _QrTableScreenState extends State<QrTableScreen> {
  int _selectedTable = 1;
  final int _totalTables = 10;

  @override
  Widget build(BuildContext context) {
    // The QR encodes the Web URL for the deployed Vercel app.
    final qrData = 'https://my-quickbite.vercel.app/?table=$_selectedTable';

    return Scaffold(
      backgroundColor: CafeTheme.textDark,
      appBar: AppBar(
        backgroundColor: CafeTheme.textDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Table QR Codes',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select a table to view its QR code.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Table selector chips
              SizedBox(
                height: 46,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _totalTables,
                  itemBuilder: (context, index) {
                    final tableNum = index + 1;
                    final isSelected = tableNum == _selectedTable;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTable = tableNum;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 10),
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isSelected ? CafeTheme.primary : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? CafeTheme.primary : Colors.white24,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$tableNum',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // QR Code Card
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: CafeTheme.primary.withOpacity(0.25),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Restaurant name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.restaurant, color: CafeTheme.primary, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              'QUICKBITE',
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: CafeTheme.textDark,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Scan to order from',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                        const SizedBox(height: 20),

                        // QR Code widget
                        QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 160,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: CafeTheme.textDark,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: CafeTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Table number badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: CafeTheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'TABLE $_selectedTable',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Georgia',
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          qrData,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }


}
