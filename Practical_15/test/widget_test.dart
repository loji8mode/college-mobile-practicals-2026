import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical15/main.dart' as app;

void main() {
  testWidgets('Title follows the group and name template', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text("32-IST: Valentyn's last Flutter App"), findsOneWidget);
  });
  testWidgets('Floating action button contains person icon', (tester) async {
    await tester.pumpWidget(const app.MyApp());
    expect(
      find.widgetWithIcon(FloatingActionButton, Icons.person),
      findsOneWidget,
    );
  });
  testWidgets('Every tap increments by exactly one', (tester) async {
    await tester.pumpWidget(const app.MyApp());
    expect(find.text('0'), findsOneWidget);
    for (var expected = 1; expected <= 5; expected++) {
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.text(expected.toString()), findsOneWidget);
      expect(find.text((expected - 1).toString()), findsNothing);
    }
  });
}
