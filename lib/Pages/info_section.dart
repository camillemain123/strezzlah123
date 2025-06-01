import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/alumni.jpg'),

        const SizedBox(height: 16),
        const Text(
          'The Depression, Anxiety and Stress Scale – 21 Items (DASS-21) is a self-report questionnaire designed to measure emotional states of depression, anxiety, and stress.',
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black87),
            children: [
              TextSpan(text: 'It is not a diagnostic instrument. '),
              TextSpan(
                text: 'Please consult a qualified healthcare professional if needed.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'How this tool helps:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.teal[700],
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        const BulletList([
          'Answer 21 simple questions about your experiences over the last week.',
          'Instantly receive scores for Depression, Anxiety, and Stress.',
          'Get personalized AI-generated feedback and insights.',
        ]),
        const SizedBox(height: 16),
        Image.asset('assets/images/student.jpg')
,
      ],
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 20)),
                    Expanded(child: Text(item)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
