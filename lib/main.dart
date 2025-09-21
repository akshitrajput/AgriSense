import 'package:flutter/material.dart';
import 'package:agrisense/screens/onboarding_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(
    // Wrap your app with the DevicePreview widget
    DevicePreview(
      // Enable it only in debug mode
      enabled: !kReleaseMode,
      builder: (context) => const AgriSenseApp(),
    ),
  );
}

class AgriSenseApp extends StatelessWidget {
  const AgriSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Add these lines to connect Device Preview
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      title: 'AgriSense',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}