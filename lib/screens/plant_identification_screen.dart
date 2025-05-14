import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/plant_id_service.dart';

class PlantIdentificationScreen extends StatefulWidget {
  final String apiKey;

  const PlantIdentificationScreen({Key? key, required this.apiKey})
      : super(key: key);

  @override
  _PlantIdentificationScreenState createState() =>
      _PlantIdentificationScreenState();
}

class _PlantIdentificationScreenState extends State<PlantIdentificationScreen> {
  File? _image;
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  String? _error;
  late final PlantIdService _plantIdService;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _plantIdService = PlantIdService(widget.apiKey);
  }

  Future<void> _pickImage() async {
    try {
      print('Starting image pick process...');
      setState(() {
        _error = null;
        _result = null;
      });

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      print('Image picker result: ${pickedFile?.path}');

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        print('Checking if file exists: ${file.path}');
        print('File exists: ${await file.exists()}');

        if (await file.exists()) {
          print('File size: ${await file.length()} bytes');
          setState(() {
            _image = file;
          });
          print('Image set successfully');
        } else {
          print('File does not exist after picking');
          setState(() {
            _error = 'Failed to load image file';
          });
        }
      } else {
        print('No image was picked');
      }
    } catch (e, stackTrace) {
      print('Error picking image: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _error = 'Error picking image: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _identifyPlant() async {
    if (_image == null) {
      print('No image selected for identification');
      return;
    }

    print('Starting plant identification...');
    print('Image path: ${_image!.path}');
    print('Image exists: ${await _image!.exists()}');

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      print('Calling PlantIdService...');
      final result = await _plantIdService.identifyPlant(_image!);
      print('Plant identification result received');
      setState(() {
        _result = result;
        _isLoading = false;
      });
      print('Result set successfully');
    } catch (e, stackTrace) {
      print('Error identifying plant: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error identifying plant: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Identification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            if (_image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  _image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _identifyPlant,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Identify Plant'),
              ),
            ],
            if (_result != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plant Name: ${_result!['result']['plant']['name'] ?? 'Unknown'}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Scientific Name: ${_result!['result']['plant']['scientific_name'] ?? 'Unknown'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Care Instructions:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(_result!['result']['plant']['care_instructions'] ??
                          'No care instructions available'),
                    ],
                  ),
                ),
              ),
            ],
            if (_image == null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_a_photo,
                      size: 100,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No image selected',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
