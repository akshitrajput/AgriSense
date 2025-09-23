import 'dart:io';
import 'package:agrisense/models/scan_record.dart';
import 'package:agrisense/screens/health_report_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final Isar isar;

  @override
  void initState() {
    super.initState();
    isar = Isar.getInstance()!;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: localizations.scanHistory, hasBackButton: true),
      body: StreamBuilder<List<ScanRecord>>(
        stream: isar.scanRecords.where().sortByScanDateDesc().watch(fireImmediately: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                localizations.noHistoryRecords,
                style: const TextStyle(fontSize: 16, color: AppTheme.subTextColor),
              ),
            );
          }

          final records = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(record.imagePath),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        width: 50, height: 50, color: AppTheme.borderColor,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                  title: Text(record.diseaseName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat.yMMMd().format(record.scanDate)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HealthReportScreen(report: record))
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}