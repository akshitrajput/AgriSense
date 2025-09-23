import 'dart:convert';
import 'package:agrisense/models/daily_forecast.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart'; // Import the geolocator package

class WeatherService {
  static const String _apiKey = "23c58c68d34d415983a85602251106";

  /// NEW HELPER FUNCTION: Gets the current position of the user.
  /// It handles permission requests and location services checks.
  static Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<List<DailyForecast>> fetchWeatherForecast() async {
    // CHANGED: Get location dynamically instead of hardcoding.
    String location;
    try {
      final position = await _getCurrentPosition();
      location = '${position.latitude},${position.longitude}';
    } catch (e) {
      // If getting location fails, you can fall back to a default or rethrow.
      // Here we rethrow the exception to be handled by the UI.
      throw Exception('Failed to get user location: $e');
    }

    // This URL correctly requests a 7-day forecast.
    final url =
        'https://api.weatherapi.com/v1/forecast.json?key=$_apiKey&q=$location&days=7&aqi=no&alerts=no';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> dailyData = jsonData['forecast']['forecastday'];

        return dailyData.map((item) => DailyForecast.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load weather data. Status Code: ${response.statusCode}. Body: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching weather: $e');
      throw Exception('Failed to connect to the weather service.');
    }
  }
}