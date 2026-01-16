import 'package:flutter_test/flutter_test.dart';
import 'package:pawpal_app/main.dart';

void main() {
  testWidgets('PawPal app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login screen is shown
    expect(find.text('🐾 PawPal'), findsOneWidget);
  });
}
