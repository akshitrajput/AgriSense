import 'dart:io';
import 'package:agrisense/models/health_report.dart'; // <-- IMPORT the central model
import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

// The UI for displaying the report, now a StatelessWidget
class HealthReportScreen extends StatelessWidget {
  // This 'report' variable is now of the correct, centralized type.
  final HealthReport report;

  const HealthReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: localizations.plantHealthReport, hasBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildDiseaseStatusCard(context),
            const SizedBox(height: 20),
            _buildAnalysisDetailsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: AppTheme.affectedColor, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(report.diagnosis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Severity: ${report.severity}', style: const TextStyle(fontSize: 14, color: Colors.white70)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildAnalysisDetailsCard(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(localizations.analysisDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: report.imagePath != null
                  ? Image.file(File(report.imagePath!), width: 100, height: 100, fit: BoxFit.cover)
                  : Container(
                width: 100,
                height: 100,
                color: AppTheme.borderColor.withOpacity(0.5),
                child: const Icon(Icons.image, color: AppTheme.subTextColor, size: 40),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _DetailText(label: '${localizations.diagnosis}:', value: report.diagnosis),
                const SizedBox(height: 8),
                _DetailText(label: '${localizations.affectedArea}:', value: report.affectedArea),
                const SizedBox(height: 8),
                _DetailText(label: '${localizations.recommendedAction}:', value: report.recommendedAction),
              ]),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _DetailText extends StatelessWidget {
  final String label;
  final String value;
  const _DetailText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: AppTheme.textColor, height: 1.4),
        children: [
          TextSpan(text: '$label ', style: const TextStyle(color: AppTheme.subTextColor)),
          TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
