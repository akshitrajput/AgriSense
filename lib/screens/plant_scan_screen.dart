import 'package:agrisense/screens/health_report_screen.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class PlantScanScreen extends StatelessWidget {
  const PlantScanScreen({super.key});

  void _navigateToReport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HealthReportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: localizations.plantHealthScan, hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 2,
          shadowColor: AppTheme.primaryColor.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _navigateToReport(context),
                    highlightColor: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.backgroundColor,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 50,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations.scanWithCamera,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(localizations.or, style: const TextStyle(color: AppTheme.subTextColor)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _navigateToReport(context),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(localizations.uploadFromStorage),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.borderColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}