import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('Base Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const DentalCoreApp());
    expect(find.textContaining('DentalCore'), findsOneWidget);
  });
}
