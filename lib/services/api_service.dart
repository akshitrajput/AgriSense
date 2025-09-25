import 'dart:io';
import 'package:flutter/foundation.dart'; // Required for Uint8List
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiUrl = "https://agrisense-backend-trdc.onrender.com/analyze";

  /// Analyzes the plant image and returns a PDF report as a byte list.
  ///
  /// Takes the image [File], the current [languageCode], and the plant's
  /// coordinates ([row], [col]) as input.
  static Future<Uint8List> analyzePlantAndGetPdf(
      File imageFile, String languageCode, int row, int col) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_apiUrl));

      // Add all required fields to the multipart request.
      request.fields['language_code'] = languageCode;
      request.fields['row'] = row.toString();
      request.fields['col'] = col.toString();

      // Attach the image file.
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        // The function now returns the raw bytes of the PDF file,
        // which is represented as a Uint8List in Dart.
        return await response.stream.toBytes();
      } else {
        // Handle server-side errors.
        final errorBody = await response.stream.bytesToString();
        throw Exception(
            'Backend Error: ${response.statusCode}\nResponse: $errorBody');
      }
    } catch (e) {
      // Handle network or other client-side errors.
      print('Error calling backend: $e');
      throw Exception(
          'Failed to connect to the backend service. Please check your internet connection.');
    }
  }
}

