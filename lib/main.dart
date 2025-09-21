import 'package:agrisense/providers/language_provider.dart';
import 'package:agrisense/screens/onboarding_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart'; // Import device_preview
import 'package:flutter/foundation.dart'; // Import for kReleaseMode
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(
    // Wrap the entire app with the DevicePreview widget
    DevicePreview(
      enabled: !kReleaseMode, // Enable it only in debug mode
      builder: (context) => ChangeNotifierProvider(
        create: (context) => LanguageProvider(),
        child: const AgriSenseApp(),
      ),
    ),
  );
}

class AgriSenseApp extends StatelessWidget {
  const AgriSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the provider for language changes
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      // --- Add DevicePreview settings ---
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      // ----------------------------------

      title: 'AgriSense',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      // === Localization Settings Start ===
      // Note: The locale from DevicePreview will override this for testing
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('hi', ''), // Hindi
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // === Localization Settings End ===

      home: const OnboardingScreen(),
    );
  }
}