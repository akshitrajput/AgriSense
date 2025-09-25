import 'package:agrisense/models/scan_record.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
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
    // It's good practice to get the Isar instance once.
    isar = Isar.getInstance()!;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar:
      CustomAppBar(title: localizations.scanHistory, hasBackButton: true),
      body: StreamBuilder<List<ScanRecord>>(
        // Use a StreamBuilder to listen for real-time changes in the database.
        // New scans will appear here automatically.
        stream: isar.scanRecords
            .where()
            .sortByScanDateDesc()
            .watch(fireImmediately: true),
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
                style:
                const TextStyle(fontSize: 16, color: AppTheme.subTextColor),
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
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf_rounded,
                      color: AppTheme.primaryColor, size: 36),
                  title: Text(record.diseaseName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      DateFormat.yMMMd().add_jm().format(record.scanDate)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  // **CHANGE:** The onTap action now opens the saved PDF file.
                  onTap: () {
                    if (record.reportPdfPath != null &&
                        record.reportPdfPath!.isNotEmpty) {
                      OpenFile.open(record.reportPdfPath);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text("PDF report not found for this scan.")),
                      );
                    }
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

