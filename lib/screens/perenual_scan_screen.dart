import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/perenual_api_service.dart';

class PerenualScanScreen extends StatefulWidget {
  const PerenualScanScreen({Key? key}) : super(key: key);

  @override
  State<PerenualScanScreen> createState() => _PerenualScanScreenState();
}

class _PerenualScanScreenState extends State<PerenualScanScreen> {
  File? _image;
  final TextEditingController _plantNameController = TextEditingController();
  final PerenualApiService _apiService = PerenualApiService();
  bool _isLoading = false;
  List<dynamic>? _plantResults;
  List<dynamic>? _diseaseResults;
  String? _error;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error picking image: $e';
      });
    }
  }

  Future<void> _search() async {
    final query = _plantNameController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _error = 'Please enter a plant name or keyword.';
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
      _plantResults = null;
      _diseaseResults = null;
    });
    try {
      final plants = await _apiService.searchPlants(query);
      final diseases = await _apiService.searchDiseases(query);
      setState(() {
        _plantResults = plants;
        _diseaseResults = diseases;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error fetching data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perenual Plant Scan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                color: Colors.red.shade100,
                child:
                    Text(_error!, style: TextStyle(color: Colors.red.shade900)),
              ),
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(_image!,
                    height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Pick Image (optional)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _plantNameController,
              decoration: const InputDecoration(
                labelText: 'Plant Name or Keyword',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _search,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Search'),
            ),
            const SizedBox(height: 24),
            if (_plantResults != null) ...[
              const Text('Plant Results:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ..._plantResults!.map((plant) => Card(
                    child: ListTile(
                      leading: plant['default_image'] != null &&
                              plant['default_image']['thumbnail'] != null
                          ? Image.network(plant['default_image']['thumbnail'],
                              width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.local_florist),
                      title: Text(plant['common_name'] ?? 'Unknown'),
                      subtitle: Text(
                          (plant['scientific_name'] as List<dynamic>?)
                                  ?.join(', ') ??
                              ''),
                    ),
                  )),
            ],
            if (_diseaseResults != null) ...[
              const SizedBox(height: 24),
              const Text('Possible Diseases:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ..._diseaseResults!.map((disease) => Card(
                    child: ListTile(
                      leading: (disease['images'] != null &&
                              disease['images'].isNotEmpty &&
                              disease['images'][0]['thumbnail'] != null)
                          ? Image.network(disease['images'][0]['thumbnail'],
                              width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.sick),
                      title: Text(disease['common_name'] ?? 'Unknown'),
                      subtitle: Text(disease['scientific_name'] ?? ''),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
