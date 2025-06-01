import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(
            'Ready to Check In?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.teal[700]),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take the DASS-21 survey to understand your emotional state.\nLog in or create an account to save and track your results.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Login')),
              const SizedBox(width: 16),
              OutlinedButton(onPressed: () {}, child: const Text('Sign Up')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Your privacy is respected. Data for logged-in users is stored securely.',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
