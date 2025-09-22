import 'package:agrisense/services/local_storage_service.dart';
import 'package:flutter/foundation.dart';

class FarmDataProvider with ChangeNotifier {
  Map<String, dynamic> _farmData = {};
  bool _isLoading = true;

  Map<String, dynamic> get farmData => _farmData;
  bool get isLoading => _isLoading;

  FarmDataProvider() {
    loadFarmData();
  }

  Future<void> loadFarmData() async {
    _farmData = await LocalStorageService.loadFarmData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateFarmData(Map<String, dynamic> newData) async {
    // Set loading state to TRUE before starting the save operation
    _isLoading = true;
    notifyListeners();

    _farmData = newData;
    await LocalStorageService.saveFarmData(newData);

    // Set loading state to FALSE after the save is complete
    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _farmData = {};
    _isLoading = true;
    LocalStorageService.clearAllData();
    notifyListeners();
  }
}