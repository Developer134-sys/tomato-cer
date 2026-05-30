// lib/screen/pustaka_penyakit_page.dart
import 'package:flutter/material.dart';
import '../models/disease_model.dart';
import '../data/disease_data.dart';
import '../screen/disease_detail_page.dart';
import '../widgets/bottom_nav_bar.dart';

class PustakaPenyakitPage extends StatefulWidget {
  const PustakaPenyakitPage({super.key});

  @override
  State<PustakaPenyakitPage> createState() => _PustakaPenyakitPageState();
}

class _PustakaPenyakitPageState extends State<PustakaPenyakitPage> {
  int _currentIndex = 1; // Index 1 untuk halaman Pustaka
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DiseaseInfo> get _filteredDiseases {
    final diseases = DiseaseData.getDiseases();
    if (_searchQuery.isEmpty) return diseases;
    return diseases
        .where(
          (disease) =>
              disease.title.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              disease.description.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  void _onNavTap(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });

    // Navigasi ke halaman yang berbeda
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Halaman saat ini
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/scanner');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/HistoryPage');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern SliverAppBar
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            automaticallyImplyLeading: false, // 👈 INI PENTING

            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade200.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: FlexibleSpaceBar(
                centerTitle: true, // 👈 INI
                titlePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                title: const Text(
                  "Library Penyakit",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ),
          // Search Bar Sliver
          

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [_buildHeader(), const SizedBox(height: 24)],
              ),
            ),
          ),

          // Daftar Penyakit
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final disease = _filteredDiseases[index];
              return _buildModernCard(context, disease);
            }, childCount: _filteredDiseases.length),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.green.shade50],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.green.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade400],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  "Lengkap Penyakit Tanaman",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163321),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Temukan informasi lengkap tentang berbagai penyakit tanaman beserta cara identifikasi dan pengendaliannya",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade50, Colors.orange.shade100],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange.shade700,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  "${_filteredDiseases.length} penyakit tercatat",
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, DiseaseInfo disease) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiseaseDetailPage(disease: disease),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Animated Icon Container
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          disease.color.withOpacity(0.2),
                          disease.color.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: disease.color.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(disease.icon, color: disease.color, size: 30),
                  ),
                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          disease.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: disease.color,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          disease.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                disease.color.withOpacity(0.1),
                                disease.color.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                color: disease.color,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Pelajari Detail",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: disease.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: disease.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: disease.color,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
