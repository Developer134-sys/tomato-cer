import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: "Scan Daun Tomat",
      description: "Ambil foto daun untuk mendeteksi penyakit dengan teknologi AI canggih.",
      imageAsset: "assets/scendaun.png",
      color: const Color(0xFF0D631B),
      feature: "Deteksi Otomatis",
      isCircular: false,
    ),
    OnboardingData(
      title: "Identifikasi Penyakit",
      description: "Ketahui jenis penyakit daun tomat dengan cepat dan akurat.",
      imageAsset: "assets/iden_penyakit.png",
      color: const Color(0xFFF9A825),
      feature: "Analisis Real-time",
      isCircular: false,
    ),
    OnboardingData(
      title: "Informasi & Solusi",
      description: "Pelajari penyebab dan cara penanganan penyakit secara lengkap.",
      icon: Icons.library_books_rounded,
      illustration: "📖",
      color: const Color(0xFF2196F3),
      feature: "Panduan Lengkap",
      isCircular: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFFBF9F9),
              const Color(0xFFF5F7F5),
            ],
          ),
        ),
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.only(top: 60, right: 24),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    _navigateToLogin();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFBFCABA), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Lewati",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF707A6C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: Color(0xFF707A6C),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingSlide(_onboardingData[index], index);
                },
              ),
            ),
            
            // Indicator dan Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDotIndicator(index),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildNavigationButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingSlide(OnboardingData data, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animasi ilustrasi dengan scale
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, double scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: data.isCircular 
                ? _buildCircularIllustration(data) // BUNDAR (Slide 3)
                : _buildSquareIllustration(data, index), // KOTAK (Slide 1 & 2)
          ),
          
          const SizedBox(height: 48),
          
          // Title dengan efek fade-in
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, double opacity, child) {
              return Opacity(
                opacity: opacity,
                child: child,
              );
            },
            child: Column(
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1C1C),
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  data.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF707A6C),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SLIDE 1 & 2: BENTUK KOTAK dengan GAMBAR (TANPA GARIS)
  Widget _buildSquareIllustration(OnboardingData data, int index) {
    return Container(
      height: 280,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Container gambar KOTAK (tanpa border, tanpa garis)
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: data.color.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                data.imageAsset!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          index == 0 ? Icons.camera_alt_rounded : Icons.science_rounded,
                          size: 60,
                          color: data.color,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          index == 0 ? "Gambar Scan" : "Gambar Prediksi",
                          style: TextStyle(
                            fontSize: 12,
                            color: data.color,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Badge feature di pojok kanan bawah
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: data.color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: data.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                data.feature,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SLIDE 3: BENTUK BUNDAR/LINGKARAN (tanpa garis berlebih)
  Widget _buildCircularIllustration(OnboardingData data) {
    return Container(
      height: 280,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran dalam
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: data.color.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.illustration!,
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.feature,
                      style: TextStyle(
                        fontSize: 12,
                        color: data.color,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: _currentPage == index ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: _currentPage == index
            ? const Color(0xFF0D631B)
            : const Color(0xFFBFCABA),
      ),
    );
  }

  Widget _buildNavigationButton() {
    final isLastPage = _currentPage == _onboardingData.length - 1;
    
    return GestureDetector(
      onTap: () {
        if (isLastPage) {
          _navigateToLogin();
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isLastPage
                ? [const Color(0xFF0D631B), const Color(0xFF2E7D32)]
                : [const Color(0xFFBFCABA), const Color(0xFF9AA89A)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: isLastPage
                  ? const Color(0xFF0D631B).withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? "Memulai" : "Selanjutnya",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (!isLastPage) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    
    if (!mounted) return;
    
    Navigator.pushReplacementNamed(context, '/login');
  }
}

class OnboardingData {
  final String title;
  final String description;
  
  // Untuk Slide 1 & 2 (Gambar Kotak)
  final String? imageAsset;
  
  // Untuk Slide 3 (Emoji/Icon)
  final IconData? icon;
  final String? illustration;
  
  final Color color;
  final String feature;
  final bool isCircular;

  OnboardingData({
    required this.title,
    required this.description,
    this.imageAsset,
    this.icon,
    this.illustration,
    required this.color,
    required this.feature,
    required this.isCircular,
  });
}