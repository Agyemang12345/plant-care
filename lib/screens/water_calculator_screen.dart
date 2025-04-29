import 'package:flutter/material.dart';
import '../services/water_calculator_service.dart';
import 'package:intl/intl.dart';

class WaterCalculatorScreen extends StatefulWidget {
  const WaterCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<WaterCalculatorScreen> createState() => _WaterCalculatorScreenState();
}

class _WaterCalculatorScreenState extends State<WaterCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _waterCalculator = WaterCalculatorService();

  double _potSize = 6.0;
  String _plantType = 'Standard';
  String _sunExposure = 'Partial Sun';
  String _season = 'Spring';
  String _soilType = 'Loamy';

  double? _waterAmount;
  int? _wateringInterval;
  DateTime? _nextWateringDate;

  final List<String> _plantTypes = [
    'Standard',
    'Succulent',
    'Cactus',
    'Tropical',
    'Herb'
  ];

  final List<String> _sunExposures = ['Full Sun', 'Partial Sun', 'Shade'];

  final List<String> _seasons = ['Spring', 'Summer', 'Fall', 'Winter'];

  final List<String> _soilTypes = ['Sandy', 'Loamy', 'Clay'];

  void _calculateWaterNeeds() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _waterAmount = _waterCalculator.calculateWaterNeeds(
          potSize: _potSize,
          plantType: _plantType,
          sunExposure: _sunExposure,
          season: _season,
          soilType: _soilType,
        );

        _wateringInterval = _waterCalculator.calculateWateringFrequency(
          plantType: _plantType,
          season: _season,
          soilType: _soilType,
        );

        _nextWateringDate =
            DateTime.now().add(Duration(days: _wateringInterval!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Calculator'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Plant Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Pot Size Slider
                      Text(
                        'Pot Size: ${_potSize.toStringAsFixed(1)} inches',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Slider(
                        value: _potSize,
                        min: 2.0,
                        max: 24.0,
                        divisions: 44,
                        label: _potSize.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            _potSize = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Plant Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _plantType,
                        decoration: const InputDecoration(
                          labelText: 'Plant Type',
                          border: OutlineInputBorder(),
                        ),
                        items: _plantTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _plantType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Sun Exposure Dropdown
                      DropdownButtonFormField<String>(
                        value: _sunExposure,
                        decoration: const InputDecoration(
                          labelText: 'Sun Exposure',
                          border: OutlineInputBorder(),
                        ),
                        items: _sunExposures.map((exposure) {
                          return DropdownMenuItem(
                            value: exposure,
                            child: Text(exposure),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _sunExposure = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Season Dropdown
                      DropdownButtonFormField<String>(
                        value: _season,
                        decoration: const InputDecoration(
                          labelText: 'Season',
                          border: OutlineInputBorder(),
                        ),
                        items: _seasons.map((season) {
                          return DropdownMenuItem(
                            value: season,
                            child: Text(season),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _season = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Soil Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _soilType,
                        decoration: const InputDecoration(
                          labelText: 'Soil Type',
                          border: OutlineInputBorder(),
                        ),
                        items: _soilTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _soilType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateWaterNeeds,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Calculate Water Needs',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              if (_waterAmount != null && _wateringInterval != null)
                Card(
                  margin: const EdgeInsets.only(top: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Watering Schedule',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Water Amount: ${_waterAmount!.toStringAsFixed(1)} ml',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Watering Interval: Every $_wateringInterval days',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        if (_nextWateringDate != null)
                          Text(
                            'Next Watering: ${DateFormat('EEEE, MMMM d').format(_nextWateringDate!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
