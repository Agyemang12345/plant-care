import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PlantIdentifierService {
  static const String _apiKey =
      'YOUR_API_KEY'; // Replace with your Plant.id API key
  static const String _apiUrl = 'https://api.plant.id/v2/identify';

  Future<Map<String, dynamic>> identifyPlant(File imageFile) async {
    try {
      // Read image file as bytes and convert to base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Prepare the request body
      final body = jsonEncode({
        'images': [base64Image],
        'plant_details': [
          'common_names',
          'scientific_name',
          'wiki_description',
          'watering',
          'sunlight',
          'propagation',
        ],
      });

      // Make the API request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Api-Key': _apiKey,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to identify plant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error identifying plant: $e');
    }
  }
}

class PlantInfo {
  final String commonName;
  final String scientificName;
  final String description;
  final String watering;
  final String sunlight;
  final String propagation;
  final double confidence;

  PlantInfo({
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.watering,
    required this.sunlight,
    required this.propagation,
    required this.confidence,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    final suggestion = json['suggestions'][0];
    final plantDetails = suggestion['plant_details'];

    return PlantInfo(
      commonName: (plantDetails['common_names'] as List).first ?? 'Unknown',
      scientificName: plantDetails['scientific_name'] ?? 'Unknown',
      description: plantDetails['wiki_description']?['value'] ??
          'No description available',
      watering: plantDetails['watering']?['description'] ??
          'Information not available',
      sunlight: (plantDetails['sunlight'] as List?)?.join(', ') ??
          'Information not available',
      propagation: (plantDetails['propagation'] as List?)?.join(', ') ??
          'Information not available',
      confidence: suggestion['probability'] ?? 0.0,
    );
  }
}
