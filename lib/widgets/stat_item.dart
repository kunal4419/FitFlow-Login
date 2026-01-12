import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String title;
  final String value;

  const StatItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(title, style: TextStyle(color: Color(0xFFa1a1aa))),
      ],
    );
  }
}
