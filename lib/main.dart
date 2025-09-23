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
          supportedLocales: const [
            Locale('en', ''),
            Locale('hi', ''),
            Locale('ta', ''),
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