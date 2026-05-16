import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testing_aplikasi/screen/about_screen.dart';
import 'package:testing_aplikasi/screen/help_page.dart';
import 'package:testing_aplikasi/widgets/bottom_nav_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<Map<String, dynamic>?> futureProfile;
  late Future<Map<String, int>> futureStats;
  int _currentIndex = 4;
  bool _isUserInfoExpanded = false; // Untuk mengontrol expand/collapse

  @override
  void initState() {
    super.initState();
    futureProfile = getUserProfile();
    futureStats = getUserStats();
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    try {
      final profile = await Supabase.instance.client
          .from('user_profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (profile == null) {
        print('Profil tidak ditemukan, membuat profil baru...');

        final newProfile = await Supabase.instance.client
            .from('user_profiles')
            .insert({
              'user_id': user.id,
              'nama_lengkap':
                  user.userMetadata?['nama_lengkap'] ?? 'Petani Tomat',
              'alamat': '',
              'bio': '',
              'foto_profil': '',
            })
            .select()
            .single();

        return newProfile as Map<String, dynamic>;
      }

      return profile as Map<String, dynamic>;
    } catch (e) {
      print('Error getUserProfile: $e');
      return null;
    }
  }

  Future<Map<String, int>> getUserStats() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {'totalScan': 0, 'sehat': 0, 'terinfeksi': 0};

    try {
      final historyData = await Supabase.instance.client
          .from('history')
          .select('label')
          .eq('user_id', user.id);

      int totalScan = historyData.length;
      int sehat = 0;
      int terinfeksi = 0;

      for (var item in historyData) {
        String label = item['label']?.toString().toLowerCase() ?? '';

        if (label == 'sehat' || label == 'healthy') {
          sehat++;
        } else if (label.isNotEmpty && label != 'null') {
          terinfeksi++;
        }
      }

      print(
        'Stats - Total: $totalScan, Sehat: $sehat, Terinfeksi: $terinfeksi',
      );

      return {'totalScan': totalScan, 'sehat': sehat, 'terinfeksi': terinfeksi};
    } catch (e) {
      print('Error getUserStats: $e');
      return {'totalScan': 0, 'sehat': 0, 'terinfeksi': 0};
    }
  }

  void refreshProfile() {
    setState(() {
      futureProfile = getUserProfile();
      futureStats = getUserStats();
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
        Navigator.pushReplacementNamed(context, '/scan');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/HistoryPage');
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profil",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B1C1C),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Color(0xFF0D631B)),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: futureProfile,
        builder: (context, profileSnapshot) {
          if (profileSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D631B)),
              ),
            );
          }

          if (profileSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Terjadi kesalahan",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => refreshProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D631B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          if (!profileSnapshot.hasData || profileSnapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Profil tidak ditemukan",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => refreshProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D631B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Buat Profil"),
                  ),
                ],
              ),
            );
          }

          final profile = profileSnapshot.data!;
          final userEmail =
              Supabase.instance.client.auth.currentUser?.email ?? '';

          return RefreshIndicator(
            onRefresh: () async {
              refreshProfile();
              return Future.value();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildProfileHeader(profile, userEmail),
                  const SizedBox(height: 24),

                  FutureBuilder<Map<String, int>>(
                    future: futureStats,
                    builder: (context, statsSnapshot) {
                      if (statsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFBFCABA),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF0D631B),
                              ),
                            ),
                          ),
                        );
                      }

                      int totalScan = statsSnapshot.data?['totalScan'] ?? 0;
                      int sehat = statsSnapshot.data?['sehat'] ?? 0;
                      int terinfeksi = statsSnapshot.data?['terinfeksi'] ?? 0;

                      return _buildStatsCard(totalScan, sehat, terinfeksi);
                    },
                  ),
                  const SizedBox(height: 24),

                  _buildAccountSettings(profile, userEmail),
                  const SizedBox(height: 16),

                  _buildOtherSettings(),
                  const SizedBox(height: 24),

                  _buildAIFooter(),
                  const SizedBox(height: 20),

                  _buildLogoutButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> profile, String userEmail) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF88D982), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: Colors.white,
                backgroundImage:
                    profile['foto_profil'] != null &&
                        profile['foto_profil'] != ''
                    ? NetworkImage(profile['foto_profil'])
                    : null,
                child:
                    profile['foto_profil'] == null ||
                        profile['foto_profil'] == ''
                    ? Icon(
                        Icons.person_rounded,
                        size: 50,
                        color: const Color(0xFF0D631B),
                      )
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/edit_profile',
                  );
                  if (result == true) refreshProfile();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          profile['nama_lengkap'] ?? '',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B1C1C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userEmail,
          style: const TextStyle(fontSize: 14, color: Color(0xFF40493D)),
        ),
      ],
    );
  }

  // STATS CARD BARU DENGAN DESAIN MODERN
  Widget _buildStatsCard(int totalScan, int sehat, int terinfeksi) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFCABA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Aksen garis melengkung hijau di kiri
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF0D631B),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Total Scan
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Total Scan",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF707A6C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totalScan.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D631B),
                        ),
                      ),
                      const SizedBox(height: 6),

                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D631B),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),

                // Garis pemisah vertikal
                Container(width: 1, height: 50, color: const Color(0xFFBFCABA)),

                // Sehat
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Sehat",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF707A6C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sehat.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF9A825),
                        ),
                      ),
                      const SizedBox(height: 6),

                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9A825),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),

                // Garis pemisah vertikal
                Container(width: 1, height: 50, color: const Color(0xFFBFCABA)),

                // Terinfeksi
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Terinfeksi",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF707A6C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        terinfeksi.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE53935),
                        ),
                      ),

                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(Map<String, dynamic> profile, String userEmail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "PENGATURAN AKUN",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF707A6C),
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Menu Info Pengguna dengan Expandable
              _buildExpandableMenuItem(
                icon: Icons.account_circle_rounded,
                title: "Info Pengguna",
                iconColor: const Color(0xFF0D631B),
                iconBgColor: const Color(0xFF0D631B).withOpacity(0.1),
                isExpanded: _isUserInfoExpanded,
                onTap: () {
                  setState(() {
                    _isUserInfoExpanded = !_isUserInfoExpanded;
                  });
                },
                expandedContent: _buildUserInfoContent(profile, userEmail),
              ),

              // Menu lainnya (tidak dalam kondisi expand)
              if (!_isUserInfoExpanded) ...[
                const Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Color(0xFFE3E2E2),
                ),
                _buildMenuItem(
                  icon: Icons.mode_edit_rounded,
                  title: "Edit Profil",
                  iconColor: const Color(0xFF0D631B),
                  iconBgColor: const Color(0xFF0D631B).withOpacity(0.1),
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/edit_profile',
                    );
                    if (result == true) refreshProfile();
                  },
                ),
                const Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Color(0xFFE3E2E2),
                ),
                _buildMenuItem(
                  icon: Icons.history_rounded,
                  title: "Riwayat Deteksi",
                  iconColor: const Color(0xFFF9A825),
                  iconBgColor: const Color(0xFFF9A825).withOpacity(0.1),
                  onTap: () => Navigator.pushNamed(context, '/HistoryPage'),
                ),
              ] else ...[
                // Jika expanded, tetap tampilkan divider setelah konten
                const Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Color(0xFFE3E2E2),
                ),
                _buildMenuItem(
                  icon: Icons.person_outline_rounded,
                  title: "Edit Profil",
                  iconColor: const Color(0xFF0D631B),
                  iconBgColor: const Color(0xFF0D631B).withOpacity(0.1),
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/edit_profile',
                    );
                    if (result == true) refreshProfile();
                  },
                ),
                const Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Color(0xFFE3E2E2),
                ),
                _buildMenuItem(
                  icon: Icons.history_rounded,
                  title: "Riwayat Deteksi",
                  iconColor: const Color(0xFFF9A825),
                  iconBgColor: const Color(0xFFF9A825).withOpacity(0.1),
                  onTap: () => Navigator.pushNamed(context, '/HistoryPage'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk menu yang bisa expand
  Widget _buildExpandableMenuItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color iconBgColor,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget expandedContent,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1B1C1C),
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: const Color(0xFF707A6C),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) expandedContent,
      ],
    );
  }

  // Konten info pengguna yang ditampilkan saat expand
  Widget _buildUserInfoContent(Map<String, dynamic> profile, String userEmail) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE3E2E2)),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.person_rounded,
            label: "Nama Lengkap",
            value: profile['nama_lengkap'] ?? '-',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.email_rounded,
            label: "Email",
            value: userEmail,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.location_on_rounded,
            label: "Alamat",
            value: profile['alamat'] != null && profile['alamat'] != ''
                ? profile['alamat']
                : 'Belum diisi',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.info_outline_rounded,
            label: "tentang petani ",
            value: profile['bio'] != null && profile['bio'] != ''
                ? profile['bio']
                : 'Belum diisi',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D631B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0D631B), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF707A6C),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1B1C1C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtherSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "LAINNYA",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF707A6C),
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                title: "Tentang Aplikasi",
                iconColor: const Color.fromARGB(255, 7, 81, 147),
                iconBgColor: const Color.fromARGB(
                  255,
                  146,
                  192,
                  239,
                ).withOpacity(0.1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  );
                },
              ),
              const Divider(
                height: 0,
                thickness: 0.5,
                color: Color(0xFFE3E2E2),
              ),
              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: "Bantuan",
                iconColor: const Color.fromARGB(255, 39, 39, 39),
                iconBgColor: const Color.fromARGB(
                  255,
                  156,
                  155,
                  156,
                ).withOpacity(0.1),
                 onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color iconBgColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Color(0xFF1B1C1C)),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF707A6C),
                  size: 22,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIFooter() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDFA0).withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF8BD2A).withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.smart_toy_rounded, size: 16, color: Color(0xFF795900)),
              SizedBox(width: 6),
              Text(
                "TomatoCare AI v2.4.0",
                style: TextStyle(fontSize: 11, color: Color(0xFF795900)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Terakhir disinkronisasi: 12 menit yang lalu",
          style: TextStyle(fontSize: 11, color: Color(0xFF707A6C)),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Konfirmasi Logout"),
            content: const Text("Apakah Anda yakin ingin keluar?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Batal", style: TextStyle(color: Colors.grey[600])),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Logout"),
              ),
            ],
          ),
        );

        if (confirm == true) {
          try {
            await Supabase.instance.client.auth.signOut();

            if (!mounted) return;

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('Berhasil logout dari akun Anda.'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            await Future.delayed(const Duration(milliseconds: 500));

            if (!mounted) return;

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          } catch (e) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Gagal logout: ${e.toString().replaceFirst('Exception: ', '')}',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDAD6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFBA1A1A), size: 20),
            SizedBox(width: 12),
            Text(
              "Keluar",
              style: TextStyle(
                color: Color(0xFFBA1A1A),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
