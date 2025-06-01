// screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:strezzlah/api/gemini_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String feedback = "Loading personalized feedback...";

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    try {
      final result = await generatePFeedback("User DASS-21 score: Depression = X, Anxiety = Y, Stress = Z");
      setState(() => feedback = result);
    } catch (e) {
      setState(() => feedback = "Failed to load feedback: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Results")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(feedback, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}