import 'package:flutter/material.dart';

class TipPage extends StatelessWidget {
  const TipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Water your plants early in the morning or late in the evening to reduce evaporation.',
      'Check the soil moisture before watering to avoid overwatering.',
      'Place your plants where they can get adequate sunlight, but avoid harsh midday sun for sensitive plants.',
      'Remove dead or yellowing leaves to encourage healthy growth.',
      'Use well-draining soil to prevent root rot.',
      'Fertilize your plants during their growing season for best results.',
      'Keep an eye out for pests and treat them early.',
      'Repot your plants when they outgrow their containers.',
      'Wipe dust off leaves to help them photosynthesize better.',
      'Rotate your plants occasionally so all sides get light.',
    ];
    final wateringTips = [
      'Water deeply but less frequently to encourage deep root growth.',
      'Use room temperature water to avoid shocking plant roots.',
      'Avoid getting water on the leaves to prevent fungal diseases.',
      'Use a watering can with a narrow spout for precision.',
      'Reduce watering in winter when most plants are dormant.',
      'Group plants with similar watering needs together.',
      'Always check the top inch of soil before watering.',
      'Empty saucers under pots to prevent root rot.',
    ];
    final holeCareTips = [
      'Inspect your plant regularly for pests such as caterpillars, beetles, or snails, which often cause holes.',
      'Remove any visible pests by hand or use an appropriate organic pesticide.',
      'Prune affected leaves to prevent the spread of disease and encourage new growth.',
      'Keep your plant area clean and free of fallen leaves or debris that can harbor pests.',
      'Avoid overhead watering to reduce the risk of fungal infections.',
      'Isolate affected plants to prevent pests from spreading to healthy plants.',
      'Check the undersides of leaves, as pests often hide there.',
      'Maintain proper plant nutrition to help your plant recover from damage.',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care Tips'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('General Plant Care Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...tips.map((tip) => Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    tip,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )),
          const SizedBox(height: 24),
          const Text('Watering Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...wateringTips.map((tip) => Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    tip,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )),
          const SizedBox(height: 24),
          const Text('Caring for Plants with Holes in Leaves',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...holeCareTips.map((tip) => Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    tip,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
