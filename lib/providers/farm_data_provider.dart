import 'package:agrisense/models/farm_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// --- ADD THIS IMPORT ---
import 'package:mqtt_client/mqtt_client.dart';

class FarmDataProvider with ChangeNotifier {
  FarmData _farmData = FarmData();
  bool _isLoading = true;
  bool _hasOnboarded = false;

  bool _isRoverActive = false;
  // bool _isSprinklerActive = false; // REMOVED
  String _lastStatusMessage = "Initializing...";

  MqttConnectionState _connectionState = MqttConnectionState.disconnected;

  // --- Getters ---
  FarmData get farmData => _farmData;
  bool get isLoading => _isLoading;
  bool get hasOnboarded => _hasOnboarded;
  bool get isRoverActive => _isRoverActive;
  // bool get isSprinklerActive => _isSprinklerActive; // REMOVED
  String get lastStatusMessage => _lastStatusMessage;

  MqttConnectionState get connectionState => _connectionState;

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

    _isRoverActive = prefs.getBool('is_rover_active') ?? false;
    // _isSprinklerActive = prefs.getBool('is_sprinkler_active') ?? false; // REMOVED

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

  Future<void> updateRoverState(bool isActive) async {
    if (_isRoverActive != isActive) {
      _isRoverActive = isActive;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_rover_active', isActive);
      notifyListeners();
    }
  }

  // --- updateSprinklerState REMOVED ---

  void setLastStatusMessage(String message) {
    _lastStatusMessage = message;
    notifyListeners();
  }

  void setConnectionState(MqttConnectionState state) {
    _connectionState = state;
    notifyListeners();
  }

  Future<void> clearData() async {
    _farmData = FarmData();
    _hasOnboarded = false;
    _isRoverActive = false;
    // _isSprinklerActive = false; // REMOVED
    _lastStatusMessage = "Logged out";
    _connectionState = MqttConnectionState.disconnected;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('farm_data');
    await prefs.remove('has_onboarded');
    await prefs.remove('is_rover_active');
    // await prefs.remove('is_sprinkler_active'); // REMOVED

    notifyListeners();
  }
}