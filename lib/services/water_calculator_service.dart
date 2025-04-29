import 'package:shared_preferences/shared_preferences.dart';

class WaterCalculatorService {
  // Factors affecting water needs
  static const double _baseWaterAmount =
      250.0; // ml per week for a medium plant

  double calculateWaterNeeds({
    required double potSize, // in inches diameter
    required String plantType,
    required String sunExposure,
    required String season,
    required String soilType,
  }) {
    double waterAmount = _baseWaterAmount;

    // Adjust for pot size (larger pots need more water)
    waterAmount *= (potSize / 6.0); // 6 inches is considered medium

    // Adjust for plant type
    switch (plantType.toLowerCase()) {
      case 'succulent':
      case 'cactus':
        waterAmount *= 0.3;
        break;
      case 'tropical':
        waterAmount *= 1.5;
        break;
      case 'herb':
        waterAmount *= 1.2;
        break;
      default: // standard houseplant
        waterAmount *= 1.0;
    }

    // Adjust for sun exposure
    switch (sunExposure.toLowerCase()) {
      case 'full sun':
        waterAmount *= 1.3;
        break;
      case 'partial sun':
        waterAmount *= 1.0;
        break;
      case 'shade':
        waterAmount *= 0.7;
        break;
    }

    // Adjust for season
    switch (season.toLowerCase()) {
      case 'summer':
        waterAmount *= 1.4;
        break;
      case 'spring':
      case 'fall':
        waterAmount *= 1.0;
        break;
      case 'winter':
        waterAmount *= 0.6;
        break;
    }

    // Adjust for soil type
    switch (soilType.toLowerCase()) {
      case 'sandy':
        waterAmount *= 1.3; // Drains quickly, needs more water
        break;
      case 'loamy':
        waterAmount *= 1.0; // Ideal soil type
        break;
      case 'clay':
        waterAmount *= 0.7; // Retains water longer
        break;
    }

    return double.parse(waterAmount.toStringAsFixed(1));
  }

  int calculateWateringFrequency({
    required String plantType,
    required String season,
    required String soilType,
  }) {
    int daysInterval = 7; // Base frequency: once a week

    // Adjust for plant type
    switch (plantType.toLowerCase()) {
      case 'succulent':
      case 'cactus':
        daysInterval *= 2; // Water less frequently
        break;
      case 'tropical':
        daysInterval = (daysInterval * 0.7).round(); // Water more frequently
        break;
      case 'herb':
        daysInterval = (daysInterval * 0.8).round();
        break;
    }

    // Adjust for season
    switch (season.toLowerCase()) {
      case 'summer':
        daysInterval = (daysInterval * 0.7).round(); // Water more frequently
        break;
      case 'winter':
        daysInterval = (daysInterval * 1.5).round(); // Water less frequently
        break;
    }

    // Adjust for soil type
    switch (soilType.toLowerCase()) {
      case 'sandy':
        daysInterval =
            (daysInterval * 0.8).round(); // Needs more frequent watering
        break;
      case 'clay':
        daysInterval = (daysInterval * 1.2).round(); // Retains water longer
        break;
    }

    return daysInterval;
  }

  Future<void> saveWateringSchedule(
      String plantId, DateTime nextWatering) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'next_watering_$plantId', nextWatering.toIso8601String());
  }

  Future<DateTime?> getNextWatering(String plantId) async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('next_watering_$plantId');
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }
}
