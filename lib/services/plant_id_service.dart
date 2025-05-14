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
      print('PlantIdService: Starting plant identification...');

      if (!await imageFile.exists()) {
        print(
            'PlantIdService: Image file does not exist at path: ${imageFile.path}');
        throw Exception('Image file does not exist');
      }

      print('PlantIdService: Reading image file...');
      final bytes = await imageFile.readAsBytes();
      print('PlantIdService: Image size: ${bytes.length} bytes');

      final base64Image = base64Encode(bytes);
      print('PlantIdService: Image encoded to base64');

      print('PlantIdService: Making API request to Plant.id...');
      print('PlantIdService: API Key: ${_apiKey.substring(0, 5)}...');

      final requestBody = {
        'images': [base64Image],
        'plant_details': {
          'common_names': true,
          'scientific_names': true,
          'wiki_description': true,
          'care_instructions': true,
        },
      };
      print('PlantIdService: Request body prepared');

      final response = await http.post(
        Uri.parse('$_baseUrl/identification'),
        headers: {
          'Api-Key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('PlantIdService: Response status code: ${response.statusCode}');
      print('PlantIdService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['result'] == null) {
          print(
              'PlantIdService: Invalid response format - missing result field');
          throw Exception('Invalid response format: missing result field');
        }
        print('PlantIdService: Plant identification successful');
        return responseData;
      } else {
        print(
            'PlantIdService: API request failed with status ${response.statusCode}');
        throw Exception('Failed to identify plant: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('PlantIdService: Error in identifyPlant: $e');
      print('PlantIdService: Stack trace: $stackTrace');
      throw Exception('Error identifying plant: $e');
    }
  }

  Future<Map<String, dynamic>> getHealthAssessment(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      print('Making health assessment request...');
      print('Image size: ${bytes.length} bytes');

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

      print('Health assessment response status: ${response.statusCode}');
      print('Health assessment response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['result'] == null) {
          throw Exception('Invalid response format: missing result field');
        }
        return responseData;
      } else {
        throw Exception('Failed to assess plant health: ${response.body}');
      }
    } catch (e) {
      print('Error in getHealthAssessment: $e');
      throw Exception('Error assessing plant health: $e');
    }
  }
}
