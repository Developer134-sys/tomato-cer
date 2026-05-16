import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_card.dart';
import '../widgets/disease_card.dart';
import '../widgets/team_member_card.dart';
import '../widgets/bottom_nav_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white.withOpacity(0.6),
            foregroundColor: const Color(0xFF006E2D),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'TomatoCare',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF006E2D),
              ),
            ),
           
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Hero Section
                const HeroSection(),
                const SizedBox(height: 40),

                // Tentang Aplikasi
                const AboutAppSection(),
                const SizedBox(height: 40),

                // Fitur Utama
                const FeaturesSection(),
                const SizedBox(height: 40),

                // Penyakit Yang Didukung
                DiseasesSection(),
                const SizedBox(height: 40),

                // Cara Kerja
                const HowItWorksSection(),
                const SizedBox(height: 40),

                // Teknologi
                const TechnologySection(),
                const SizedBox(height: 40),

                // Tim Pengembang
                const TeamSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Footer
          SliverToBoxAdapter(child: Footer()),
        ],
      ),
     
    );
  }
}

// Hero Section
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1DB954).withOpacity(0.2),
            const Color(0xFFADEDD3).withOpacity(0.2),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DB954).withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: Color(0xFF006E2D),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'TomatoCare',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF006E2D),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Deteksi Cerdas Penyakit Tanaman Tomat',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2B6954),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Solusi berbasis AI untuk membantu mendeteksi penyakit tanaman tomat secara cepat dan akurat dengan teknologi Computer Vision terkini.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: const Color(0xFF3D4A3D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// About App Section - SUDAH DIPERBAIKI (Gambar di atas, card di bawah)
class AboutAppSection extends StatelessWidget {
  const AboutAppSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Untuk layar lebar: gambar di kiri, card di kanan
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildPhoneImage()), // Gambar duluan
                const SizedBox(width: 48),
                Expanded(child: _buildAboutContent()), // Card setelah gambar
              ],
            );
          }
          // Untuk layar kecil: gambar di atas, card di bawah
          return Column(
            children: [
              _buildPhoneImage(), // Gambar di atas
              const SizedBox(height: 32),
              _buildAboutContent(), // Card di bawah
            ],
          );
        },
      ),
    );
  }

  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tentang Aplikasi',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF006E2D),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFBCCBB9).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF006E2D).withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'TomatoCare merupakan aplikasi berbasis Artificial Intelligence yang dirancang untuk membantu pengguna mendeteksi penyakit pada tanaman tomat melalui analisis gambar daun.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: const Color(0xFF3D4A3D),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Aplikasi ini memberikan hasil prediksi penyakit secara cepat serta menyediakan informasi penyakit dan rekomendasi penanganan tanaman yang tepat guna bagi petani modern.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: const Color(0xFF3D4A3D),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: const Color(0xFF006E2D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(48),
            ),
          ),
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/phone_scan_preview.png',
                width: 280,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Features Section
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.photo_camera,
        'title': 'Scan Daun',
        'desc': 'Mengambil gambar daun tomat secara langsung melalui kamera smartphone Anda. Mendukung upload dari galeri juga.',
        'color': const Color(0xFF006E2D),
        'bgColor': const Color(0xFF006E2D).withOpacity(0.1),
      },
      {
        'icon': Icons.psychology,
        'title': 'Prediksi AI',
        'desc': 'Menganalisis penyakit menggunakan teknologi CNN yang telah dilatih dengan ribuan dataset gambar daun tomat.',
        'color': const Color(0xFF2B6954),
        'bgColor': const Color(0xFF2B6954).withOpacity(0.1),
      },
      {
        'icon': Icons.medical_information,
        'title': 'Informasi Penyakit',
        'desc': 'Menampilkan detail penyakit, penyebab, gejala visual pada tanaman, serta tingkat keparahan penyakit.',
        'color': const Color(0xFFB12C16),
        'bgColor': const Color(0xFFB12C16).withOpacity(0.1),
      },
      {
        'icon': Icons.eco,
        'title': 'Tips Perawatan',
        'desc': 'Memberikan rekomendasi penanganan praktis, solusi organik, dan pencegahan untuk hasil panen terbaik.',
        'color': const Color(0xFF004118),
        'bgColor': const Color(0xFF004118).withOpacity(0.1),
      },
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFECEFF0),
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 32 : 40,
        horizontal: 24,
      ),
      child: Column(
        children: [
          // Title
          Text(
            'Fitur Utama',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isSmallScreen ? 28 : 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006E2D),
            ),
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'Efisiensi maksimal untuk kesehatan tanaman Tomat Anda',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isSmallScreen ? 12 : 14,
              color: const Color(0xFF3D4A3D),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Grid Features
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isSmallScreen ? 2.8 : 3.2,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return _buildFeatureCard(feature, isSmallScreen);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBCCBB9).withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              color: feature['bgColor'] as Color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: feature['color'] as Color,
              size: isSmallScreen ? 22 : 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  feature['title'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF191C1E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  feature['desc'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isSmallScreen ? 12 : 13,
                    height: 1.4,
                    color: const Color(0xFF3D4A3D),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

// Diseases Section
class DiseasesSection extends StatelessWidget {
  DiseasesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Penyakit Yang Didukung',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006E2D),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: diseases.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) =>
                DiseaseCard(disease: diseases[index]),
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> diseases = [
    {
      'name': 'Bacterial Spot',
      'type': 'Umum',
      'typeColor': const Color(0xFFFFDAD6),
      'textColor': const Color(0xFF93000A),
      'image': 'assets/images_about/bacterial_spot.jpg',
    },
    {
      'name': 'Early Blight',
      'type': 'Jamur',
      'typeColor': Color(0xFF1DB954).withOpacity(0.2),
      'textColor': const Color(0xFF004118),
      'image': 'assets/images_about/early_blight.jpg',
    },
    {
      'name': 'Late Blight',
      'type': 'Kritis',
      'typeColor': const Color(0xFFFF785F).withOpacity(0.2),
      'textColor': const Color(0xFF730C00),
      'image': 'assets/images_about/late_blight.jpg',
    },
    {
      'name': 'Leaf Mold',
      'type': 'Sedang',
      'typeColor': const Color(0xFFB0F0D6).withOpacity(0.5),
      'textColor': const Color(0xFF002117),
      'image': 'assets/images_about/leaf_mold.jpg',
    },
    {
      'name': 'Septoria Leaf Spot',
      'type': 'Umum',
      'typeColor': const Color(0xFFE8F5E9),
      'textColor': const Color(0xFF1B5E20),
      'image': 'assets/images_about/septoria_leaf_spot.jpg',
    },
    {
      'name': 'Spider Mites',
      'type': 'Hama',
      'typeColor': const Color(0xFFFFF3E0),
      'textColor': const Color(0xFFE65100),
      'image': 'assets/images_about/spider_mites.jpg',
    },
    {
      'name': 'Target Spot',
      'type': 'Jamur',
      'typeColor': const Color(0xFFD0F0C0),
      'textColor': const Color(0xFF1B4332),
      'image': 'assets/images_about/target_spot.jpg',
    },
    {
      'name': 'Tomato Mosaic Virus',
      'type': 'Virus',
      'typeColor': const Color(0xFFFFE0B2),
      'textColor': const Color(0xFFBF360C),
      'image': 'assets/images_about/tomato_mosaic_virus.jpg',
    },
    {
      'name': 'Tomato Yellow Leaf Curl Virus',
      'type': 'Virus',
      'typeColor': const Color(0xFFFFF9C4),
      'textColor': const Color(0xFFF57F17),
      'image': 'assets/images_about/tomato_yellow_leaf_curl_virus.jpg',
    },
    {
      'name': 'Powdery Mildew',
      'type': 'Jamur',
      'typeColor': const Color(0xFFE1F5FE),
      'textColor': const Color(0xFF01579B),
      'image': 'assets/images_about/powdery_mildew.jpg',
    },
    {
      'name': 'Healthy Leaf',
      'type': 'Sehat',
      'typeColor': const Color(0xFFC8E6C9),
      'textColor': const Color(0xFF1B5E20),
      'image': 'assets/images_about/healthy.jpg',
    },
  ];
}

// How It Works Section
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'icon': Icons.add_a_photo, 'title': 'Ambil foto daun tomat'},
      {'icon': Icons.cloud_upload, 'title': 'Upload gambar'},
      {'icon': Icons.smart_toy, 'title': 'AI menganalisis penyakit'},
      {'icon': Icons.fact_check, 'title': 'Hasil prediksi ditampilkan'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF006E2D).withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
      ),
      child: Column(
        children: [
          Text(
            'Cara Kerja',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006E2D),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: List.generate(steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF006E2D),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          steps[index]['icon'] as IconData,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            steps[index]['title'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF006E2D),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// Technology Section
class TechnologySection extends StatelessWidget {
  const TechnologySection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    final technologies = [
      {'name': 'FLUTTER', 'icon': Icons.mobile_friendly},
      {'name': 'TENSORFLOW LITE', 'icon': Icons.memory},
      {'name': 'CNN', 'icon': Icons.grid_on},
      {'name': 'ARTIFICIAL INTELLIGENCE', 'icon': Icons.psychology},
      {'name': 'MOBILE VISION', 'icon': Icons.camera_alt},
      {'name': 'SUPABASE', 'icon': Icons.cloud_queue},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
      child: Column(
        children: [
          Text(
            'Teknologi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isSmallScreen ? 28 : 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006E2D),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: technologies.map((tech) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 20,
                  vertical: isSmallScreen ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFADEDD3),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color(0xFF002117).withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tech['icon'] as IconData,
                      size: isSmallScreen ? 16 : 18,
                      color: const Color(0xFF006E2D),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tech['name'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isSmallScreen ? 10 : 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                        color: const Color(0xFF002117),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Team Section
class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> teamMembers = [
      {
        'name': 'Jesulin Noni Novelis Wattilete',
        'role': 'Lead AI Engineer',
        'image': 'assets/image_tim/jesulin.png',
        'color': const Color(0xFF006E2D),
        'email': 'jesulinnoni@gmail.com',
        'phone': '+62 822 9369 2317',
        'location': 'Ambon, Indonesia',
        'education': 'S1 Teknik informatika',
        'skills': ['Python', 'TensorFlow', 'Computer Vision', 'Deep Learning'],
        'about':
            'Jesulin memiliki pengalaman di bidang AI dan Machine Learning. Fokus mengembangkan model deteksi penyakit tanaman tomat menggunakan CNN.',
      },
      {
        'name': 'Dito Wahyu Pratama',
        'role': 'UI/UX Designer',
        'image': 'assets/image_tim/dito.png',
        'color': const Color(0xFF2B6954),
        'email': 'ditooopratamaa@gmail.com',
        'phone': '+62 852 3306 2907',
        'location': 'Ambon, Indonesia',
        'education': 'S1 Teknik informatika',
        'skills': ['Figma', 'UI Design', 'UX Research'],
        'about':
            'Dito ahli dalam mendesain antarmuka yang intuitif dan user-friendly. Bertanggung jawab menciptakan pengalaman pengguna yang nyaman di TomatoCare.',
      },
      {
        'name': 'Reza Aditya Thohir',
        'role': 'Mobile Developer',
        'image': 'assets/image_tim/reza.png',
        'color': const Color(0xFF2B6954),
        'email': 'rezaadityathohir30@gmail.com',
        'phone': '+62 822 3493 0442',
        'location': 'Ambon, Indonesia',
        'education': 'S1 Teknik informatika',
        'skills': [
          'Flutter',
          'Dart',
          'Firebase',
          'Supabase',
          'Laravel',
          'PHP',
          'JavaScript',
          'REST API',
          'MySQL',
          'SQLite',
          'TensorFlow Lite',
          'Artificial Intelligence',
          'Machine Learning',
          'CNN',
          'Deep Learning',
          'UI/UX Design',
          'Figma',
          'Android Development',
          'Web Development',
          'Full Stack Development',
          'GitHub',
          'Python',
          'Cloud Database',
          'Mobile App Development',
          'Backend Development',
          'Frontend Development',
          'Problem Solving',
        ],
        'about':
            'Reza berpengalaman dalam aplikasi mobile multiplatform. Mengimplementasikan desain menjadi aplikasi TomatoCare.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Text(
            'Tim Pengembang',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006E2D),
            ),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: teamMembers.length,
            itemBuilder: (context, index) {
              return TeamMemberCard(member: teamMembers[index]);
            },
          ),
        ],
      ),
    );
  }
}

// Footer
class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFBCCBB9).withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          Text(
            'TomatoCare',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006E2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 8.1.0',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: const Color(0xFF3D4A3D),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '© 2026 TomatoCare Team. Hak Cipta Dilindungi Undang-Undang.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF6D7B6C),
            ),
          ),
        ],
      ),
    );
  }
}