import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'labeled_slider.dart';

void main() => runApp(const ConfiguratorApp());

class ConfiguratorApp extends StatelessWidget {
  const ConfiguratorApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    ),
    home: const ConfiguratorPage(),
  );
}

class ConfiguratorPage extends StatefulWidget {
  const ConfiguratorPage({super.key});
  @override
  State<ConfiguratorPage> createState() => _ConfiguratorPageState();
}

class _ConfiguratorPageState extends State<ConfiguratorPage> {
  double _width = 150;
  double _height = 150;
  double _radius = 0;
  double get _maxRadius => math.min(_width, _height) / 2;

  void _resize({double? width, double? height}) => setState(() {
    _width = width ?? _width;
    _height = height ?? _height;
    _radius = math.min(_radius, _maxRadius);
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Конфігуратор Container')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 280,
              child: Center(
                child: Container(
                  key: const ValueKey('preview'),
                  width: _width,
                  height: _height,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(_radius),
                    ),
                  ),
                ),
              ),
            ),
            LabeledSlider(
              label: 'Ширина',
              value: _width,
              min: 50,
              max: 260,
              onChanged: (v) => _resize(width: v),
            ),
            LabeledSlider(
              label: 'Висота',
              value: _height,
              min: 50,
              max: 260,
              onChanged: (v) => _resize(height: v),
            ),
            LabeledSlider(
              label: 'Радіус',
              value: _radius,
              min: 0,
              max: _maxRadius,
              onChanged: (v) => setState(() => _radius = v),
            ),
          ],
        ),
      ),
    ),
  );
}
