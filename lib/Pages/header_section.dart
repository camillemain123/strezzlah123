import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Understanding the DASS-21',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.teal[800],
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
