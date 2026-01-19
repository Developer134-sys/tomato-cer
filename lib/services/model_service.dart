import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelService {
  Interpreter? _interpreter;
  List<String> labels = [];

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print("MODEL LOADED");
    } catch (e) {
      print("ERROR LOAD MODEL: $e");
    }
  }

  Future<void> loadLabels() async {
    String data = await rootBundle.loadString('assets/labels.txt');
    labels = data.split('\n').map((e) => e.trim()).toList();
    print("LABEL LOADED: $labels");
  }

  Future<Map<String, dynamic>> predict(File image) async {
    final bytes = await image.readAsBytes();
    img.Image? ori = img.decodeImage(bytes);

    img.Image resized = img.copyResize(ori!, width: 224, height: 224);

    var input = List.generate(
      1,
      (i) => List.generate(
        224,
        (x) => List.generate(
          224,
          (y) => [
            resized.getPixel(x, y).r / 255.0,
            resized.getPixel(x, y).g / 255.0,
            resized.getPixel(x, y).b / 255.0,
          ],
        ),
      ),
    );

    var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

    _interpreter!.run(input, output);

    List<double> score = List<double>.from(output[0]);
    double maxProb = score.reduce((a, b) => a > b ? a : b);
    int index = score.indexOf(maxProb);

    return {
      "label": labels[index],
      "accuracy": maxProb * 100,
    };
  }
}
