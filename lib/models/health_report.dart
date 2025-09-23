import 'dart:io';

// This is the ONLY place this class should be defined.
class HealthReport {
  final String diagnosis;
  final String severity;
  final String affectedArea;
  final String recommendedAction;
  final String? imagePath; // Optional image path

  HealthReport({
    required this.diagnosis,
    required this.severity,
    required this.affectedArea,
    required this.recommendedAction,
    this.imagePath, // This is an optional parameter
  });
}
