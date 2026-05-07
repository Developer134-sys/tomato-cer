import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../services/model_service.dart';
import '../services/recommendation_service.dart';
import '../services/severity_service.dart';
import '../widgets/result_card.dart';
import '../services/history_service.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage>
    with TickerProviderStateMixin {
  File? _image;
  String label = "";
  double accuracy = 0.0;
  bool _isLoading = false;
  bool _isPredicting = false;
  bool _isCameraReady = false;

  // Variabel untuk kamera
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? _cameras;

  // Animasi
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  // Variabel untuk menyimpan hasil prediksi sementara
  String? _tempLabel;
  double? _tempAccuracy;

  final modelService = ModelService();

  @override
  void initState() {
    super.initState();
    modelService.loadModel();
    modelService.loadLabels();
    _initCamera();

    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanAnimationController, curve: Curves.easeInOut),
    );

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _blinkAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanAnimationController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) return;

      final camera = _cameras!.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _cameraController!.initialize();
      await _initializeControllerFuture;

      if (mounted) {
        setState(() {
          _isCameraReady = true;
        });
      }
    } catch (e) {
      debugPrint("Error init kamera: $e");
    }
  }

  Future<void> _captureImage() async {
    if (!_isCameraReady || _cameraController == null) return;

    try {
      final XFile picture = await _cameraController!.takePicture();

      setState(() {
        _image = File(picture.path);
        _isPredicting = true;
        label = "";
        accuracy = 0.0;
        _tempLabel = null;
        _tempAccuracy = null;
      });

      await _performPrediction(File(picture.path));
    } catch (e) {
      debugPrint("Error capture: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengambil gambar")),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _isPredicting = true;
        label = "";
        accuracy = 0.0;
        _tempLabel = null;
        _tempAccuracy = null;
      });

      await _performPrediction(File(picked.path));
    }
  }

  Future<void> _performPrediction(File imageFile) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      var result = await modelService.predict(imageFile);

      String predictedLabel = result["label"];
      double predictedAccuracy = result["accuracy"];

      setState(() {
        _tempLabel = predictedLabel;
        _tempAccuracy = predictedAccuracy;
        label = predictedLabel;
        accuracy = predictedAccuracy;
        _isPredicting = false;
      });
    } catch (e) {
      setState(() {
        _isPredicting = false;
      });
      print("Error during prediction: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal melakukan prediksi: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _saveToHistory() async {
    if (_tempLabel == null || _tempAccuracy == null || _image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final historyService = HistoryService();
      String imageUrl = await historyService.uploadImageToStorage(_image!);

      await historyService.saveHistory(
        imageUrl: imageUrl,
        label: _tempLabel!,
        accuracy: _tempAccuracy!,
        severity: SeverityService.getSeverity(_tempLabel!),
        recommendation: RecommendationService.getRecommendation(_tempLabel!),
        description: RecommendationService.getDescription(_tempLabel!), 
        diseaseName: RecommendationService.getDiseaseName(_tempLabel!),// TAMBAHKAN INI
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text("Hasil berhasil disimpan ke riwayat")),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error saving history: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text("Gagal menyimpan: $e")),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _cancel() {
    setState(() {
      _image = null;
      label = "";
      accuracy = 0.0;
      _tempLabel = null;
      _tempAccuracy = null;
      _isPredicting = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final boxSize = screenSize.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isCameraReady && _cameraController != null && _image == null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else if (_image != null)
            Positioned.fill(
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
            )
          else if (!_isCameraReady)
            Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.greenAccent),
                    SizedBox(height: 20),
                    Text(
                      "Mengaktifkan kamera...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

          if (_image == null && _isCameraReady)
            _buildScannerOverlay(screenSize, boxSize),

          if (_image == null && _isCameraReady)
            _buildScanLine(screenSize, boxSize),

          if (_image == null && _isCameraReady)
            _buildDetectingIndicator(),

          if (_image == null && _isCameraReady)
            _buildControlButtons(),

          if (_image == null && _isCameraReady)
            _buildGuideText(),

          if (_image != null)
            _buildResultView(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay(Size screenSize, double boxSize) {
    return CustomPaint(
      painter: ScannerOverlayPainter(
        blinkOpacity: _blinkAnimation.value,
        screenSize: screenSize,
        boxSize: boxSize,
      ),
      size: screenSize,
    );
  }

  Widget _buildScanLine(Size screenSize, double boxSize) {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        final left = (screenSize.width - boxSize) / 2;
        final top = (screenSize.height - boxSize) / 2;
        final scanY = top + (_scanAnimation.value * boxSize);

        return Positioned(
          left: left,
          top: scanY,
          child: Container(
            width: boxSize,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.8),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetectingIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: _isPredicting ? Colors.greenAccent : Colors.white38,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isPredicting
                    ? Colors.greenAccent.withOpacity(0.3)
                    : Colors.transparent,
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isPredicting)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.greenAccent,
                  ),
                )
              else
                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
              const SizedBox(width: 10),
              Text(
                _isPredicting ? "DETECTING • AI ANALYSING" : "READY",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: _isPredicting ? Colors.greenAccent : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildControlButton(
              icon: Icons.photo_library,
              label: "Galeri",
              onTap: _pickFromGallery,
            ),
            const SizedBox(width: 40),
            GestureDetector(
              onTap: _captureImage,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 42,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 40),
            _buildControlButton(
              icon: Icons.flash_auto,
              label: "Auto",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mode flash: Auto")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white30, width: 1),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideText() {
    return Positioned(
      bottom: 140,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          "Posisikan objek dalam kotak hijau",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
            shadows: const [
              Shadow(blurRadius: 4, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // Tombol kembali
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _cancel,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),

            // Konten scrollable
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Gambar daun
                    if (_image != null && !_isPredicting)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            _image!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Loading state
                    if (_isPredicting)
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Menganalisis gambar...",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Hasil prediksi
                    if (label.isNotEmpty && !_isPredicting && !_isLoading)
                      ResultCard(
                        diseaseName: RecommendationService.getDiseaseName(label),
                        accuracy: accuracy,
                        severity: SeverityService.getSeverity(label),
                        label: label,
                        onSave: _saveToHistory,
                        onRescan: _cancel,
                      ),

                    // Saving state
                    if (_isLoading && label.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Menyimpan ke Riwayat...",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),
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

class ScannerOverlayPainter extends CustomPainter {
  final double blinkOpacity;
  final Size screenSize;
  final double boxSize;

  ScannerOverlayPainter({
    required this.blinkOpacity,
    required this.screenSize,
    required this.boxSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final left = (screenSize.width - boxSize) / 2;
    final top = (screenSize.height - boxSize) / 2;
    final Rect scanRect = Rect.fromLTWH(left, top, boxSize, boxSize);

    final Paint overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.65);
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.width, screenSize.height), overlayPaint);

    final Paint clearPaint = Paint()
      ..blendMode = BlendMode.clear
      ..color = Colors.transparent;
    canvas.saveLayer(Rect.fromLTWH(0, 0, screenSize.width, screenSize.height), Paint());
    canvas.drawRect(scanRect, clearPaint);
    canvas.restore();

    final Paint borderPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.8 * blinkOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final Paint borderInnerPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final RRect rrect = RRect.fromRectAndRadius(scanRect, const Radius.circular(20));
    canvas.drawRRect(rrect, borderPaint);
    canvas.drawRRect(rrect, borderInnerPaint);

    final cornerLength = boxSize * 0.12;
    final cornerPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.9)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(left, top + cornerLength), Offset(left, top), cornerPaint);
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), cornerPaint);
    canvas.drawLine(Offset(left + boxSize - cornerLength, top), Offset(left + boxSize, top), cornerPaint);
    canvas.drawLine(Offset(left + boxSize, top), Offset(left + boxSize, top + cornerLength), cornerPaint);
    canvas.drawLine(Offset(left, top + boxSize - cornerLength), Offset(left, top + boxSize), cornerPaint);
    canvas.drawLine(Offset(left, top + boxSize), Offset(left + cornerLength, top + boxSize), cornerPaint);
    canvas.drawLine(Offset(left + boxSize - cornerLength, top + boxSize), Offset(left + boxSize, top + boxSize), cornerPaint);
    canvas.drawLine(Offset(left + boxSize, top + boxSize - cornerLength), Offset(left + boxSize, top + boxSize), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.blinkOpacity != blinkOpacity;
  }
}