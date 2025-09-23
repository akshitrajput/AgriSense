import 'dart:async';
import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/screens/dashboard_screen.dart';
import 'package:agrisense/screens/info_profile_screen.dart'; // CHANGE: Import InfoProfileScreen
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
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // This allows the provider to load its data from storage first
    final farmDataProvider = context.read<FarmDataProvider>();
    
    // Wait until the provider is no longer in its initial loading state
    if (farmDataProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    // Add a minimum splash screen duration
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      if (farmDataProvider.hasOnboarded) {
        // If user has onboarded, go to Dashboard
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
      } else {
        // If it's a new user, go to InfoProfileScreen first
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InfoProfileScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco_outlined, size: 120, color: AppTheme.primaryColor),
            SizedBox(height: 24),
            Text('AgriSense', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
          ],
        ),
      ),
    );
  }
}