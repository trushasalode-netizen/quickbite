import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/aesthetics.dart';
import '../config/app_config.dart';

class QrTableScreen extends StatefulWidget {
  const QrTableScreen({super.key});

  @override
  State<QrTableScreen> createState() => _QrTableScreenState();
}

class _QrTableScreenState extends State<QrTableScreen> {
  int _selectedTable = 1;
  String? _customBaseUrl;

  String get _qrUrl =>
      '${_customBaseUrl ?? AppConfig.baseUrl}/?table=$_selectedTable';

  @override
  Widget build(BuildContext context) {
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
              // How it works banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: CafeTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: CafeTheme.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline,
                        color: CafeTheme.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'How it works',
                            style: TextStyle(
                              color: CafeTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Georgia',
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Customer scans QR → browser opens → taps "Order Food" → selects their table → browses menu & orders.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => _showUrlEditDialog(context),
                            child: Text(
                              '🌐 ${AppConfig.baseUrl}',
                              style: const TextStyle(
                                color: CafeTheme.primary,
                                fontSize: 11,
                                fontFamily: 'monospace',
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showUrlEditDialog(context),
                      icon: const Icon(Icons.edit_outlined,
                          color: CafeTheme.primary, size: 18),
                      tooltip: 'Change URL',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Table number selector
              const Text(
                'Select table:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 46,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConfig.totalTables,
                  itemBuilder: (context, index) {
                    final tableNum = index + 1;
                    final isSelected = tableNum == _selectedTable;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTable = tableNum),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 10),
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? CafeTheme.primary
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected ? CafeTheme.primary : Colors.white24,
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
              const SizedBox(height: 28),

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
                          color: CafeTheme.primary.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Brand header
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.restaurant,
                                color: CafeTheme.primary, size: 20),
                            const SizedBox(width: 6),
                            const Text(
                              'QUICKBITE',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: CafeTheme.textDark,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Scan to view menu & order',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // QR Code
                        QrImageView(
                          data: _qrUrl,
                          version: QrVersions.auto,
                          size: 180,
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
                        const SizedBox(height: 18),

                        // Table badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 10),
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

                        // URL shown below QR + copy button
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: _qrUrl));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('URL copied to clipboard'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _qrUrl,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 9,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.copy,
                                  size: 12, color: Colors.grey[400]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Deploy instructions
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠️  Before printing QR codes:',
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '1. Deploy the app: flutter build web\n'
                      '2. Upload the /build/web folder to Vercel or Firebase Hosting\n'
                      '3. Tap the edit (✏️) icon above to update the URL\n'
                      '4. Then print & laminate these QR codes for each table',
                      style: TextStyle(color: Colors.white38, fontSize: 11, height: 1.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUrlEditDialog(BuildContext context) {
    final controller = TextEditingController(text: AppConfig.baseUrl);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CafeTheme.textDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Set Your App URL',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the public URL where your Flutter web app is deployed. This URL will be embedded in all QR codes.',
              style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 13),
              decoration: InputDecoration(
                hintText: 'https://your-app.vercel.app',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.07),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: CafeTheme.primary, width: 2),
                ),
                prefixIcon: const Icon(Icons.link, color: Colors.white38),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To deploy: run  flutter build web  then upload /build/web to Vercel.',
              style: TextStyle(color: Colors.white24, fontSize: 11),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            onPressed: () {
              final url = controller.text.trim();
              if (url.isNotEmpty) {
                setState(() {
                  _customBaseUrl = url.endsWith('/')
                      ? url.substring(0, url.length - 1)
                      : url;
                });
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CafeTheme.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Save & Preview'),
          ),
        ],
      ),
    );
  }

}
