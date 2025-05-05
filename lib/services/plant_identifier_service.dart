import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PlantIdentifierService {
  static const String _apiKey = '2b107qdsw8e2sPkr4S4yrw1eO';
  static const String _apiUrl =
      'https://my-api.plantnet.org/v2/identify/all?api-key=$_apiKey';

  Future<Map<String, dynamic>> identifyPlant(File imageFile) async {
    try {
      print('Starting PlantNet identification...');
      // Read image file as bytes and convert to base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Prepare the request body
      final request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
      request.files.add(http.MultipartFile.fromBytes('images', imageBytes,
          filename: 'plant.jpg'));
      request.fields['organs'] = 'leaf';
      request.fields['organs'] = 'flower';
      request.fields['organs'] = 'fruit';
      request.fields['organs'] = 'bark';

      final response =
          await request.send().timeout(const Duration(seconds: 20));
      final responseBody = await response.stream.bytesToString();

      print('PlantNet response status: ${response.statusCode}');
      print('PlantNet response body: $responseBody');

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        print('PlantNet API error: ${response.statusCode}');
        print('Response body: $responseBody');
        throw Exception('Failed to identify plant: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in identifyPlant: $e');
      throw Exception('Error identifying plant: $e');
    }
  }
}

class PlantInfo {
  final String commonName;
  final String scientificName;
  final String description;
  final double score;

  PlantInfo({
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.score,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List?;
    if (results == null || results.isEmpty) {
      return PlantInfo(
        commonName: 'Unknown',
        scientificName: 'Unknown',
        description: 'No information available.',
        score: 0.0,
      );
    }
    final best = results[0];
    final species = best['species'] ?? {};
    final commonNames = (species['commonNames'] as List?) ?? [];
    final scientificName = species['scientificNameWithoutAuthor'] ?? 'Unknown';
    final description = (species['bibliography'] as List?)?.join('\n') ??
        'No description available.';
    final score = (best['score'] as num?)?.toDouble() ?? 0.0;
    return PlantInfo(
      commonName: commonNames.isNotEmpty ? commonNames[0] : 'Unknown',
      scientificName: scientificName,
      description: description,
      score: score,
    );
  }
}
