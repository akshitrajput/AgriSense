import 'dart:io';
import 'package:agrisense/models/scan_record.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HealthReportScreen extends StatelessWidget {
  final ScanRecord report;

  const HealthReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    String severity = "Low";
    if (report.probability > 0.75) {
      severity = "High";
    } else if (report.probability > 0.4) {
      severity = "Medium";
    }

    bool isHealthy = report.diseaseName == "Healthy";

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.plantHealthReport,
        hasBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildDiseaseStatusCard(localizations, severity, isHealthy),
              const SizedBox(height: 16),
              _buildAnalysisDetailsCard(localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiseaseStatusCard(
      AppLocalizations localizations,
      String severity,
      bool isHealthy,
      ) {
    final color = isHealthy ? AppTheme.healthyColor : AppTheme.affectedColor;
    final title =
    isHealthy ? 'Plant is Healthy' : localizations.diseaseDetected;
    final icon = isHealthy
        ? Icons.check_circle_outline
        : Icons.warning_amber_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (!isHealthy)
                Text(
                  'Severity: $severity',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisDetailsCard(AppLocalizations localizations) {
    return Card(
      elevation: 2,
      shadowColor: AppTheme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(report.imagePath),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailText(
                    label: localizations.diagnosis,
                    value: report.diseaseName,
                  ),
                  const SizedBox(height: 8),
                  _DetailText(
                    label: "Confidence:",
                    value:
                    "${(report.probability * 100).toStringAsFixed(1)}%",
                  ),
                  const SizedBox(height: 8),
                  _DetailText(
                    label: localizations.recommendedAction,
                    value: "Further investigation needed.",
                  ),
                ],
              ),
            ),
          ],
        ),
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
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textColor,
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(color: AppTheme.subTextColor),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}