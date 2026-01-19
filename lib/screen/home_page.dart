import 'package:flutter/material.dart';
import 'package:testing_aplikasi/screen/authentication/user_profile_screen.dart';
import 'package:testing_aplikasi/screen/history_page.dart';
import 'prediction_page.dart';
import 'pustaka_penyakit_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const PustakaPenyakitPage(),
    HistoryPage(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 0,
          items: _buildBottomNavItems(),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavItems() {
    return [
      _buildBottomNavItem(Icons.home_rounded, Icons.home_outlined, 'Home', 0),
      _buildBottomNavItem(
        Icons.menu_book_rounded,
        Icons.menu_book_outlined,
        'Pustaka',
        1,
      ),
      _buildBottomNavItem(
        Icons.history_rounded,
        Icons.history_outlined,
        'History',
        2,
      ),
      _buildBottomNavItem(
        Icons.person_rounded,
        Icons.person_outlined,
        'Profile',
        3,
      ),
    ];
  }

  BottomNavigationBarItem _buildBottomNavItem(
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == index ? Colors.green[50] : Colors.transparent,
        ),
        child: Icon(
          _currentIndex == index ? activeIcon : inactiveIcon,
          size: 24,
        ),
      ),
      label: label,
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PredictionPage()),
          );
        },
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Stack(
          children: [
            Icon(Icons.camera_alt_rounded, size: 30),
            Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 6,
                child: Icon(Icons.eco_rounded, size: 8, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String namaLengkap = "PlantLover";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final data = await Supabase.instance.client
            .from('user_profiles')
            .select('nama_lengkap')
            .eq('user_id', user.id)
            .maybeSingle();

        if (mounted) {
          setState(() {
            namaLengkap = data?['nama_lengkap'] ?? "PlantLover";
            loading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => loading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: loading ? _buildLoadingIndicator() : _buildContent(),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildHeaderSliver(),
        _buildStatsSection(),
        _buildPredictionStatsSection(),
        _buildTipsSection(), // Diubah dari _buildTipsAndWeatherSection()
      ],
    );
  }

  SliverAppBar _buildHeaderSliver() {
    return SliverAppBar(
      expandedHeight: 280,
      collapsedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(background: _buildHeader()),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green[800]!,
            Colors.green[600]!,
            Colors.lightGreen[400]!,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [_buildBackgroundPattern(), _buildHeaderContent()],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Stack(
      children: [
        Positioned(
          right: -50,
          top: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: -30,
          bottom: -30,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserGreeting(),
          const SizedBox(height: 25),
          _buildBrandCard(),
        ],
      ),
    );
  }

  Widget _buildUserGreeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.eco_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Hai, Selamat Datang!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                namaLengkap,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildNotificationIcon(),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: const Icon(
        Icons.notifications_outlined,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildBrandCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TomatoCare",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Deteksi hama tomat dengan AI",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              icon: Icons.analytics_rounded,
              title: "Statistik Sistem",
              subtitle: "Informasi performa dan keandalan aplikasi",
            ),
            const SizedBox(height: 10),
            _buildStatsGrid(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPredictionStatsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              icon: Icons.bar_chart_rounded,
              title: "Statistik Prediksi",
              subtitle: "Data hasil prediksi tanaman tomat",
            ),
            const SizedBox(height: 20),
            _buildSinglePredictionCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green[700], size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          value: "95%",
          label: "Akurasi Sistem",
          icon: Icons.verified_rounded,
          color: Colors.green,
        ),
        _buildStatCard(
          value: "5 Detik",
          label: "Waktu Proses",
          icon: Icons.speed_rounded,
          color: Colors.blue,
        ),
      ],
    );
  }

  // // fungsi menghitung untuk statistik prediksi
Future<Map<String, int>> getPredictionStats() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return {
      'total': 0,
      'sehat': 0,
      'hama': 0,
    };
  }

  final response = await Supabase.instance.client
      .from('history')
      .select('label')
      .eq('user_id', user.id);

  final int total = response.length;

  final int sehat = response.where((e) {
    final label = e['label']?.toString().toLowerCase().trim();
    return label == 'healthy';
  }).length;

  final int hama = total - sehat;

  return {
    'total': total,
    'sehat': sehat,
    'hama': hama,
  };
}

// Kartu tunggal untuk statistik prediksi
Widget _buildSinglePredictionCard() {
  return FutureBuilder<Map<String, int>>(
    future: getPredictionStats(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (!snapshot.hasData) {
        return const SizedBox();
      }

      final data = snapshot.data!;
      final int total = data['total']!;
      final int sehat = data['sehat']!;
      final int hama = data['hama']!;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Total
            _buildPredictionRow(
              icon: Icons.photo_library_rounded,
              iconColor: Colors.purple,
              title: "Total Prediksi",
              value: total.toString(),
              valueColor: Colors.purple,
            ),
            const SizedBox(height: 15),

            // Sehat
            _buildPredictionRow(
              icon: Icons.health_and_safety_rounded,
              iconColor: Colors.green,
              title: "Prediksi Sehat",
              value: sehat.toString(),
              valueColor: Colors.green,
            ),
            const SizedBox(height: 15),

            // Hama
            _buildPredictionRow(
              icon: Icons.bug_report_rounded,
              iconColor: Colors.orange,
              title: "Prediksi Hama",
              value: hama.toString(),
              valueColor: Colors.orange,
            ),
          ],
        ),
      );
    },
  );
}


  // Widget untuk setiap baris statistik prediksi
  Widget _buildPredictionRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // DIUBAH: Hanya menampilkan Tips Card saja
  SliverToBoxAdapter _buildTipsSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _buildTipsCard(),
          const SizedBox(height: 30), // Tambah spacing di bagian bawah
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 10, 25, 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.lightGreen[100]!, Colors.green[100]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.green,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tips Hari Ini",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Pastikan sirkulasi udara baik dan hindari penyiraman berlebihan pada daun tomat. Periksa tanaman secara rutin untuk mendeteksi gejala penyakit sejak dini.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[400]!, Colors.green[600]!],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(_getIcon(title), size: 60, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Text(
              "Halaman $title",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _getDescription(title),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String title) {
    switch (title) {
      case "History":
        return Icons.history_rounded;
      case "Profile":
        return Icons.person_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  String _getDescription(String title) {
    switch (title) {
      case "History":
        return "Lihat riwayat scan dan hasil deteksi penyakit tanaman tomat Anda sebelumnya";
      case "Profile":
        return "Kelola profil dan pengaturan akun TomatoCare Anda";
      default:
        return "Jelajahi pustaka informasi tentang berbagai penyakit tanaman tomat";
    }
  }
}