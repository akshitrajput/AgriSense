import 'dart:async';
import 'package:agrisense/screens/onboarding_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // A state variable to control the animation's visibility
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // This timer triggers the fade-in animation shortly after the screen builds
    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _isVisible = true;
      });
    });

    // This timer handles navigating to the next screen after a delay
    Timer(const Duration(seconds: 3), () {
      // Use pushReplacement to prevent the user from navigating back to the splash screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        // AnimatedOpacity provides a smooth fade-in effect
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.eco_outlined,
                size: 120,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 24),
              const Text(
                'AgriSense',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}