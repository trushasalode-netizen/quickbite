import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/main.dart';

void main() {
  testWidgets('QuickBite App Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuickBiteApp());

    // Verify that the title 'QuickBite' appears on the screen.
    expect(find.text('QuickBite'), findsOneWidget);
  });
}
