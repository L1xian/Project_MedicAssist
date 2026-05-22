import 'package:flutter/material.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'dart:math' as math;

class WeeklyActivityChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  
  const WeeklyActivityChart({
    super.key,
    required this.values,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (index) {
        return _Bar(
          height: values[index],
          label: labels[index],
          isActive: index == values.length - 1,
        );
      }),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final bool isActive;
  const _Bar({required this.height, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 100 * height,
          width: 30,
          decoration: BoxDecoration(
            color: isActive ? AppPallete.gradient1 : AppPallete.gradient1.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppPallete.gradient1 : AppPallete.darkGreyColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
