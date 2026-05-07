// lib/screen/history_page.dart
import 'package:flutter/material.dart';
import '../services/history_service.dart';
import '../models/history_item.dart';
import 'history_detail_page.dart';
import '../widgets/bottom_nav_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService historyService = HistoryService();

  List<HistoryItem> items = [];
  Set<String> selectedIds = {};
  bool isLoading = true;
  bool isSelectionMode = false;
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    final data = await historyService.fetchHistory();
    setState(() {
      items = data;
      isLoading = false;
    });
  }

  void _onNavTap(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/info');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/scanner');
        break;
      case 3:
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profil');
        break;
    }
  }

  String _shortenText(String text, int maxWords) {
    List<String> words = text.split(' ');
    if (words.length <= maxWords) return text;
    return '${words.take(maxWords).join(' ')}...';
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

  // Helper: Cek apakah sehat (untuk UI sederhana)
  bool _isHealthy(String label) {
    final lowerLabel = label.toLowerCase().trim();
    return lowerLabel == 'healthy';
  }

  Future<void> _deleteSingle(HistoryItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Data", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Yakin ingin menghapus ${item.diseaseName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Batal", style: TextStyle(color: Colors.grey.shade600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await historyService.deleteHistory(item.id, item.imageUrl);
      await loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Data berhasil dihapus"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _deleteMultiple() async {
    if (selectedIds.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Banyak Data", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Yakin ingin menghapus ${selectedIds.length} data yang dipilih?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Batal", style: TextStyle(color: Colors.grey.shade600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => isLoading = true);
      for (var item in items) {
        if (selectedIds.contains(item.id)) {
          await historyService.deleteHistory(item.id, item.imageUrl);
        }
      }
      selectedIds.clear();
      isSelectionMode = false;
      await loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Berhasil menghapus data"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _enterSelectionMode() {
    setState(() {
      isSelectionMode = true;
      selectedIds.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedIds.clear();
    });
  }

  void _selectAll() {
    setState(() {
      if (selectedIds.length == items.length) {
        selectedIds.clear();
      } else {
        selectedIds.addAll(items.map((e) => e.id));
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: _buildAppBar(isSmallScreen),
      body: Column(
        children: [
          if (isSelectionMode) _buildSelectionBar(isSmallScreen),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2D8B5A)))
                : items.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = selectedIds.contains(item.id);
                      final titleText = item.diseaseName.isNotEmpty
                          ? item.diseaseName
                          : item.label;
                      final shortenedTitle = _shortenText(titleText, 2);
                      // Menggunakan fungsi status yang sudah diperbaiki
                      final statusLabel = _getStatusLabel(item.label);
                      final isHealthy = _isHealthy(item.label);
                      final statusColor = _getStatusColor(item.label);

                      return _buildHistoryCard(
                        item: item,
                        isSelected: isSelected,
                        shortenedTitle: shortenedTitle,
                        statusLabel: statusLabel,
                        isHealthy: isHealthy,
                        statusColor: statusColor,
                        isSmallScreen: isSmallScreen,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isSmallScreen) {
    return AppBar(
      automaticallyImplyLeading: isSelectionMode,
      leading: isSelectionMode
          ? IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.black87),
              onPressed: _exitSelectionMode,
            )
          : null,
      backgroundColor: Colors.white,
      elevation: 0,
      title: isSelectionMode
          ? Text(
              '${selectedIds.length} dipilih',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )
          : const Text(
              "Riwayat Scan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black87, size: 24),
          onSelected: (value) {
            if (value == 'select') {
              _enterSelectionMode();
            } else if (value == 'delete_all') {
              _showDeleteAllDialog();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'select',
              child: Row(
                children: [
                  Icon(Icons.checklist_rounded, color: Colors.blue, size: 20),
                  SizedBox(width: 12),
                  Text("Pilih Banyak"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete_all',
              child: Row(
                children: [
                  Icon(Icons.delete_sweep_rounded, color: Colors.red, size: 20),
                  SizedBox(width: 12),
                  Text("Hapus Semua"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Selection Bar yang sudah diperbaiki (tidak overflow)
  Widget _buildSelectionBar(bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border(bottom: BorderSide(color: Colors.green.shade100)),
      ),
      child: Row(
        children: [
          // Icon checklist
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.checklist_rounded,
              color: Colors.green.shade700,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          // Teks (menggunakan Expanded agar tidak overflow)
          Expanded(
            child: Text(
              'Pilih item yang akan dihapus',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade800,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          // Tombol pilih semua
          GestureDetector(
            onTap: _selectAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selectedIds.length == items.length
                        ? Icons.deselect_rounded
                        : Icons.select_all_rounded,
                    size: 14,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    selectedIds.length == items.length ? "Batal" : "Semua",
                    style: TextStyle(fontSize: 11, color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Tombol hapus
          GestureDetector(
            onTap: selectedIds.isNotEmpty ? _deleteMultiple : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: selectedIds.isNotEmpty ? Colors.red.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selectedIds.isNotEmpty ? Colors.red.shade200 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_rounded,
                    size: 14,
                    color: selectedIds.isNotEmpty ? Colors.red : Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Hapus${selectedIds.isNotEmpty ? '(${selectedIds.length})' : ''}",
                    style: TextStyle(
                      fontSize: 11,
                      color: selectedIds.isNotEmpty ? Colors.red : Colors.grey.shade400,
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

  Widget _buildHistoryCard({
    required HistoryItem item,
    required bool isSelected,
    required String shortenedTitle,
    required String statusLabel,
    required bool isHealthy,
    required Color statusColor,
    required bool isSmallScreen,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isSelected ? Colors.green.shade50 : Colors.white,
            border: isSelected
                ? Border.all(color: Colors.green.shade400, width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (isSelectionMode) {
                setState(() {
                  if (isSelected) {
                    selectedIds.remove(item.id);
                  } else {
                    selectedIds.add(item.id);
                  }
                  if (selectedIds.isEmpty) {
                    isSelectionMode = false;
                  }
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryDetailPage(historyItem: item),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Transform.scale(
                        scale: 0.9,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) {
                            setState(() {
                              if (isSelected) {
                                selectedIds.remove(item.id);
                              } else {
                                selectedIds.add(item.id);
                              }
                              if (selectedIds.isEmpty) {
                                isSelectionMode = false;
                              }
                            });
                          },
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          side: BorderSide(
                            color: isSelected ? Colors.green : Colors.grey.shade400,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),

                  // Image - Menggunakan statusColor untuk gradient
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          isHealthy ? Colors.green.shade400 : statusColor,
                          isHealthy ? Colors.green.shade200 : statusColor.withOpacity(0.5),
                        ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        item.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade100,
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey.shade400,
                              size: 24,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Badge status - Menggunakan statusLabel yang lengkap
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Badge akurasi
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: item.accuracy >= 80
                                    ? Colors.green.shade50
                                    : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 6,
                                    color: item.accuracy >= 80
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${item.accuracy.toStringAsFixed(1)}%",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: item.accuracy >= 80
                                          ? Colors.green.shade700
                                          : Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          shortenedTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 10,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(item.createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Menu titik tiga
                  if (!isSelectionMode)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.grey, size: 18),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteSingle(item);
                        } else if (value == 'select') {
                          _enterSelectionMode();
                          setState(() {
                            selectedIds.add(item.id);
                          });
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'select',
                          child: Row(
                            children: [
                              Icon(Icons.checklist_rounded, color: Colors.blue, size: 18),
                              SizedBox(width: 10),
                              Text("Pilih Item Ini"),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_rounded, color: Colors.red, size: 18),
                              SizedBox(width: 10),
                              Text("Hapus Item Ini"),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Hapus Semua Data",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Yakin ingin menghapus SEMUA riwayat scan?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: Colors.grey.shade600)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => isLoading = true);
              for (var item in items) {
                await historyService.deleteHistory(item.id, item.imageUrl);
              }
              await loadData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Semua data berhasil dihapus"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text(
              "Hapus Semua",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_rounded,
              size: 50,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Belum ada riwayat",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Scan tanaman untuk melihat riwayat",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}