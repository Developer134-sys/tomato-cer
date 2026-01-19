import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String diseaseName;
  final double accuracy;
  final String severity;
  final String recommendation;

  const ResultCard({
    super.key,
    required this.diseaseName,
    required this.accuracy,
    required this.severity,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // penting!
          children: [
            Text(
              diseaseName,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 10),

            Text(
              "Akurasi: ${accuracy.toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),

            Text(
              "Tingkat Serangan: $severity",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),

            // 🔥 Bagian rekomendasi baru
            const Text(
              "Rekomendasi:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              recommendation,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
              softWrap: true,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
