import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color
          ),
        ),

        const SizedBox(width: 4),

        Text(text, style: const TextStyle(fontWeight: FontWeight.w500))
      ],
    );
  }
}