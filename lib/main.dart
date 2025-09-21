import 'package:agrisense/providers/language_provider.dart';
import 'package:agrisense/screens/onboarding_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? languageCode = prefs.getString('language_code');

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => LanguageProvider(languageCode),
        child: const AgriSenseApp(),
      ),
    ),
  );
}

class AgriSenseApp extends StatelessWidget {
  const AgriSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          // --- DevicePreview Settings ---
          useInheritedMediaQuery: true,
          // FIX: The duplicate 'locale' property was removed from here.
          builder: DevicePreview.appBuilder,
          // -----------------------------

          title: 'AgriSense',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,

          // --- Localization Settings ---
          locale: languageProvider.appLocale, // This is the single source of truth for the app's language.
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('hi', ''),
            Locale('ta', ''), // Hindi
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // ----------------------------

          home: const OnboardingScreen(),
        );  
      },
    );
  }
}