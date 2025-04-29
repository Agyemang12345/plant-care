import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../models/plant.dart';
import '../models/care_history.dart';
import '../models/care.dart';

class PlantService extends ChangeNotifier {
  static const String _plantsJsonPath = 'assets/data/plants.json';
  static const String _careHistoryJsonPath = 'assets/data/care_history.json';
  final _uuid = const Uuid();
  final List<Plant> _plants = [];
  final StreamController<List<Plant>> _plantsController =
      StreamController<List<Plant>>.broadcast();

  PlantService() {
    _initializePlants();
  }

  Future<void> _initializePlants() async {
    try {
      final loadedPlants = await loadPlants();
      if (loadedPlants.isEmpty) {
        // Add sample plants if no plants are loaded
        _plants.addAll([
          Plant(
            id: '1',
            name: 'Monstera',
            species: 'Monstera deliciosa',
            wateringFrequency: 7,
            fertilizingFrequency: 30,
            lastWatered: DateTime.now().subtract(const Duration(days: 3)),
            lastFertilized: DateTime.now().subtract(const Duration(days: 20)),
          ),
          Plant(
            id: '2',
            name: 'Snake Plant',
            species: 'Sansevieria',
            wateringFrequency: 14,
            fertilizingFrequency: 60,
            lastWatered: DateTime.now().subtract(const Duration(days: 10)),
            lastFertilized: DateTime.now().subtract(const Duration(days: 45)),
          ),
        ]);
      } else {
        _plants.addAll(loadedPlants);
      }
      _notifyListeners();
    } catch (e) {
      print('Error initializing plants: $e');
      // Add sample plants in case of error
      _plants.addAll([
        Plant(
          id: '1',
          name: 'Monstera',
          species: 'Monstera deliciosa',
          wateringFrequency: 7,
          fertilizingFrequency: 30,
          lastWatered: DateTime.now().subtract(const Duration(days: 3)),
          lastFertilized: DateTime.now().subtract(const Duration(days: 20)),
        ),
        Plant(
          id: '2',
          name: 'Snake Plant',
          species: 'Sansevieria',
          wateringFrequency: 14,
          fertilizingFrequency: 60,
          lastWatered: DateTime.now().subtract(const Duration(days: 10)),
          lastFertilized: DateTime.now().subtract(const Duration(days: 45)),
        ),
      ]);
      _notifyListeners();
    }
  }

  Stream<List<Plant>> getPlants() {
    return _plantsController.stream;
  }

  // Load plants from JSON file
  Future<List<Plant>> loadPlants() async {
    try {
      final String jsonString = await rootBundle.loadString(_plantsJsonPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Plant.fromMap(json)).toList();
    } catch (e) {
      print('Error loading plants: $e');
      return [];
    }
  }

  // Save plants to JSON file
  Future<void> savePlants(List<Plant> plants) async {
    try {
      final List<Map<String, dynamic>> plantsMap =
          plants.map((plant) => plant.toMap()).toList();
      final String jsonString = json.encode(plantsMap);
      // Note: In a real app, you would need to implement file writing logic here
      // For now, we'll just print the JSON string
      print('Saved plants: $jsonString');
    } catch (e) {
      print('Error saving plants: $e');
    }
  }

  // Add a new plant
  Future<void> addPlant(Plant plant) async {
    try {
      final List<Plant> plants = await loadPlants();
      plants.add(plant);
      await savePlants(plants);
    } catch (e) {
      print('Error adding plant: $e');
    }
  }

  // Update an existing plant
  Future<void> updatePlant(Plant plant) async {
    try {
      final List<Plant> plants = await loadPlants();
      final int index = plants.indexWhere((p) => p.id == plant.id);
      if (index != -1) {
        plants[index] = plant;
        await savePlants(plants);
      }
    } catch (e) {
      print('Error updating plant: $e');
    }
  }

  // Delete a plant
  Future<void> deletePlant(String plantId) async {
    try {
      final List<Plant> plants = await loadPlants();
      plants.removeWhere((plant) => plant.id == plantId);
      await savePlants(plants);
    } catch (e) {
      print('Error deleting plant: $e');
    }
  }

  // Get plants that need watering
  Future<List<Plant>> getPlantsNeedingWater() async {
    try {
      final List<Plant> plants = await loadPlants();
      final now = DateTime.now();
      return plants.where((plant) {
        if (plant.lastWatered == null) return true;
        final daysSinceLastWatered = now.difference(plant.lastWatered!).inDays;
        return daysSinceLastWatered >= plant.wateringFrequency;
      }).toList();
    } catch (e) {
      print('Error getting plants needing water: $e');
      return [];
    }
  }

  // Get plants that need fertilizing
  Future<List<Plant>> getPlantsNeedingFertilizer() async {
    try {
      final List<Plant> plants = await loadPlants();
      final now = DateTime.now();
      return plants.where((plant) {
        if (plant.lastFertilized == null) return true;
        final daysSinceLastFertilized =
            now.difference(plant.lastFertilized!).inDays;
        return daysSinceLastFertilized >= plant.fertilizingFrequency;
      }).toList();
    } catch (e) {
      print('Error getting plants needing fertilizer: $e');
      return [];
    }
  }

  // Add care history
  Future<void> addCareHistory(CareHistory careHistory) async {
    try {
      final List<CareHistory> history = await loadCareHistory();
      history.add(careHistory);
      await saveCareHistory(history);
    } catch (e) {
      print('Error adding care history: $e');
    }
  }

  // Load care history
  Future<List<CareHistory>> loadCareHistory() async {
    try {
      final String jsonString =
          await rootBundle.loadString(_careHistoryJsonPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => CareHistory.fromMap(json)).toList();
    } catch (e) {
      print('Error loading care history: $e');
      return [];
    }
  }

  // Save care history
  Future<void> saveCareHistory(List<CareHistory> history) async {
    try {
      final List<Map<String, dynamic>> historyMap =
          history.map((entry) => entry.toMap()).toList();
      final String jsonString = json.encode(historyMap);
      print('Saved care history: $jsonString');
    } catch (e) {
      print('Error saving care history: $e');
    }
  }

  // Get care history for a plant
  Future<List<CareHistory>> getCareHistoryForPlant(String plantId) async {
    try {
      final List<CareHistory> history = await loadCareHistory();
      return history.where((entry) => entry.plantId == plantId).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      print('Error getting care history for plant: $e');
      return [];
    }
  }

  // Update plant with care activity
  Future<void> updatePlantWithCare(Plant plant, CareType type) async {
    final care = Care(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plantId: plant.id,
      type: type,
      date: DateTime.now(),
    );

    final updatedPlant = plant.copyWith(
      lastWatered: type == CareType.water ? DateTime.now() : plant.lastWatered,
      lastFertilized:
          type == CareType.fertilize ? DateTime.now() : plant.lastFertilized,
      careHistory: [...plant.careHistory, care],
    );

    final index = _plants.indexWhere((p) => p.id == plant.id);
    if (index != -1) {
      _plants[index] = updatedPlant;
      _notifyListeners();
    }
  }

  // Get care statistics for a plant
  Future<Map<String, dynamic>> getCareStatistics(String plantId) async {
    try {
      final List<CareHistory> history = await getCareHistoryForPlant(plantId);
      final now = DateTime.now();

      final waterHistory =
          history.where((entry) => entry.type == CareType.water).toList();
      final fertilizeHistory =
          history.where((entry) => entry.type == CareType.fertilize).toList();

      return {
        'totalWaterings': waterHistory.length,
        'totalFertilizings': fertilizeHistory.length,
        'lastWatered':
            waterHistory.isNotEmpty ? waterHistory.first.timestamp : null,
        'lastFertilized': fertilizeHistory.isNotEmpty
            ? fertilizeHistory.first.timestamp
            : null,
        'averageWateringInterval': _calculateAverageInterval(waterHistory),
        'averageFertilizingInterval':
            _calculateAverageInterval(fertilizeHistory),
      };
    } catch (e) {
      print('Error getting care statistics: $e');
      return {};
    }
  }

  double? _calculateAverageInterval(List<CareHistory> history) {
    if (history.length < 2) return null;

    double totalDays = 0;
    for (int i = 0; i < history.length - 1; i++) {
      totalDays +=
          history[i].timestamp.difference(history[i + 1].timestamp).inDays;
    }

    return totalDays / (history.length - 1);
  }

  // Get recent plants (last 5 plants that need care)
  Stream<List<Plant>> getRecentPlants() async* {
    try {
      final List<Plant> plants = await loadPlants();
      final now = DateTime.now();

      // Sort plants by when they need care next
      plants.sort((a, b) {
        final daysSinceWaterA = a.lastWatered != null
            ? now.difference(a.lastWatered!).inDays
            : a.wateringFrequency;
        final daysSinceWaterB = b.lastWatered != null
            ? now.difference(b.lastWatered!).inDays
            : b.wateringFrequency;
        final daysSinceFertilizeA = a.lastFertilized != null
            ? now.difference(a.lastFertilized!).inDays
            : a.fertilizingFrequency;
        final daysSinceFertilizeB = b.lastFertilized != null
            ? now.difference(b.lastFertilized!).inDays
            : b.fertilizingFrequency;

        final needsCareA = daysSinceWaterA >= a.wateringFrequency ||
            daysSinceFertilizeA >= a.fertilizingFrequency;
        final needsCareB = daysSinceWaterB >= b.wateringFrequency ||
            daysSinceFertilizeB >= b.fertilizingFrequency;

        if (needsCareA && !needsCareB) return -1;
        if (!needsCareA && needsCareB) return 1;

        // If both need care or both don't need care, sort by most urgent
        final urgencyA = daysSinceWaterA / a.wateringFrequency +
            daysSinceFertilizeA / a.fertilizingFrequency;
        final urgencyB = daysSinceWaterB / b.wateringFrequency +
            daysSinceFertilizeB / b.fertilizingFrequency;

        return urgencyB.compareTo(urgencyA);
      });

      yield plants.take(5).toList();
    } catch (e) {
      print('Error getting recent plants: $e');
      yield [];
    }
  }

  void _notifyListeners() {
    _plantsController.add(List.unmodifiable(_plants));
    notifyListeners();
  }

  @override
  void dispose() {
    _plantsController.close();
    super.dispose();
  }
}
