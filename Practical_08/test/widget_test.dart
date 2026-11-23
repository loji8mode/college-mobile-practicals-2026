import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical08/main.dart';
import 'package:practical08/labeled_slider.dart';

void main() {
  Slider slider(WidgetTester t, String key) =>
      t.widget<Slider>(find.byKey(ValueKey(key)));
  BoxDecoration style(WidgetTester t) =>
      t
              .widget<Container>(
                find.byKey(const ValueKey('preview')),
              )
              .decoration!
          as BoxDecoration;

  testWidgets('Independent sizes, one corner, radius stays valid', (
    tester,
  ) async {
    await tester.pumpWidget(const ConfiguratorApp());
    final box = find.byKey(const ValueKey('preview'));
    expect(tester.getSize(box), const Size(150, 150));
    slider(tester, 'Ширина').onChanged!(220);
    await tester.pump();
    expect(tester.getSize(box), const Size(220, 150));
    slider(tester, 'Висота').onChanged!(100);
    await tester.pump();
    expect(tester.getSize(box), const Size(220, 100));
    slider(tester, 'Радіус').onChanged!(50);
    await tester.pump();
    expect(style(tester).color, Colors.red);
    expect(
      style(tester).borderRadius,
      const BorderRadius.only(topRight: Radius.circular(50)),
    );
    slider(tester, 'Ширина').onChanged!(60);
    await tester.pump();
    expect(slider(tester, 'Радіус').value, 30);
    expect(slider(tester, 'Радіус').max, 30);
    slider(tester, 'Висота').onChanged!(50);
    await tester.pump();
    expect(slider(tester, 'Радіус').value, 25);
    expect(
      style(tester).borderRadius,
      const BorderRadius.only(topRight: Radius.circular(25)),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'A real slider drag updates the preview immediately',
    (tester) async {
      await tester.pumpWidget(const ConfiguratorApp());
      await tester.drag(
        find.byKey(const ValueKey('Ширина')),
        const Offset(100, 0),
      );
      await tester.pump();
      expect(slider(tester, 'Ширина').value, greaterThan(150));
      expect(slider(tester, 'Висота').value, 150);
      expect(find.byType(LabeledSlider), findsNWidgets(3));
    },
  );

  for (final size in const [Size(320, 568), Size(568, 320)]) {
    testWidgets('Small screen scrolls without overflow: $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const ConfiguratorApp());
      await tester.ensureVisible(
        find.byKey(const ValueKey('Радіус')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
