import 'package:flutter/material.dart';
import 'package:strezzlah/Pages/login_page.dart';
import 'package:strezzlah/Pages/signup_page.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASS-21 Analyzer'),
        backgroundColor: Colors.teal[100],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupPage()),
              );
            },
            child: const Text("Sign Up"),
          ),
        ],
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
              'The Depression, Anxiety and Stress Scale - 21 Items (DASS-21) is a widely used self-report questionnaire...'
              '\n\nIt is not a diagnostic instrument. If you have concerns about your scores, consult a healthcare professional.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'How this tool helps:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text("Answer 21 questions about your experiences over the last week."),
            ),
            const ListTile(
              leading: Icon(Icons.flash_on),
              title: Text("Instantly receive scores for Depression, Anxiety, and Stress."),
            ),
            const ListTile(
              leading: Icon(Icons.smart_toy_outlined),
              title: Text("Get personalized AI-generated feedback and insights."),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Ready to Check In?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Take the DASS-21 survey to understand your emotional state. Log in or create an account to receive personalized feedback.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: const Text('Login'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignupPage()),
                            );
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
