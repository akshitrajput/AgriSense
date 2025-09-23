import 'dart:io';
import 'dart:math'; // For generating random data
import 'package:agrisense/models/health_report.dart'; // <-- IMPORT the central model
import 'package:agrisense/screens/health_report_screen.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';

class PlantScanScreen extends StatefulWidget {
  const PlantScanScreen({super.key});
  @override
  State<PlantScanScreen> createState() => _PlantScanScreenState();
}

class _PlantScanScreenState extends State<PlantScanScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  /// Handles both camera and gallery image picking and analysis.
  Future<void> _pickAndAnalyzeImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() => _isAnalyzing = true);

      final imageFile = File(pickedFile.path);

      // 1. Simulate the analysis of the picked image
      // This now creates an instance of the correct HealthReport model.
      final HealthReport report = await _analyzeImage(imageFile);

      // 2. After analysis, navigate to the report screen with the results
      if (mounted) {
        setState(() => _isAnalyzing = false);
        _navigateToReport(report);
      }
    }
  }

  /// This function simulates an ML model analysis.
  Future<HealthReport> _analyzeImage(File imageFile) async {
    // Simulate a network call or heavy computation
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, you would send the imageFile to your model.
    // Here, we return random, hardcoded results for demonstration.
    final diagnoses = ['Fungal Leaf Blight', 'Bacterial Spot', 'Iron Deficiency'];
    final random = Random();

    return HealthReport(
      diagnosis: diagnoses[random.nextInt(diagnoses.length)],
      severity: 'High',
      affectedArea: '${random.nextInt(40) + 20}%',
      recommendedAction: 'Apply appropriate fungicide and monitor plant.',
      imagePath: imageFile.path, // Pass the actual image path
    );
  }

  /// Navigation logic now passes the correct HealthReport object.
  void _navigateToReport(HealthReport report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthReportScreen(report: report),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.plantHealthScan,
        hasBackButton: true,
      ),
      // Show a loading indicator while analyzing
      body: _isAnalyzing
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Analyzing Plant...',
              style: TextStyle(fontSize: 16, color: AppTheme.subTextColor),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickAndAnalyzeImage(ImageSource.camera),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(radius: 50, child: Icon(Icons.camera_alt_outlined, size: 50)),
                        const SizedBox(height: 16),
                        Text(localizations.scanWithCamera, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
                  onPressed: () => _pickAndAnalyzeImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(localizations.uploadFromStorage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
