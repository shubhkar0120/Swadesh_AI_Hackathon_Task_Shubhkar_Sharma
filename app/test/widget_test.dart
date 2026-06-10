import 'package:flutter_test/flutter_test.dart';
import 'package:swadesh_ai_hackathon/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const QuickSlotApp());
    // Just verify the app can render
    expect(find.text('QuickSlot'), findsOneWidget);
  });
}
