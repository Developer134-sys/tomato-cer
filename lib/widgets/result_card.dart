import 'package:flutter/material.dart';
import '../services/recommendation_service.dart';

class ResultCard extends StatelessWidget {
  final String diseaseName;
  final double accuracy;
  final String severity;
  final String label;
  final VoidCallback onSave;
  final VoidCallback onRescan;

  const ResultCard({
    super.key,
    required this.diseaseName,
    required this.accuracy,
    required this.severity,
    required this.label,
    required this.onSave,
    required this.onRescan,
  });

  @override
  Widget build(BuildContext context) {
    final description = RecommendationService.getDescription(label);
    final recommendation = RecommendationService.getRecommendation(label);
    final isHealthy = label == "healthy";

    // Ambil 3 paragraf dari rekomendasi
    List<String> paragraphs = _splitIntoParagraphs(recommendation);

    // Ikon TETAP untuk 3 paragraf
    final List<IconData> fixedIcons = [
      Icons.handyman,      // Ikon Perawatan Tanaman & Sanitasi
      Icons.water_drop,    // Ikon Pengairan & Kelembaban
      Icons.science,       // Ikon Perlindungan & Pengobatan
    ];

    final List<String> iconTitles = [
      'Perawatan Tanaman & Sanitasi',
      'Pengairan & Kelembaban',
      'Perlindungan & Pengobatan',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KARTU 1: Informasi Diagnosa
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE ATAS
              const Text(
                "PENYAKIT TERDETEKSI",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 8),

              // NAMA PENYAKIT + BADGE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      diseaseName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      severity,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // AKURASI TEXT
              Row(
                children: [
                  const Text(
                    "Tingkat Akurasi ",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    "${accuracy.toStringAsFixed(0)}% Confirmed",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // PROGRESS BAR
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: accuracy / 100,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // KARTU 2: Informasi Penyakit (Deskripsi)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Deskripsi Penyakit",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // KARTU 3: Rekomendasi Penanganan dengan 3 Ikon Tetap
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 20,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Rekomendasi Penanganan",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Menampilkan 3 paragraf dengan ikon tetap
                ...List.generate(paragraphs.length, (index) {
                  String content = paragraphs[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: index != paragraphs.length - 1 ? 20 : 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ikon tetap
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            fixedIcons[index],
                            color: Colors.green.shade700,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Konten
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                iconTitles[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                content,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Tombol Simpan
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.bookmark_border, size: 20),
            label: const Text(
              "Simpan ke Riwayat",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Tombol Pemindaian Ulang
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRescan,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text(
              "Pemindaian Ulang",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== FUNGSI PEMISAH PARAGRAF ====================
  List<String> _splitIntoParagraphs(String text) {
    if (text.isEmpty) return ['Tidak ada rekomendasi'];

    // Split berdasarkan \n\n (double new line)
    List<String> paragraphs = text.split(RegExp(r'\n\s*\n'));

    // Bersihkan setiap paragraf
    List<String> cleaned = [];
    for (String p in paragraphs) {
      String trimmed = p.trim();
      if (trimmed.isNotEmpty) {
        // Hapus judul asli paragraf (jika ada)
        List<String> lines = trimmed.split('\n');
        if (lines.length > 1) {
          // Jika baris pertama pendek (kemungkinan judul), buang
          if (lines[0].length < 50 && !lines[0].contains(':')) {
            lines.removeAt(0);
            trimmed = lines.join('\n').trim();
          }
        }
        cleaned.add(trimmed);
      }
    }

    // Pastikan minimal 3 paragraf
    while (cleaned.length < 3) {
      cleaned.add('Informasi lebih lanjut tidak tersedia.');
    }

    // Batasi maksimal 3 paragraf
    return cleaned.sublist(0, 3);
  }
}