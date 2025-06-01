import 'package:flutter/material.dart';
import 'package:strezzlah/Pages/header_section.dart';
import 'package:strezzlah/Pages/info_section.dart';
import 'package:strezzlah/Pages/login_prompt.dart';
import 'package:strezzlah/Pages/login_page.dart';
import 'package:strezzlah/Pages/signup_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.apiBaseUrl});

  final String apiBaseUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASS-21 Analyzer'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: const Text('Login', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupPage()),
              );
            },
            child: const Text('Sign Up', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HeaderSection(),
            SizedBox(height: 20),
            InfoSection(),
            SizedBox(height: 30),
            LoginPrompt(),
          ],
        ),
      ),
    );
  }
}
