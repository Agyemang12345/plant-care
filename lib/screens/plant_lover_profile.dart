import 'package:flutter/material.dart';

class PlantLoverProfile extends StatelessWidget {
  final String name;
  final String expertise;
  final List<String> achievements;

  const PlantLoverProfile({
    Key? key,
    required this.name,
    required this.expertise,
    required this.achievements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  name[0],
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                expertise,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Achievements:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...achievements.map((achievement) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(child: Text(achievement)),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
