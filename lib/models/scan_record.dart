import 'package:isar/isar.dart';

part 'scan_record.g.dart'; // This will be generated

@collection
class ScanRecord {
  Id id = Isar.autoIncrement; // Isar's auto-incrementing ID

  // The path to the image that was scanned
  late String imagePath;

  @Index() // We can sort or filter by date
  late DateTime scanDate;

  // Data from the API response
  late String diseaseName;
  late double probability;
}