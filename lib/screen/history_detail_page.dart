// lib/screen/history_detail_page.dart
import 'package:flutter/material.dart';
import '../models/history_item.dart';

class HistoryDetailPage extends StatelessWidget {
  final HistoryItem historyItem;

  const HistoryDetailPage({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: _buildModernAppBar(context, isSmallScreen),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeroImageSection(isSmallScreen),
            _buildContentSection(isSmallScreen),
          ],
        ),
      ),
    );
  }

  // ==================== FUNGSI STATUS YANG SUDAH DIPERBAIKI ====================
  // Helper: Mendapatkan label status - SESUAI 11 LABEL (SAMA SEPERTI DI HOME PAGE)
  String _getStatusLabel(String label) {
    final lowerLabel = label.toLowerCase().trim();
    
    // ========== SEHAT ==========
    if (lowerLabel == 'healthy') {
      return 'Sehat';
    }
    
    // ========== PENYAKIT JAMUR (FUNGI) ==========
    if (lowerLabel == 'late_blight' ||
        lowerLabel == 'early_blight' ||
        lowerLabel == 'leaf_mold' ||
        lowerLabel == 'septoria_leaf_spot' ||
        lowerLabel == 'target_spot' ||
        lowerLabel == 'powdery_mildew') {
      return 'Penyakit Jamur';
    }
    
    // ========== INFEKSI VIRUS ==========
    if (lowerLabel == 'tomato_yellow_leaf_curl_virus' ||
        lowerLabel == 'tomato_mosaic_virus') {
      return 'Infeksi Virus';
    }
    
    // ========== INFEKSI BAKTERI ==========
    if (lowerLabel == 'bacterial_spot') {
      return 'Infeksi Bakteri';
    }
    
    // ========== HAMA (PEST) ==========
    if (lowerLabel == 'spider_mites two-spotted_spider_mite' ||
        lowerLabel.contains('spider_mites') ||
        lowerLabel.contains('spider mite')) {
      return 'Serangan Hama';
    }
    
    // ========== DEFAULT ==========
    return 'Penyakit Lain';
  }

  // Helper: Mendapatkan warna status - SESUAI 11 LABEL (SAMA SEPERTI DI HOME PAGE)
  Color _getStatusColor(String label) {
    final lowerLabel = label.toLowerCase().trim();
    
    // ========== SEHAT - Hijau ==========
    if (lowerLabel == 'healthy') {
      return const Color(0xFF506600);
    }
    
    // ========== PENYAKIT JAMUR - Merah ==========
    if (lowerLabel == 'late_blight' ||
        lowerLabel == 'early_blight' ||
        lowerLabel == 'leaf_mold' ||
        lowerLabel == 'septoria_leaf_spot' ||
        lowerLabel == 'target_spot' ||
        lowerLabel == 'powdery_mildew') {
      return const Color(0xFFBA1A1A);
    }
    
    // ========== INFEKSI VIRUS - Ungu ==========
    if (lowerLabel == 'tomato_yellow_leaf_curl_virus' ||
        lowerLabel == 'tomato_mosaic_virus') {
      return const Color(0xFF7B1FA2);
    }
    
    // ========== INFEKSI BAKTERI - Oranye ==========
    if (lowerLabel == 'bacterial_spot') {
      return const Color(0xFFE65100);
    }
    
    // ========== HAMA - Jingga ==========
    if (lowerLabel == 'spider_mites two-spotted_spider_mite' ||
        lowerLabel.contains('spider_mites') ||
        lowerLabel.contains('spider mite')) {
      return const Color(0xFFB85C00);
    }
    
    // ========== DEFAULT - Abu-abu ==========
    return const Color(0xFF727972);
  }

  // Helper: Mendapatkan ikon status
  IconData _getStatusIcon(String label) {
    final lowerLabel = label.toLowerCase().trim();
    
    if (lowerLabel == 'healthy') {
      return Icons.check_circle_outline;
    }
    
    // Untuk semua jenis penyakit
    return Icons.warning_amber_outlined;
  }

  // AppBar Modern
  PreferredSizeWidget _buildModernAppBar(BuildContext context, bool isSmallScreen) {
    final statusLabel = _getStatusLabel(historyItem.label);
    final statusColor = _getStatusColor(historyItem.label);
    
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF163321)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Riwayat',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 13,
              color: statusColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
      centerTitle: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
        ),
      ),
    );
  }

  // Hero Image Section dengan Gradient
  Widget _buildHeroImageSection(bool isSmallScreen) {
    final statusLabel = _getStatusLabel(historyItem.label);
    final statusColor = _getStatusColor(historyItem.label);
    final statusIcon = _getStatusIcon(historyItem.label);
    
    return Stack(
      children: [
        // Background Image
        Container(
          height: isSmallScreen ? 300 : 350,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            image: DecorationImage(
              image: NetworkImage(historyItem.imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
        ),
        
        // Gradient Overlay
        Container(
          height: isSmallScreen ? 300 : 350,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),
        
        // Status Badge
        Positioned(
          top: isSmallScreen ? 20 : 24,
          right: isSmallScreen ? 20 : 24,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  statusIcon,
                  size: isSmallScreen ? 16 : 18,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Title di atas gambar
        Positioned(
          bottom: isSmallScreen ? 20 : 24,
          left: isSmallScreen ? 20 : 24,
          right: isSmallScreen ? 20 : 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                historyItem.diseaseName.isNotEmpty 
                    ? historyItem.diseaseName 
                    : historyItem.label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: isSmallScreen ? 14 : 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(historyItem.createdAt),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Content Section
  Widget _buildContentSection(bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard(isSmallScreen),
          const SizedBox(height: 16),
          _buildDescriptionCard(isSmallScreen),
          const SizedBox(height: 16),
          _buildRecommendationCard(isSmallScreen),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Card Info Utama
  Widget _buildInfoCard(bool isSmallScreen) {
    final statusColor = _getStatusColor(historyItem.label);
    final statusLabel = _getStatusLabel(historyItem.label);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: statusColor,
                    size: isSmallScreen ? 20 : 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Informasi Diagnosis',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF191C1B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isSmallScreen ? 1 : 2,
              childAspectRatio: 5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildInfoRow(
                  Icons.pest_control_outlined,
                  'Status',
                  statusLabel,
                  statusColor,
                  isSmallScreen,
                ),
                _buildInfoRow(
                  Icons.speed_outlined,
                  'Akurasi',
                  '${historyItem.accuracy.toStringAsFixed(1)}%',
                  Colors.blue,
                  isSmallScreen,
                ),
                _buildInfoRow(
                  Icons.warning_amber_outlined,
                  'Tingkat Keparahan',
                  historyItem.severity,
                  Colors.orange,
                  isSmallScreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Card Deskripsi
  Widget _buildDescriptionCard(bool isSmallScreen) {
    final description = historyItem.description.isNotEmpty 
        ? historyItem.description 
        : 'Tidak ada deskripsi untuk penyakit ini.';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: Colors.blue.shade700,
                    size: isSmallScreen ? 20 : 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF191C1B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 15,
                height: 1.5,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card Rekomendasi
  Widget _buildRecommendationCard(bool isSmallScreen) {
    final List<IconData> fixedIcons = [
      Icons.handyman,
      Icons.water_drop,
      Icons.science
    ];
    
    final List<String> iconTitles = [
      'Perawatan Tanaman & Sanitasi',
      'Pengairan & Kelembaban', 
      'Perlindungan & Pengobatan',
    ];
    
    List<String> paragraphs = _splitIntoParagraphs(historyItem.recommendation);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: Colors.green[700],
                    size: isSmallScreen ? 20 : 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Rekomendasi Penanganan',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF191C1B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            ...List.generate(paragraphs.length, (index) {
              String content = paragraphs[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index != paragraphs.length - 1 ? 24 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        fixedIcons[index],
                        color: Colors.green[700],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            iconTitles[index],
                            style: TextStyle(
                              fontSize: isSmallScreen ? 15 : 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF191C1B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            content,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 14,
                              height: 1.5,
                              color: Colors.grey[700],
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
    );
  }

  // ==================== FUNGSI PEMISAH PARAGRAF ====================
  List<String> _splitIntoParagraphs(String text) {
    if (text.isEmpty) return ['Tidak ada rekomendasi'];
    
    List<String> paragraphs = text.split(RegExp(r'\n\s*\n'));
    
    List<String> cleaned = [];
    for (String p in paragraphs) {
      String trimmed = p.trim();
      if (trimmed.isNotEmpty) {
        List<String> lines = trimmed.split('\n');
        if (lines.length > 1) {
          if (lines[0].length < 50 && lines[0].contains(':') == false) {
            lines.removeAt(0);
            trimmed = lines.join('\n').trim();
          }
        }
        cleaned.add(trimmed);
      }
    }
    
    while (cleaned.length < 3) {
      cleaned.add('Informasi lebih lanjut tidak tersedia.');
    }
    
    return cleaned.sublist(0, 3);
  }

  // Helper Widget: Info Row
  Widget _buildInfoRow(IconData icon, String label, String value, Color color, bool isSmallScreen) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: isSmallScreen ? 18 : 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 11 : 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF191C1B),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper: Format tanggal
  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }
}