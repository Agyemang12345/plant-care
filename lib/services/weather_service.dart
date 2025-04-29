import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = '57b49aae19e4fff1046b6df7e67c3466';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url =
        '$_baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  String getPlantGrowthCondition(double temperature, int humidity) {
    if (temperature < 10) {
      return 'Too cold for most plants. Consider moving sensitive plants indoors.';
    } else if (temperature > 35) {
      return 'Too hot for most plants. Provide shade and increase watering.';
    } else if (temperature >= 20 && temperature <= 30 && humidity >= 50) {
      return 'Ideal conditions for most plants. Perfect for growth!';
    } else if (humidity < 40) {
      return 'Low humidity. Consider misting plants or using a humidifier.';
    } else {
      return 'Moderate conditions. Most plants will do well with proper care.';
    }
  }

  List<Map<String, dynamic>> getPlantRecommendations(
      double temperature, int humidity) {
    return [
      if (temperature >= 20 && temperature <= 30)
        {
          'name': 'Tomatoes',
          'icon': '🍅',
          'conditions': 'Perfect temperature for tomato growth!',
          'care': 'Water regularly, ensure good airflow',
        },
      if (humidity >= 60)
        {
          'name': 'Tropical Plants',
          'icon': '🌿',
          'conditions': 'High humidity ideal for tropical plants',
          'care': 'Maintain humidity, indirect sunlight',
        },
      if (temperature >= 15 && temperature <= 25)
        {
          'name': 'Herbs',
          'icon': '🌿',
          'conditions': 'Great conditions for herb growing',
          'care': 'Well-draining soil, moderate watering',
        },
      if (temperature >= 18 && temperature <= 24)
        {
          'name': 'Leafy Greens',
          'icon': '🥬',
          'conditions': 'Perfect for lettuce and spinach',
          'care': 'Keep soil moist, partial shade',
        },
    ];
  }

  Map<String, String> getWeatherTips(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'rain':
        return {
          'title': 'Rainy Conditions',
          'tip':
              'Check drainage to prevent waterlogging. Hold off on watering indoor plants.',
        };
      case 'clear':
        return {
          'title': 'Clear Skies',
          'tip':
              'Great time for pruning and outdoor plant maintenance. Watch for signs of heat stress.',
        };
      case 'clouds':
        return {
          'title': 'Cloudy Conditions',
          'tip':
              'Ideal for transplanting and fertilizing. Reduced water evaporation.',
        };
      default:
        return {
          'title': 'General Care',
          'tip':
              'Monitor your plants\' needs based on individual requirements.',
        };
    }
  }
}
