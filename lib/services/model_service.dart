import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelService {
  Interpreter? _interpreter;
  List<String> labels = [];

  // LOAD MODEL
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/tomat_model.tflite');
      print("✅ MODEL LOADED");
    } catch (e) {
      print("❌ ERROR LOAD MODEL: $e");
    }
  }

  // LOAD LABEL
  Future<void> loadLabels() async {
    try {
      String data = await rootBundle.loadString('assets/labels.txt');
      labels = data.split('\n').map((e) => e.trim()).toList();
      print("✅ LABEL LOADED: $labels");
    } catch (e) {
      print("❌ ERROR LOAD LABEL: $e");
    }
  }

  // PREDICT
  Future<Map<String, dynamic>> predict(File image) async {
    if (_interpreter == null) {
      throw Exception("Model belum di-load");
    }

    final bytes = await image.readAsBytes();
    img.Image? ori = img.decodeImage(bytes);

    if (ori == null) {
      throw Exception("Gagal membaca gambar");
    }

    img.Image resized = img.copyResize(ori, width: 224, height: 224);

    // INPUT NORMALIZATION
    var input = List.generate(
      1,
      (i) => List.generate(
        224,
        (x) => List.generate(
          224,
          (y) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

    _interpreter!.run(input, output);

    // 🔥 LANGSUNG PAKAI OUTPUT (TANPA SOFTMAX)
    List<double> probs = List<double>.from(output[0]);

    double maxProb = probs.reduce((a, b) => a > b ? a : b);
    int index = probs.indexOf(maxProb);

    // DEBUG
    print("OUTPUT MODEL: $probs");
    print("PREDICT: ${labels[index]} (${(maxProb * 100).toStringAsFixed(2)}%)");

    return {
      "label": labels[index],
      "accuracy": double.parse((maxProb * 100).toStringAsFixed(2)),
    };
  }
}