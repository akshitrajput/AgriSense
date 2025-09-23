import 'dart:async';
import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/screens/dashboard_screen.dart';
import 'package:agrisense/screens/info_profile_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for a fixed duration for the splash animation
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // Check the provider to see if the user has completed onboarding before
      final farmDataProvider = context.read<FarmDataProvider>();
      
      // The provider loads data in its constructor, we wait a moment for it to complete
      // in a real app you might have a more robust loading check.
      while (farmDataProvider.isLoading) {
        await Future.delayed(const Duration(milliseconds: 50));
      }

      if (farmDataProvider.hasOnboarded) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const InfoProfileScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Primary color background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CHANGE: Replaced Image.asset with a pre-built Icon
            const Icon(
              Icons.agriculture, // This is the tractor icon
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'AgriSense',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}