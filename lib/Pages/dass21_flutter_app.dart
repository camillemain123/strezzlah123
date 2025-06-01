import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LandingPage();
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASS-21 Analyzer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Understanding the DASS-21',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            const Text(
              'The DASS-21 is a widely used self-report questionnaire designed to measure the three related negative emotional states of depression, anxiety, and stress.',
            ),
            const SizedBox(height: 10),
            const Text(
              'It is not a diagnostic instrument. If you have concerns about your mental health, please consult a healthcare professional.',
            ),
            const SizedBox(height: 20),
            const Text(
              'How this tool helps:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            const Text('- Answer 21 questions based on your experiences over the last week.'),
            const Text('- Instantly receive scores for Depression, Anxiety, and Stress.'),
            const Text('- Get AI-generated feedback and insights.'),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Ready to Check In?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  const Text('Take the DASS-21 survey and receive feedback.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SurveyPage()),
                    ),
                    child: const Text('Start Survey'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final List<String> questions = List.generate(21, (index) => 'Question ${index + 1}');
  final Map<int, int> responses = {};

  void _submit() {
    if (responses.length < 21) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all 21 questions.')),
      );
      return;
    }

    final score = responses.values.reduce((a, b) => a + b);
    final prompt = 'The user scored $score on the DASS-21. Provide feedback.';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(prompt: prompt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DASS-21 Survey')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          for (var i = 0; i < questions.length; i++)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(questions[i]),
                subtitle: Row(
                  children: List.generate(4, (value) {
                    return Row(
                      children: [
                        Radio<int>(
                          value: value,
                          groupValue: responses[i],
                          onChanged: (val) {
                            setState(() {
                              responses[i] = val!;
                            });
                          },
                        ),
                        Text('$value'),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String prompt;
  const ResultPage({super.key, required this.prompt});

  Future<String> generateFeedback(String prompt) async {
    const apiKey = 'YOUR_GEMINI_API_KEY';
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          return parts[0]['text'];
        }
      }
      throw Exception('Malformed Gemini response');
    } else {
      throw Exception('Gemini API Error: ${response.statusCode} ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Results')),
      body: FutureBuilder<String>(
        future: generateFeedback(prompt),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(snapshot.data ?? 'No feedback generated.'),
            );
          }
        },
      ),
    );
  }
}
