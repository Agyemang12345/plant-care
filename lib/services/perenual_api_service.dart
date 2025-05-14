import 'dart:convert';
import 'package:http/http.dart' as http;

class PerenualApiService {
  static const String _apiKey = 'sk-cF0d68244c201717610438';
  static const String _baseUrl = 'https://perenual.com/api';

  // Search for plants by name or keyword
  Future<List<dynamic>> searchPlants(String query) async {
    final url = '$_baseUrl/v2/species-list?key=$_apiKey&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to search plants: ${response.body}');
    }
  }

  // Get plant details by ID
  Future<Map<String, dynamic>?> getPlantDetails(int id) async {
    final url = '$_baseUrl/v2/species/details/$id?key=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get plant details: ${response.body}');
    }
  }

  // Search for diseases by name or keyword
  Future<List<dynamic>> searchDiseases(String query) async {
    final url = '$_baseUrl/pest-disease-list?key=$_apiKey&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to search diseases: ${response.body}');
    }
  }

  // Get disease details by ID
  Future<Map<String, dynamic>?> getDiseaseDetails(int id) async {
    final url = '$_baseUrl/pest-disease-list?key=$_apiKey&id=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null && data['data'].isNotEmpty) {
        return data['data'][0];
      }
      return null;
    } else {
      throw Exception('Failed to get disease details: ${response.body}');
    }
  }
}
