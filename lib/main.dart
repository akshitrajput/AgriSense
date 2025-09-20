import 'package:flutter/material.dart';
import 'package:agrisense/screens/onboarding_screen.dart';
import 'package:agrisense/theme/app_theme.dart';

void main() {
  runApp(const AgriSenseApp());
}

class AgriSenseApp extends StatelessWidget {
  const AgriSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriSense',
      theme: AppTheme.lightTheme,
      // To add dark theme later, you can add:
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system, 
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}