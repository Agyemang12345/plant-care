import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../models/care.dart';
import '../services/plant_service.dart';
import '../widgets/plant_card.dart';

class CareScreen extends StatefulWidget {
  final Plant plant;

  const CareScreen({super.key, required this.plant});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  late PlantService _plantService;

  @override
  void initState() {
    super.initState();
    _plantService = Provider.of<PlantService>(context, listen: false);
  }

  Future<void> _handleWater() async {
    await _plantService.updatePlantWithCare(widget.plant, CareType.water);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: PlantCard(
              plant: widget.plant,
              onTap: () {},
              onWater: _handleWater,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Care History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.plant.careHistory.length,
              itemBuilder: (context, index) {
                final care = widget.plant.careHistory[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      care.type == CareType.water
                          ? Icons.water_drop
                          : Icons.eco,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      care.type == CareType.water ? 'Watered' : 'Other Care',
                    ),
                    subtitle: Text(
                      '${care.date.day}/${care.date.month}/${care.date.year}',
                    ),
                    trailing: care.notes != null && care.notes!.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Care Notes'),
                                  content: Text(care.notes!),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
