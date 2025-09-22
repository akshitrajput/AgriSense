import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/farm_data.dart';
import '../services/local_storage_service.dart'; // Required for migration

class FarmDataProvider with ChangeNotifier {
  Isar? _isar;
  FarmData? _farmData;
  bool _isLoading = true;

  FarmData? get farmData => _farmData;
  bool get isLoading => _isLoading;

  FarmDataProvider() {
    _initIsar();
  }

  Future<void> _initIsar() async {
    if (_isar?.isOpen == true) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [FarmDataSchema],
      directory: dir.path,
    );
    await loadFarmData();
  }

  Future<void> loadFarmData() async {
    if (_isar == null) await _initIsar();

    _farmData = await _isar!.farmDatas.where().findFirst();

    // One-time migration logic if no data is in Isar
    if (_farmData == null) {
      final oldData = await LocalStorageService.loadFarmData();
      if (oldData.isNotEmpty) {
        final migratedData = FarmData.fromMap(oldData);
        await updateFarmData(migratedData); // Use update to save and set state
        print("Successfully migrated data from SharedPreferences to Isar.");
        // Clear old data after successful migration
        await LocalStorageService.clearAllData();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateFarmData(FarmData dataToSave) async {
    if (_isar == null) return;

    await _isar!.writeTxn(() async {
      await _isar!.farmDatas.put(dataToSave);
    });

    // Update the in-memory copy and notify UI
    _farmData = dataToSave;
    notifyListeners();
  }

  Future<void> clearData() async {
    if (_isar == null) return;

    await _isar!.writeTxn(() async {
      await _isar!.farmDatas.clear();
    });
    _farmData = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _isar?.close();
    super.dispose();
  }
}
