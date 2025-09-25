import 'dart:io';
import 'package:agrisense/models/scan_record.dart';
import 'package:agrisense/providers/language_provider.dart';
import 'package:agrisense/services/api_service.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

class PlantScanScreen extends StatefulWidget {
  final int? row;
  final int? col;

  const PlantScanScreen({super.key, this.row, this.col});
  @override
  State<PlantScanScreen> createState() => _PlantScanScreenState();
}

class _PlantScanScreenState extends State<PlantScanScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  Future<void> _pickAndAnalyzeImage(ImageSource source) async {
    final languageCode =
        Provider.of<LanguageProvider>(context, listen: false).appLocale.languageCode;

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
      final int row = widget.row ?? 0;
      final int col = widget.col ?? 0;

      final pdfBytes =
      await ApiService.analyzePlantAndGetPdf(imageFile, languageCode, row, col);

      // **CHANGE 1:** Save the PDF to a permanent app directory, not temporary.
      final appDir = await getApplicationDocumentsDirectory();
      final filePath =
          '${appDir.path}/AgriSense_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      final newRecord = ScanRecord()
        ..imagePath = imageFile.path
        ..scanDate = DateTime.now()
        ..diseaseName = "Analysis Report for Plant (${row + 1}, ${col + 1})"
        ..probability = 1.0 // Placeholder
        ..reportPdfPath = filePath;

      final isar = Isar.getInstance()!;
      await isar.writeTxn(() async {
        await isar.scanRecords.put(newRecord);
      });

      if (mounted) {
        // **CHANGE 2:** Show a success dialog instead of opening the file directly.
        _showSuccessDialog(filePath);
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

  // **CHANGE 3:** New method to show the success dialog with a "View Report" button.
  void _showSuccessDialog(String pdfPath) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Report Generated"),
          content: const Text(
              "Your plant health report has been successfully generated and saved to your history."),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text("View Report"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                OpenFile.open(pdfPath); // Then open the PDF
              },
            ),
          ],
        );
      },
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
      body: _isAnalyzing
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.primaryColor),
            const SizedBox(height: 20),
            Text(
              'Generating PDF Report...',
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

