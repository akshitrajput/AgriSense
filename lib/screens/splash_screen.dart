import 'dart:async';
import 'package:agrisense/screens/dashboard_screen.dart';
import 'package:agrisense/screens/info_profile_screen.dart';
import 'package:agrisense/services/local_storage_service.dart'; // Import the new service
import 'package:agrisense/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // This timer triggers the fade-in animation
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isVisible = true);
    });

    _navigateToNextScreen();
  }

  /// Checks local storage via the service and navigates to the correct screen.
  Future<void> _navigateToNextScreen() async {
    // Wait for the animation to be visible
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Use the centralized service to check the onboarding status
    final bool hasOnboarded = await LocalStorageService.isOnboardingComplete();

    if (hasOnboarded) {
      // User has already created an account, go to Dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      // New user, go to the InfoProfileScreen first
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const InfoProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
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

