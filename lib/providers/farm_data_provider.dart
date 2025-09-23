import 'package:agrisense/models/farm_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FarmDataProvider with ChangeNotifier {
  FarmData _farmData = FarmData();
  bool _isLoading = true;
  bool _hasOnboarded = false;

  // --- ADDED: State variables for rover controls ---
  bool _isRoverActive = false;
  bool _isSprinklerActive = false;

  // --- Getters for all properties ---
  FarmData get farmData => _farmData;
  bool get isLoading => _isLoading;
  bool get hasOnboarded => _hasOnboarded;
  bool get isRoverActive => _isRoverActive;
  bool get isSprinklerActive => _isSprinklerActive;

  FarmDataProvider() {
    loadFarmData();
  }

  Future<void> loadFarmData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? farmDataString = prefs.getString('farm_data');

    if (farmDataString != null) {
      _farmData = FarmData.fromMap(json.decode(farmDataString));
      _hasOnboarded = true;
    }

    // Load the last saved state for the toggles
    _isRoverActive = prefs.getBool('is_rover_active') ?? false;
    _isSprinklerActive = prefs.getBool('is_sprinkler_active') ?? false;

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

  // --- ADDED: Method to update rover state and save it ---
  Future<void> updateRoverState(bool isActive) async {
    _isRoverActive = isActive;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_rover_active', isActive);
    notifyListeners();
  }

  // --- ADDED: Method to update sprinkler state and save it ---
  Future<void> updateSprinklerState(bool isActive) async {
    _isSprinklerActive = isActive;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_sprinkler_active', isActive);
    notifyListeners();
  }

  Future<void> clearData() async {
    _farmData = FarmData();
    _hasOnboarded = false;
    _isRoverActive = false;
    _isSprinklerActive = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('farm_data');
    await prefs.remove('has_onboarded');
    // --- ADDED: Clear rover and sprinkler states on logout ---
    await prefs.remove('is_rover_active');
    await prefs.remove('is_sprinkler_active');

    notifyListeners();
  }
}

