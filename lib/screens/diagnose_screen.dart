import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';

class DiagnoseScreen extends StatefulWidget {
  const DiagnoseScreen({super.key});

  @override
  State<DiagnoseScreen> createState() => _DiagnoseScreenState();
}

class _DiagnoseScreenState extends State<DiagnoseScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isProcessing = false;
  Offset? _focusPoint;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _diagnosisResult;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFlash() async {
    if (_controller != null) {
      _isFlashOn = !_isFlashOn;
      await _controller!
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    }
  }

  Future<void> _onDiagnosePressed() async {
    if (!_isCameraInitialized || _controller == null || _isProcessing) return;
    setState(() {
      _isProcessing = true;
    });
    try {
      final XFile image = await _controller!.takePicture();
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      // Simulate plant recognition result with a random hasHoleOnLeaves
      final bool hasHoleOnLeaves = DateTime.now().second % 2 == 0; // Simulate
      _showCustomDiagnosisDialog(hasHoleOnLeaves);
    } catch (e) {
      if (mounted) {
        _showCustomDiagnosisDialog(true); // Default to unhealthy on error
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Map<String, String> _getRandomPlantInfo() {
    // List of sample plants with their information
    final List<Map<String, String>> plants = [
      {
        'name': 'Peace Lily',
        'scientific_name': 'Spathiphyllum',
        'species': 'Spathiphyllum wallisii',
        'description':
            'A popular indoor plant known for its air-purifying qualities.',
        'care_level': 'Easy to moderate',
      },
      {
        'name': 'Snake Plant',
        'scientific_name': 'Sansevieria',
        'species': 'Sansevieria trifasciata',
        'description':
            'A hardy succulent that can tolerate low light conditions.',
        'care_level': 'Easy',
      },
      {
        'name': 'Monstera',
        'scientific_name': 'Monstera deliciosa',
        'species': 'Araceae',
        'description':
            'Known for its distinctive split leaves and tropical appearance.',
        'care_level': 'Moderate',
      },
      {
        'name': 'Spider Plant',
        'scientific_name': 'Chlorophytum comosum',
        'species': 'Asparagaceae',
        'description':
            'Fast-growing plant that produces plantlets on long stems.',
        'care_level': 'Easy',
      },
    ];

    return plants[DateTime.now().millisecond % plants.length];
  }

  void _showPlantInfoDialog(Map<String, String> plantInfo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                      'Plant Identified',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B4332),
                      ),
                    ),
                    Text(
                      'High Match',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInfoSection('Common Name', plantInfo['name'] ?? ''),
                _buildInfoSection(
                    'Scientific Name', plantInfo['scientific_name'] ?? ''),
                _buildInfoSection('Species', plantInfo['species'] ?? ''),
                _buildInfoSection(
                    'Description', plantInfo['description'] ?? ''),
                _buildInfoSection('Care Level', plantInfo['care_level'] ?? ''),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Add navigation to detailed care instructions if needed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4332),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('View Care Guide'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

  Future<void> _onImportFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _isProcessing = true);
      try {
        // Simulate diagnosis process
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        _showResultDialog(image.path);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error importing image: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  void _showResultDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                      'Plant Diagnosis',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B4332),
                      ),
                    ),
                    Text(
                      '85% confidence',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoSection('Diagnosis', 'Healthy'),
                _buildInfoSection('Recommendation',
                    'Your plant is in good condition. Continue with regular care.'),
                _buildInfoSection('Watering', 'Water when top soil is dry'),
                _buildInfoSection('Sunlight', 'Bright indirect light'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to care instructions
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4332),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('View Care Instructions'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapToFocus(TapUpDetails details, BoxConstraints constraints) async {
    if (_controller == null) return;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    setState(() {
      _focusPoint = localPosition;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _focusPoint = null;
    });
  }

  void _showCustomDiagnosisDialog(bool hasHoleOnLeaves) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Diagnosis Result'),
        content: Text(
          hasHoleOnLeaves
              ? 'Your plant is not healthy. Get more tips.'
              : 'Your plant is healthy. Keep it up.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (_isCameraInitialized)
              GestureDetector(
                onTapUp: (details) =>
                    _onTapToFocus(details, const BoxConstraints()),
                child: Stack(
                  children: [
                    CameraPreview(_controller!),
                    if (_focusPoint != null)
                      Positioned(
                        left: _focusPoint!.dx - 20,
                        top: _focusPoint!.dy - 20,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    // Add scanning box overlay
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            // Corner decorations
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.white, width: 3),
                                    left: BorderSide(
                                        color: Colors.white, width: 3),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.white, width: 3),
                                    right: BorderSide(
                                        color: Colors.white, width: 3),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.white, width: 3),
                                    left: BorderSide(
                                        color: Colors.white, width: 3),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.white, width: 3),
                                    right: BorderSide(
                                        color: Colors.white, width: 3),
                                  ),
                                ),
                              ),
                            ),
                            // Scanning line animation
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      _animation.value *
                                          MediaQuery.of(context).size.width *
                                          0.8,
                                    ),
                                    child: Container(
                                      height: 2,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isProcessing)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Tooltip(
                      message: 'Import from Gallery',
                      child: _BottomIcon(
                        icon: Icons.photo_library,
                        onTap: _isProcessing ? null : _onImportFromGallery,
                      ),
                    ),
                    Tooltip(
                      message: 'Diagnose Plant',
                      child: AnimatedScale(
                        scale: _isProcessing ? 0.95 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: _isProcessing ? null : _onDiagnosePressed,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _isProcessing
                                  ? Colors.grey
                                  : const Color(0xFF23C16B),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.4),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(18),
                            child: _isProcessing
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Icon(Icons.favorite,
                                    color: Colors.white, size: 32),
                          ),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Flash',
                      child: _BottomIcon(
                        icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        onTap: _toggleFlash,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _BottomIcon({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
