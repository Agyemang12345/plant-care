import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GeminiPlantScanScreen extends StatefulWidget {
  const GeminiPlantScanScreen({Key? key}) : super(key: key);

  @override
  State<GeminiPlantScanScreen> createState() => _GeminiPlantScanScreenState();
}

class _GeminiPlantScanScreenState extends State<GeminiPlantScanScreen> {
  File? _imageFile;
  bool _isLoading = false;
  String? _result;
  String? _error;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImageFromCamera() async {
    try {
      final XFile? image =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _result = null;
          _error = null;
        });
        await _analyzeImage();
      }
    } catch (e) {
      setState(() {
        _error = 'Error capturing image: $e';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageFile == null) return;
    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });
    try {
      final bytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);
      final apiKey = 'AIzaSyBvkCPTvdc5y0MD99d9XHG2A0aSbf5IGG8';
      final url = Uri.parse(
          'https://vision.googleapis.com/v1/images:annotate?key=$apiKey');
      final requestBody = {
        'requests': [
          {
            'image': {'content': base64Image},
            'features': [
              {'type': 'WEB_DETECTION', 'maxResults': 5},
              {'type': 'LABEL_DETECTION', 'maxResults': 5},
            ]
          }
        ]
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final webDetection = data['responses'][0]['webDetection'];
        final labelAnnotations = data['responses'][0]['labelAnnotations'];
        String resultText = '';
        if (webDetection != null && webDetection['bestGuessLabels'] != null) {
          resultText +=
              'Best Guess: ${webDetection['bestGuessLabels'][0]['label'] ?? 'Unknown'}\n';
        }
        if (labelAnnotations != null) {
          resultText += 'Labels: ';
          resultText +=
              labelAnnotations.map((l) => l['description']).take(3).join(', ');
        }
        setState(() {
          _result = resultText.isNotEmpty ? resultText : 'No plant identified.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error analyzing image: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gemini Plant Scan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageFile != null)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 20),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_result != null)
              Text(_result!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _getImageFromCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
