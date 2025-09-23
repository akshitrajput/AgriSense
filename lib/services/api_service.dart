import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get _apiUrl {
    // --- IMPORTANT: Replace with YOUR computer's Wi-Fi IP address ---
    const String localIp = "10.139.26.75"; 
    // Example: const String localIp = "192.168.1.5";

    // This logic handles different platforms automatically
    if (kIsWeb) {
      return "http://localhost:8000/analyze";
    }
    if (Platform.isAndroid) {
      // Use the local IP for physical devices or emulators on the same Wi-Fi
      return "http://$localIp:8000/analyze";
    } else { // iOS Simulator
      return "http://localhost:8000/analyze";
    }
  }

  static Future<Map<String, dynamic>> analyzePlant(File imageFile, String cropType) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
      
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return json.decode(responseBody);
      } else {
        final errorBody = await response.stream.bytesToString();
        throw Exception('Backend Error: ${response.statusCode}\nResponse: $errorBody');
      }
    } catch (e) {
      print('Error calling backend: $e');
      throw Exception('Failed to connect to the backend service.');
    }
  }
}