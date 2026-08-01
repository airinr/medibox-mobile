import 'package:flutter_test/flutter_test.dart';
import 'package:modibox/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediboxApp());
    expect(find.text('Medibox'), findsOneWidget);
  });
}
