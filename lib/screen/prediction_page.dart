import 'dart:io';
import 'package:flutter/material.dart';
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

class _PredictionPageState extends State<PredictionPage> {
  File? _image;
  String label = "";
  double accuracy = 0.0;
  bool _isLoading = false;

  final modelService = ModelService();

  Future pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _isLoading = true;
        label = "";
        accuracy = 0.0;
      });

      try {
        var result = await modelService.predict(_image!);

        String predictedLabel = result["label"];
        double predictedAccuracy = result["accuracy"];

        final historyService = HistoryService();
        String imageUrl = await historyService.uploadImageToStorage(_image!);

        await historyService.saveHistory(
          imageUrl: imageUrl,
          label: predictedLabel,
          accuracy: predictedAccuracy,
          severity: SeverityService.getSeverity(predictedLabel),
          recommendation:
              RecommendationService.recommendations[predictedLabel]!,
        );

        setState(() {
          label = predictedLabel;
          accuracy = predictedAccuracy;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        print("Error saving history: $e");
      }
    }
  }

  Future takePicture() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _isLoading = true;
        label = "";
        accuracy = 0.0;
      });

      try {
        var result = await modelService.predict(_image!);

        String predictedLabel = result["label"];
        double predictedAccuracy = result["accuracy"];

        final historyService = HistoryService();
        String imageUrl = await historyService.uploadImageToStorage(_image!);

        await historyService.saveHistory(
          imageUrl: imageUrl,
          label: predictedLabel,
          accuracy: predictedAccuracy,
          severity: SeverityService.getSeverity(predictedLabel),
          recommendation:
              RecommendationService.recommendations[predictedLabel]!,
        );

        setState(() {
          label = predictedLabel;
          accuracy = predictedAccuracy;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        print("Error saving history: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    modelService.loadModel();
    modelService.loadLabels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Prediksi Penyakit Tomat",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Preview Gambar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 15),
                        _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    Image.file(
                                      _image!,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    if (_isLoading)
                                      Container(
                                        height: 200,
                                        width: double.infinity,
                                        color: Colors.black.withOpacity(0.5),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo_library,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Belum ada gambar",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.photo_library, size: 20),
                          label: const Text("Galeri", style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.green.shade300),
                            ),
                            elevation: 2,
                          ),
                          onPressed: pickImage,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.camera_alt, size: 20),
                          label: const Text("Kamera", style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          onPressed: takePicture,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  if (_isLoading)
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Menganalisis gambar...",
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),

                  if (label.isNotEmpty && !_isLoading)
                    ResultCard(
                      diseaseName: RecommendationService.diseaseNames[label]!,
                      accuracy: accuracy,
                      severity: SeverityService.getSeverity(label),
                      recommendation:
                          "- " + RecommendationService.recommendations[label]!,
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
