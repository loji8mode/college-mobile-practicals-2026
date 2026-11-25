import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:practical15/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android counter increments from zero to five', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    for (var expected = 1; expected <= 5; expected++) {
      await tester.tap(find.byKey(const ValueKey('increment')));
      await tester.pumpAndSettle();
      expect(find.text(expected.toString()), findsOneWidget);
    }
  });
}
