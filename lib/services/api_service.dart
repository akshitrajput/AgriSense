import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // --- CHANGE ---
  // The old platform-specific logic is no longer needed.
  // We now have one single URL for the live backend on Render.
  static const String _apiUrl = "https://agrisense-backend-trdc.onrender.com/analyze";

  /// Analyzes the plant image by sending it to the deployed backend.
  static Future<Map<String, dynamic>> analyzePlant(File imageFile) async {
    try {
      // Create a multipart request to send the image file.
      var request = http.MultipartRequest('POST', Uri.parse(_apiUrl));

      // Attach the image file to the request. The backend expects the field name to be 'image'.
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // Send the request and wait for the response.
      var response = await request.send();

      // Check if the request was successful (status code 200).
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // Decode the JSON response from the server into a Dart Map.
        return json.decode(responseBody);
      } else {
        // If the server returned an error, read the response and throw an exception.
        final errorBody = await response.stream.bytesToString();
        throw Exception('Backend Error: ${response.statusCode}\nResponse: $errorBody');
      }
    } catch (e) {
      // Catch any other errors (e.g., no internet connection).
      print('Error calling backend: $e');
      throw Exception('Failed to connect to the backend service. Please check your internet connection.');
    }
  }
}
