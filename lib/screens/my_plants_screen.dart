import 'package:flutter/material.dart';
import 'package:plant_care_app/screens/scan_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:plant_care_app/services/mock_plant_identifier_service.dart';
import 'package:plant_care_app/models/plant_info.dart';

class MyPlantsScreen extends StatefulWidget {
  const MyPlantsScreen({super.key});

  @override
  State<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();
  final MockPlantIdentifierService _plantIdentifier =
      MockPlantIdentifierService();
  bool _isLoading = false;

  // State for garden, reminders, and history
  final List<PlantInfo> _gardenPlants = [];
  final List<String> _reminders = [];
  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddPlantOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add a Plant',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.green),
                ),
                title: const Text('Scan Plant'),
                subtitle: const Text('Take a photo to identify your plant'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.blue),
                ),
                title: const Text('Import from Gallery'),
                subtitle: const Text('Choose a photo from your gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    await _identifyPlant(File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _identifyPlant(File imageFile) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await _plantIdentifier.identifyPlant(imageFile);
      final plantInfo = PlantInfo.fromJson(result);

      // Show plant information dialog
      if (mounted) {
        await _showPlantInfoDialog(plantInfo);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error identifying plant: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showPlantInfoDialog(PlantInfo plantInfo) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Plant Identified!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B4332),
                        ),
                      ),
                      Text(
                        '${(plantInfo.confidence * 100).toStringAsFixed(0)}% match',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoSection('Common Name', plantInfo.commonName),
                  _buildInfoSection(
                      'Scientific Name', plantInfo.scientificName),
                  _buildInfoSection('Description', plantInfo.description),
                  _buildInfoSection('Watering Needs', plantInfo.watering),
                  _buildInfoSection('Sunlight Needs', plantInfo.sunlight),
                  _buildInfoSection('Propagation', plantInfo.propagation),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _gardenPlants.add(plantInfo);
                          _history
                              .add('Added ${plantInfo.commonName} to garden');
                        });
                        Navigator.pop(context);
                        // Prompt for reminder
                        final reminder =
                            await _showReminderDialog(plantInfo.commonName);
                        if (reminder != null && reminder.isNotEmpty) {
                          setState(() {
                            _reminders.add(
                                'Reminder for ${plantInfo.commonName}: $reminder');
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4332),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Add to My Garden',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showReminderDialog(String plantName) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Reminder for $plantName'),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(hintText: 'e.g. Water every 3 days'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B4332),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGardenTab() {
    if (_gardenPlants.isEmpty) {
      return _buildEmptyState();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _gardenPlants.length,
      itemBuilder: (context, index) {
        final plant = _gardenPlants[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.local_florist, color: Colors.green),
            title: Text(plant.commonName),
            subtitle: Text(plant.scientificName),
          ),
        );
      },
    );
  }

  Widget _buildRemindersTab() {
    if (_reminders.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Reminders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B4332),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add plants to set care reminders',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reminders.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading:
                const Icon(Icons.notifications_active, color: Colors.orange),
            title: Text(_reminders[index]),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    if (_history.isEmpty) {
      return const Center(child: Text('History will appear here'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.history, color: Colors.blueGrey),
            title: Text(_history[index]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'My Plants',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Garden'),
                  Tab(text: 'Reminders'),
                  Tab(text: 'History'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Garden Tab
                  _buildGardenTab(),
                  // Reminders Tab
                  _buildRemindersTab(),
                  // History Tab
                  _buildHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const Text(
          'You have no plants',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B4332),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add your first plant and start caring for it',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _showAddPlantOptions,
          icon: const Icon(Icons.add),
          label: const Text('Add Plants'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B4332),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get Pro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Upgrade to pro for more fun',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
