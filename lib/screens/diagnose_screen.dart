import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DiagnoseScreen extends StatefulWidget {
  const DiagnoseScreen({super.key});

  @override
  State<DiagnoseScreen> createState() => _DiagnoseScreenState();
}

class _DiagnoseScreenState extends State<DiagnoseScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isDiagnosing = false;
  String? _diagnosisResult;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      setState(() {
        _isCameraInitialized = false;
      });
      return;
    }

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _controller == null) return;

    setState(() {
      _isDiagnosing = true;
    });

    try {
      final XFile image = await _controller!.takePicture();
      // Here you would typically send the image to your plant diagnosis API
      // For now, we'll simulate a result
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _diagnosisResult = 'Healthy';
        _isDiagnosing = false;
      });

      // Show result dialog
      _showResultDialog(image.path);
    } catch (e) {
      debugPrint('Error taking picture: $e');
      setState(() {
        _isDiagnosing = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _isDiagnosing = true;
      });

      // Here you would typically send the image to your plant diagnosis API
      // For now, we'll simulate a result
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _diagnosisResult = 'Needs Water';
        _isDiagnosing = false;
      });

      // Show result dialog
      _showResultDialog(image.path);
    }
  }

  void _showResultDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Plant Diagnosis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              File(imagePath),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              _diagnosisResult ?? 'Unable to Diagnose',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Confidence: 85%',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Recommendation:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getRecommendation(_diagnosisResult),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would navigate to the care instructions screen
            },
            child: const Text('View Care Instructions'),
          ),
        ],
      ),
    );
  }

  String _getRecommendation(String? diagnosis) {
    switch (diagnosis) {
      case 'Healthy':
        return 'Your plant is in good condition. Continue with regular care.';
      case 'Needs Water':
        return 'Water your plant thoroughly and ensure proper drainage.';
      case 'Too Much Water':
        return 'Reduce watering frequency and improve soil drainage.';
      case 'Needs Sunlight':
        return 'Move your plant to a brighter location with indirect sunlight.';
      case 'Too Much Sun':
        return 'Move your plant to a location with less direct sunlight.';
      case 'Nutrient Deficiency':
        return 'Apply appropriate fertilizer according to plant type.';
      default:
        return 'Unable to provide specific recommendations.';
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Diagnosis'),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isCameraInitialized
                ? Stack(
                    children: [
                      CameraPreview(_controller!),
                      if (_isDiagnosing)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  )
                : const Center(
                    child: Text('Camera not available'),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4332),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _takePicture,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Diagnose Plant'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
