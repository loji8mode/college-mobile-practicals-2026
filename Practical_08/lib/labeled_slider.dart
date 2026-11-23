import 'package:flutter/material.dart';

class LabeledSlider extends StatelessWidget {
  const LabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('$label: ${value.toStringAsFixed(0)}'),
      Slider(
        key: ValueKey(label),
        value: value,
        min: min,
        max: max,
        divisions: (max - min).round(),
        label: value.toStringAsFixed(0),
        onChanged: onChanged,
      ),
    ],
  );
}
