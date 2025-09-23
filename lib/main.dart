import 'package:agrisense/models/scan_record.dart';
import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/providers/language_provider.dart';
import 'package:agrisense/screens/splash_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open(
    [ScanRecordSchema],
    directory: dir.path,
  );

  final prefs = await SharedPreferences.getInstance();
  final String? languageCode = prefs.getString('language_code');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider(languageCode)),
        ChangeNotifierProvider(create: (context) => FarmDataProvider()),
      ],
      child: const AgriSenseApp(),
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
          title: 'AgriSense',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          locale: languageProvider.appLocale,
          // CHANGE: Added all 14 supported languages
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('hi', ''), // Hindi
            Locale('ta', ''), // Tamil
            Locale('bn', ''), // Bengali
            Locale('te', ''), // Telugu
            Locale('mr', ''), // Marathi
            Locale('ur', ''), // Urdu
            Locale('gu', ''), // Gujarati
            Locale('kn', ''), // Kannada
            Locale('or', ''), // Odia
            Locale('ml', ''), // Malayalam
            Locale('pa', ''), // Punjabi
            Locale('as', ''), // Assamese
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}