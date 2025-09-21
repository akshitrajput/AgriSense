import 'package:flutter/material.dart';

class FarmDataProvider with ChangeNotifier {
  Map<String, dynamic> _farmData = {};

  Map<String, dynamic> get farmData => _farmData;

  void updateFarmData(Map<String, dynamic> newData) {
    _farmData = newData;
    notifyListeners();
  }
}