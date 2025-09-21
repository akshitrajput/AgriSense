import 'dart:io'; // Required for using the File class
import 'package:agrisense/screens/health_report_screen.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart'; // Import the package
import '../l10n/app_localizations.dart';

// Convert to a StatefulWidget to manage the state of the picked image
class PlantScanScreen extends StatefulWidget {
  const PlantScanScreen({super.key});

  @override
  State<PlantScanScreen> createState() => _PlantScanScreenState();
}

class _PlantScanScreenState extends State<PlantScanScreen> {
  // State variable to hold the image file after picking
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // --- Method to handle taking a new photo ---
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // After picking, navigate to the report screen
      _navigateToReport();
    }
  }

  // --- Method to handle picking an image from the gallery ---
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // After picking, navigate to the report screen
      _navigateToReport();
    }
  }

  // Navigation logic
  void _navigateToReport() {
    // TODO: Pass the _imageFile to the HealthReportScreen to display it
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HealthReportScreen()),
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
                    // Call the camera method on tap
                    onTap: _pickImageFromCamera,
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
                        child: Text(
                          localizations.or,
                          style: const TextStyle(color: AppTheme.subTextColor),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  // Call the gallery method on press
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(localizations.uploadFromStorage),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
