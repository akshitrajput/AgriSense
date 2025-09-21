import 'package:agrisense/screens/health_report_screen.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';

class PlantScanScreen extends StatelessWidget {
  const PlantScanScreen({super.key});

  // Helper function to navigate to the report screen
  void _navigateToReport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HealthReportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Plant Health Scan', hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          // Manually applied card styling
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
                // Primary Action: Tap to capture
                Expanded(
                  child: InkWell(
                    onTap: () => _navigateToReport(context),
                    highlightColor: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.backgroundColor,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 50,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Scan with Camera',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

                // Divider
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR', style: TextStyle(color: AppTheme.subTextColor)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),

                // Secondary Action: Upload from storage
                OutlinedButton.icon(
                  // This onPressed callback handles the navigation
                  onPressed: () => _navigateToReport(context),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Upload from Storage'),
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