import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import '../services/plant_identifier_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isProcessing = false;
  Offset? _focusPoint;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final PlantIdentifierService _plantIdentifier = PlantIdentifierService();

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

  Future<void> _onIdentifyPressed() async {
    if (!_isCameraInitialized || _controller == null || _isProcessing) return;
    setState(() {
      _isProcessing = true;
    });
    try {
      final XFile image = await _controller!.takePicture();
      final result = await _plantIdentifier.identifyPlant(File(image.path));
      final plantInfo = PlantInfo.fromJson(result);
      if (!mounted) return;
      _showResultDialog(image.path, plantInfo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error identifying plant: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _onImportFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _isProcessing = true);
      try {
        final result = await _plantIdentifier.identifyPlant(File(image.path));
        final plantInfo = PlantInfo.fromJson(result);
        if (!mounted) return;
        _showResultDialog(image.path, plantInfo);
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

  void _showResultDialog(String imagePath, PlantInfo plantInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Plant Identified'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(imagePath),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              plantInfo.commonName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              plantInfo.scientificName,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              plantInfo.description,
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
        ],
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
    // Optionally, you can call camera focus here if supported
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _focusPoint = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview with tap-to-focus
          if (_isCameraInitialized && _controller != null)
            LayoutBuilder(
              builder: (context, constraints) => GestureDetector(
                onTapUp: (details) => _onTapToFocus(details, constraints),
                child: CameraPreview(_controller!),
              ),
            ),
          // Overlay
          if (_isCameraInitialized)
            _ScannerOverlay(
              animation: _animation,
              focusPoint: _focusPoint,
            ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message: 'Close',
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 32),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text(
                    'Identify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Tooltip(
                    message: 'Help',
                    child: IconButton(
                      icon: const Icon(Icons.help_outline,
                          color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Instruction text
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Place the plant a little away from the camera.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
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
                  message: 'Identify',
                  child: AnimatedScale(
                    scale: _isProcessing ? 0.95 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: _isProcessing ? null : _onIdentifyPressed,
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
                            : const Icon(Icons.spa,
                                color: Colors.white, size: 32),
                      ),
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Flash',
                  child: _BottomIcon(
                    icon: Icons.flash_on,
                    onTap: _toggleFlash,
                    color: _isFlashOn ? Colors.yellow : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Identifying…',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  final Animation<double> animation;
  final Offset? focusPoint;
  const _ScannerOverlay({required this.animation, this.focusPoint});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth * 0.85;
        final double height = width;
        final double top = (constraints.maxHeight - height) / 2;
        final double left = (constraints.maxWidth - width) / 2;
        return Stack(
          children: [
            // Blur/dark overlay outside scan area
            Positioned.fill(
              child: CustomPaint(
                painter: _OverlayBlurPainter(
                  scanRect: Rect.fromLTWH(left, top, width, height),
                ),
              ),
            ),
            // Scan area border with shadow
            Positioned(
              top: top,
              left: left,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            // Glowing/pulsing scan line
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Positioned(
                  top: top + (height - 4) * animation.value,
                  left: left,
                  child: Container(
                    width: width,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.greenAccent.withOpacity(0.7),
                          Colors.greenAccent,
                          Colors.greenAccent.withOpacity(0.7),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.7),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
            // Tap-to-focus indicator
            if (focusPoint != null)
              Positioned(
                left: focusPoint!.dx - 24,
                top: focusPoint!.dy - 24,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.greenAccent, width: 2),
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.greenAccent.withOpacity(0.15),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _OverlayBlurPainter extends CustomPainter {
  final Rect scanRect;
  _OverlayBlurPainter({required this.scanRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..blendMode = BlendMode.srcOver;
    // Top
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, scanRect.top), paint);
    // Bottom
    canvas.drawRect(
        Rect.fromLTRB(0, scanRect.bottom, size.width, size.height), paint);
    // Left
    canvas.drawRect(
        Rect.fromLTRB(0, scanRect.top, scanRect.left, scanRect.bottom), paint);
    // Right
    canvas.drawRect(
        Rect.fromLTRB(
            scanRect.right, scanRect.top, size.width, scanRect.bottom),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  const _BottomIcon(
      {required this.icon, required this.onTap, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(14),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
