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
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatusAndNavigate();
  }

  Future<void> _checkLoginStatusAndNavigate() async {
    // Wait for the splash screen's minimum duration
    await Future.delayed(const Duration(seconds: 3));

    // Access the provider. We use `read` as this is a one-time action inside initState.
    final farmDataProvider = context.read<FarmDataProvider>();

    // If the provider is still loading data from the database, wait for it.
    // This is crucial to prevent navigating before the login status is known.
    while (farmDataProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // This check must happen after the widget is built and still mounted.
    if (!mounted) return;

    // The single source of truth: does farm data exist in the provider?
    final bool isLoggedIn = farmDataProvider.farmData != null;

    if (isLoggedIn) {
      // If data exists, the user is logged in. Go to the Dashboard.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (Route<dynamic> route) => false, // Clears all previous routes
      );
    } else {
      // If no data exists, start the full onboarding flow.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const InfoProfileScreen()),
            (Route<dynamic> route) => false, // Clears all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture_outlined, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'AgriSense',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
