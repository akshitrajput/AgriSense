import 'dart:async';
import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/screens/info_profile_screen.dart';
import 'package:agrisense/screens/main_screen.dart';
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
    // Wait for a minimum splash duration for a good user experience
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      final farmDataProvider = context.read<FarmDataProvider>();

      // This loop waits until the provider has finished loading its initial data
      while (farmDataProvider.isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Now that we are sure the data has been loaded, we can safely check the flag
      if (farmDataProvider.hasOnboarded) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
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
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.agriculture,
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