import 'package:agrisense/models/farm_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FarmDataProvider with ChangeNotifier {
  FarmData _farmData = FarmData();
  bool _isLoading = true; // Added isLoading state
  bool _hasOnboarded = false;

  FarmData get farmData => _farmData;
  bool get isLoading => _isLoading;
  bool get hasOnboarded => _hasOnboarded;

  FarmDataProvider() {
    loadFarmData(); // Load data when the provider is created
  }

  Future<void> loadFarmData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? farmDataString = prefs.getString('farm_data');
    
    if (farmDataString != null) {
      _farmData = FarmData.fromMap(json.decode(farmDataString));
      _hasOnboarded = true; // If data exists, user has onboarded
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateFarmData(Map<String, dynamic> newData) async {
    _farmData = FarmData.fromMap(newData);
    _hasOnboarded = true;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('farm_data', json.encode(newData));
    await prefs.setBool('has_onboarded', true);
    
    notifyListeners();
  }

  Future<void> clearData() async {
    _farmData = FarmData();
    _hasOnboarded = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('farm_data');
    await prefs.remove('has_onboarded');
    
    notifyListeners();
  }
}