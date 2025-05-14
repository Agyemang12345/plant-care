import 'dart:io';
import 'dart:math';

class MockPlantIdentifierService {
  final List<Map<String, dynamic>> _mockPlants = [
    {
      'commonName': 'Mango Plant',
      'scientificName': 'Mangifera indica',
      'defaultMessage': '''This is a mango plant.

Mango plants (Mangifera indica) are tropical fruit trees that thrive in warm, sunny climates. To care for a mango plant in a garden:
- Plant in well-draining, fertile soil with full sun exposure.
- Water deeply but infrequently, allowing the soil to dry slightly between waterings.
- Fertilize with a balanced fertilizer during the growing season.
- Prune to remove dead or diseased branches and to shape the tree.
- Protect young plants from frost and strong winds.
Mango trees can grow large, so give them plenty of space!'''
    },
    {
      'commonName': 'Grass',
      'scientificName': 'Poaceae',
      'defaultMessage': '''This is a grass plant.

Grasses (family Poaceae) are among the most widespread and important plants on earth. For garden care:
- Most grasses prefer full sun and well-drained soil.
- Water regularly, especially during dry periods, but avoid waterlogging.
- Mow or trim as needed to maintain desired height.
- Fertilize in spring and fall for lush growth.
Grasses help prevent soil erosion and provide habitat for many creatures.'''
    },
    {
      'commonName': 'Orange Plant',
      'scientificName': 'Citrus sinensis',
      'defaultMessage': '''This is an orange plant.

Orange plants (Citrus sinensis) are evergreen fruit trees. There are many species and varieties, including navel, Valencia, and blood oranges. For best results:
- Plant in well-drained, sandy loam soil with full sun.
- Water regularly but do not overwater; allow the top inch of soil to dry out between waterings.
- Fertilize with a citrus-specific fertilizer during the growing season.
- Prune to remove dead wood and improve air circulation.
- Protect from frost and pests like aphids and scale insects.
Oranges are rich in vitamin C and are enjoyed worldwide!'''
    },
  ];

  List<Map<String, dynamic>> get mockPlants => _mockPlants;

  Future<Map<String, dynamic>> identifyPlant(File imageFile) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Randomly select a plant from the mock data
    final random = Random();
    final mockPlant = _mockPlants[random.nextInt(_mockPlants.length)];

    return {
      'suggestions': [
        {
          'plant_details': {
            'common_name': mockPlant['commonName'],
            'scientific_name': mockPlant['scientificName'],
            'default_message': mockPlant['defaultMessage'],
          },
          'probability': 0.95
        }
      ]
    };
  }
}
