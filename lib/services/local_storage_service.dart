import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _farmDataKey = 'farm_data';
  static const String _onboardingCompleteKey = 'onboarding_complete';

  /// Saves the complete farm data map to local storage.
  static Future<void> saveFarmData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(data);
    await prefs.setString(_farmDataKey, jsonString);
  }

  /// Loads the farm data map from local storage.
  static Future<Map<String, dynamic>> loadFarmData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_farmDataKey);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return {};
  }

  /// Saves the flag indicating that the user has completed the onboarding process.
  static Future<void> setOnboardingComplete(bool isComplete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, isComplete);
  }

  // ADDED: This function checks the onboarding status.
  /// Checks if the user has completed the onboarding process.
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    // Returns the saved boolean, or `false` if it has never been set.
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Clears all saved data on logout.
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_farmDataKey);
    await prefs.remove(_onboardingCompleteKey);
  }
}
