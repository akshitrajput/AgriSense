import 'package:agrisense/screens/health_report_screen.dart';
import 'package:agrisense/widgets/bottom_nav_buttons.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';

class PlantScanScreen extends StatelessWidget {
  const PlantScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Plant Health Scan', hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: () {
                    // Simulate scan and navigate to report
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HealthReportScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: AppTheme.backgroundColor,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 60,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Tap to focus & capture plant image',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Or, awaiting Rover capture...',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: AppTheme.subTextColor),
                          ),
                          SizedBox(height: 16),
                          CircularProgressIndicator(color: AppTheme.accentColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const BottomNavButtons(),
          ],
        ),
      ),
    );
  }
}