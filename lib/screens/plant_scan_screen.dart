import 'dart:io';
import 'package:agrisense/models/scan_record.dart';
import 'package:agrisense/screens/health_report_screen.dart';
import 'package:agrisense/services/api_service.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import '../l10n/app_localizations.dart';

class PlantScanScreen extends StatefulWidget {
  const PlantScanScreen({super.key});
  @override
  State<PlantScanScreen> createState() => _PlantScanScreenState();
}

class _PlantScanScreenState extends State<PlantScanScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  Future<void> _pickAndAnalyzeImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 70,
    );
    if (pickedFile == null) return;
    final File imageFile = File(pickedFile.path);

    setState(() => _isAnalyzing = true);

    try {
      final Map<String, dynamic> analysisResult =
      await ApiService.analyzePlant(imageFile);

      // **CHANGE 1:** Parse the new combined response structure from the backend.
      final kindwiseAnalysis = analysisResult['kindwise_analysis'];
      final pesticideRecommendation = analysisResult['pesticide_recommendation'];

      final suggestions =
      kindwiseAnalysis['result']?['disease']?['suggestions'];
      final isHealthy = (suggestions == null || suggestions.isEmpty);

      // Create the record for the local database. Note: The recommendation is not saved here.
      final newRecord = ScanRecord()
        ..imagePath = imageFile.path
        ..scanDate = DateTime.now()
        ..diseaseName =
        isHealthy ? "Healthy" : (suggestions[0]['name'] ?? 'Unknown Disease')
        ..probability =
        isHealthy ? 1.0 : (suggestions[0]['probability'] ?? 0.0);

      final isar = Isar.getInstance()!;
      await isar.writeTxn(() async {
        await isar.scanRecords.put(newRecord);
      });

      if (mounted) {
        // **CHANGE 2:** Pass both the database record AND the new recommendation
        // to the HealthReportScreen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HealthReportScreen(
              report: newRecord,
              recommendation: pesticideRecommendation,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.affectedColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.plantHealthScan,
        hasBackButton: true,
      ),
      body: _isAnalyzing
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.primaryColor),
            const SizedBox(height: 20),
            Text(
              'Analyzing Plant...',
              style:
              TextStyle(fontSize: 16, color: AppTheme.subTextColor),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shadowColor: AppTheme.primaryColor.withOpacity(0.2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _pickAndAnalyzeImage(ImageSource.camera),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.backgroundColor,
                          child: Icon(Icons.camera_alt_outlined,
                              size: 50, color: AppTheme.primaryColor),
                        ),
                        const SizedBox(height: 16),
                        Text(localizations.scanWithCamera,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
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
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(localizations.or,
                            style: const TextStyle(
                                color: AppTheme.subTextColor)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () =>
                      _pickAndAnalyzeImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(localizations.uploadFromStorage),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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