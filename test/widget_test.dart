import 'package:flutter_test/flutter_test.dart';
import 'package:fiction_screen/main.dart';

void main() {
  testWidgets('FictionScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FictionScreenApp());
    expect(find.text('FictionScreen'), findsOneWidget);
  });
}
