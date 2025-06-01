import 'package:flutter/material.dart';
import 'package:strezzlah/Pages/dass21_flutter_app.dart';
import 'package:strezzlah/screen/intro_screen.dart';
import 'package:strezzlah/Pages/login_page.dart';
import 'package:strezzlah/Pages/signup_page.dart';


void main() {
  const apiBaseUrl = 'http://localhost:52158'; // Updated port number
  runApp(DASS21AnalyzerApp(apiBaseUrl: apiBaseUrl));
}

class DASS21AnalyzerApp extends StatelessWidget {
  final String apiBaseUrl;
  const DASS21AnalyzerApp({super.key, required this.apiBaseUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DASS-21 Analyzer',
      theme: ThemeData(
        fontFamily: 'Helvetica',
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFEAF6F9),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/dass21': (context) => const MyApp(),
      },
    );
  }
}
