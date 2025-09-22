import 'dart:convert';
import 'package:agrisense/models/daily_forecast.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  // --- IMPORTANT: Replace with your actual OpenWeatherMap API Key ---
  static const String _apiKey = "15db54af5c08b1d7003731cf962d586e";
  // -----------------------------------------------------------------

  static const String _apiUrl =
      "https://api.openweathermap.org/data/3.0/onecall";

  static Future<List<DailyForecast>> fetchWeatherForecast() async {
    // TODO: Replace these hardcoded coordinates with the user's actual location
    // You can get this using a package like 'geolocator'.
    final double lat = 13.0827; // Chennai Latitude
    final double lon = 80.2707; // Chennai Longitude

    final url =
        '$_apiUrl?lat=$lat&lon=$lon&exclude=current,minutely,hourly,alerts&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> dailyData = jsonData['daily'];

        // Take the next 8 days (today + 7) and map to our model
        return dailyData
            .take(8)
            .map((item) => DailyForecast.fromJson(item))
            .toList();
      } else {
        throw Exception(
          'Failed to load weather data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching weather: $e');
      throw Exception('Failed to connect to the weather service.');
    }
  }
}