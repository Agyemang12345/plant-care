import 'dart:io';
import 'dart:math';

class MockPlantIdentifierService {
  final List<Map<String, dynamic>> _mockPlants = [
    {
      'commonName': 'Snake Plant',
      'scientificName': 'Sansevieria trifasciata',
      'description':
          'The snake plant is one of the most popular and hardy houseplants. It features stiff, sword-like leaves and can grow anywhere from 6 inches to several feet tall.',
      'watering':
          'Water every 2-3 weeks, allowing soil to dry out between waterings. Water even less during winter.',
      'sunlight': 'Can tolerate low light but thrives in bright indirect light',
      'propagation': 'Division, leaf cuttings in water or soil',
      'confidence': 0.95,
    },
    {
      'commonName': 'Peace Lily',
      'scientificName': 'Spathiphyllum wallisii',
      'description':
          'Peace lilies are tropical, evergreen plants that thrive on the forest floor, where they receive dappled sunlight and consistent moisture.',
      'watering':
          'Keep soil moist but not waterlogged. Water when top inch of soil feels dry.',
      'sunlight': 'Medium to low indirect light',
      'propagation': 'Division of clumps during repotting',
      'confidence': 0.92,
    },
    {
      'commonName': 'Spider Plant',
      'scientificName': 'Chlorophytum comosum',
      'description':
          'Spider plants are easy-to-grow houseplants that produce arching clumps of grass-like leaves and lots of baby plantlets on long stems.',
      'watering':
          'Water when the top 50% of soil is dry. Typically every 7-10 days.',
      'sunlight': 'Bright indirect light to partial shade',
      'propagation':
          'Plantlets can be rooted while still attached to the mother plant',
      'confidence': 0.89,
    },
    {
      'commonName': 'Monstera',
      'scientificName': 'Monstera deliciosa',
      'description':
          'Known for its distinctive leaves with natural holes, the Monstera is a striking tropical plant that makes a bold statement in any space.',
      'watering':
          'Water every 1-2 weeks, allowing soil to dry out between waterings.',
      'sunlight': 'Bright indirect light',
      'propagation': 'Stem cuttings in water or soil',
      'confidence': 0.94,
    },
    {
      'commonName': 'ZZ Plant',
      'scientificName': 'Zamioculcas zamiifolia',
      'description':
          'The ZZ Plant is a tropical plant known for its thick, waxy leaves and tolerance of low light conditions.',
      'watering':
          'Allow soil to dry completely between waterings. Water every 2-3 weeks.',
      'sunlight': 'Can tolerate low light to bright indirect light',
      'propagation': 'Division or leaf cuttings',
      'confidence': 0.91,
    }
  ];

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
            'common_names': [mockPlant['commonName']],
            'scientific_name': mockPlant['scientificName'],
            'wiki_description': {'value': mockPlant['description']},
            'watering': {'description': mockPlant['watering']},
            'sunlight': [mockPlant['sunlight']],
            'propagation': [mockPlant['propagation']]
          },
          'probability': mockPlant['confidence']
        }
      ]
    };
  }
}
