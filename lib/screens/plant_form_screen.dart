import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../services/plant_service.dart';

class PlantFormScreen extends StatefulWidget {
  const PlantFormScreen({super.key});

  @override
  State<PlantFormScreen> createState() => _PlantFormScreenState();
}

class _PlantFormScreenState extends State<PlantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _notesController = TextEditingController();
  int _wateringFrequency = 7;
  int _fertilizingFrequency = 30;

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final plant = Plant(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        species: _speciesController.text,
        wateringFrequency: _wateringFrequency,
        fertilizingFrequency: _fertilizingFrequency,
        notes: _notesController.text,
        lastWatered: DateTime.now(),
        lastFertilized: DateTime.now(),
      );

      try {
        await Provider.of<PlantService>(context, listen: false).addPlant(plant);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding plant: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Plant'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Plant Name',
                hintText: 'Enter plant name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a plant name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _speciesController,
              decoration: const InputDecoration(
                labelText: 'Species',
                hintText: 'Enter plant species',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the plant species';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Watering Frequency (days)'),
                      Slider(
                        value: _wateringFrequency.toDouble(),
                        min: 1,
                        max: 30,
                        divisions: 29,
                        label: _wateringFrequency.toString(),
                        onChanged: (value) {
                          setState(() {
                            _wateringFrequency = value.round();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Fertilizing Frequency (days)'),
                      Slider(
                        value: _fertilizingFrequency.toDouble(),
                        min: 15,
                        max: 90,
                        divisions: 15,
                        label: _fertilizingFrequency.toString(),
                        onChanged: (value) {
                          setState(() {
                            _fertilizingFrequency = value.round();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Any additional notes about the plant',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Add Plant'),
            ),
          ],
        ),
      ),
    );
  }
}
