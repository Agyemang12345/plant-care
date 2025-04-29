import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback onWater;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    required this.onWater,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysSinceWatered = plant.lastWatered != null
        ? now.difference(plant.lastWatered!).inDays
        : plant.wateringFrequency;
    final needsWater = daysSinceWatered >= plant.wateringFrequency;

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (plant.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        plant.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          plant.species,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCareInfo(
                    context: context,
                    icon: Icons.water_drop,
                    label: 'Water',
                    value: 'Every ${plant.wateringFrequency} days',
                    lastDone: plant.lastWatered,
                    frequency: plant.wateringFrequency,
                    needsCare: needsWater,
                    onCare: onWater,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCareInfo({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required DateTime? lastDone,
    required int frequency,
    required bool needsCare,
    required VoidCallback onCare,
  }) {
    final daysSince = lastDone != null
        ? DateTime.now().difference(lastDone).inDays
        : frequency;

    return Column(
      children: [
        IconButton(
          onPressed: onCare,
          icon: Icon(
            icon,
            color: needsCare ? Colors.red : Colors.green,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
        Text(
          lastDone != null ? '$daysSince days ago' : 'Never',
          style: TextStyle(
            color: needsCare ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}
