import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class PlantIdService {
  static const String _baseUrl = 'https://api.plant.id/v3';
  final String _apiKey;

  PlantIdService(this._apiKey);

  Future<Map<String, dynamic>> identifyPlant(File imageFile) async {
    try {
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      print('Making API request to Plant.id...');
      print(
          'API Key: ${_apiKey.substring(0, 5)}...'); // Only print first 5 chars for security

      // Prepare the request
      final response = await http.post(
        Uri.parse('$_baseUrl/identification'),
        headers: {
          'Api-Key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'images': [base64Image],
          'plant_details': {
            'common_names': true,
            'scientific_names': true,
            'wiki_description': true,
            'care_instructions': true,
          },
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to identify plant: ${response.body}');
      }
    } catch (e) {
      print('Error in identifyPlant: $e');
      throw Exception('Error identifying plant: $e');
    }
  }

  Future<Map<String, dynamic>> getHealthAssessment(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('$_baseUrl/health-assessment'),
        headers: {
          'Api-Key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'images': [base64Image],
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to assess plant health: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error assessing plant health: $e');
    }
  }
}
