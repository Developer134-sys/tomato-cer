import 'package:flutter/material.dart';
import '../models/disease_model.dart';

class DiseaseDetailPage extends StatelessWidget {
  final DiseaseInfo disease;

  const DiseaseDetailPage({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text(
          disease.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: disease.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disease Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: disease.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  disease.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            disease.icon,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gambar tidak tersedia',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Description Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with Icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: disease.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            disease.icon,
                            color: disease.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            disease.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: disease.color,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Short Description
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        disease.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Detailed Material with improved formatting
                    const Text(
                      "Informasi Penyakit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    _buildFormattedMateri(disease.materi),

                    const SizedBox(height: 20),

                    // Prevention Tips
                    _buildPreventionTips(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattedMateri(String materi) {
    final lines = materi.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('**') && line.endsWith('**')) {
          // Bold text
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              line.replaceAll('**', ''),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          );
        } else if (line.trim().startsWith('-')) {
          // List item
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    line.substring(1).trim(),
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
              ],
            ),
          );
        } else if (line.trim().isEmpty) {
          // Empty line
          return const SizedBox(height: 8);
        } else {
          // Normal text
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              line,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  Widget _buildPreventionTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text(
                "Tips Pencegahan Umum",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTipChip("Gunakan benih sehat"),
              _buildTipChip("Rotasi tanaman"),
              _buildTipChip("Kebersihan kebun"),
              _buildTipChip("Monitoring rutin"),
              _buildTipChip("Pupuk berimbang"),
              _buildTipChip("Hindari penyiraman daun"),
              _buildTipChip("Sirkulasi udara baik"),
              _buildTipChip("Sanitasi alat"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
      ),
    );
  }
}
