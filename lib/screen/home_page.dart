// lib/screen/home_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Variabel untuk menyimpan data profil
  Map<String, dynamic>? _userProfile;
  String _userEmail = '';
  bool _isLoadingProfile = true;

  // Variabel untuk menyimpan data history
  List<Map<String, dynamic>> _recentHistory = [];
  int _totalScans = 0;
  int _issuesFound = 0;
  bool _isLoadingHistory = true;

  // Responsive variables
  late double _screenWidth;
  late double _screenHeight;
  late double _paddingHorizontal;
  late double _cardWidth;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadHistoryData();
  }

  // Fungsi untuk mengambil data profil dari Supabase
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        _userEmail = user.email ?? '';

        final response = await Supabase.instance.client
            .from('user_profiles')
            .select()
            .eq('user_id', user.id)
            .maybeSingle();

        if (response != null) {
          setState(() {
            _userProfile = response as Map<String, dynamic>;
          });
        } else {
          await _createDefaultProfile(user.id);
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  // Fungsi untuk membuat profil default
  Future<void> _createDefaultProfile(String userId) async {
    try {
      final newProfile = await Supabase.instance.client
          .from('user_profiles')
          .insert({
            'user_id': userId,
            'nama_lengkap': 'Petani Tomat',
            'alamat': '',
            'bio': '',
            'foto_profil': '',
          })
          .select()
          .single();

      setState(() {
        _userProfile = newProfile as Map<String, dynamic>;
      });
    } catch (e) {
      print('Error creating default profile: $e');
      setState(() {
        _userProfile = {
          'nama_lengkap': 'Petani Tomat',
          'alamat': '',
          'bio': '',
          'foto_profil': '',
        };
      });
    }
  }

  // Fungsi untuk mengambil data history dari Supabase
  Future<void> _loadHistoryData() async {
    setState(() {
      _isLoadingHistory = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        final response = await Supabase.instance.client
            .from('history')
            .select('*')
            .eq('user_id', user.id)
            .order('created_at', ascending: false);

        if (response != null && response.isNotEmpty) {
          final List<dynamic> historyData = response;

          _totalScans = historyData.length;

          // 🔥 HITUNG ISSUES: label tetap dipakai untuk logika internal
          _issuesFound = historyData.where((item) {
            final label = item['label']?.toString().toLowerCase() ?? '';
            return label != 'healthy' && label != 'sehat' && label != 'good';
          }).length;

          // 🔥 TAMPILAN: HANYA gunakan disease_name
          _recentHistory = historyData.take(4).map((item) {
            final imageUrl = item['image_url']?.toString() ?? '';
            print('Image URL: $imageUrl');

            // 🔥 HANYA gunakan disease_name untuk tampilan
            final displayName =
                item['disease_name']?.toString() ?? 'Tanaman Tidak Dikenal';

            // 🔥 Status tetap menggunakan label untuk akurasi logika
            final labelForStatus = item['label']?.toString() ?? '';

            return {
              'id': item['id'],
              'plantName': displayName, // 🔥 HANYA disease_name
              'status': _getStatusLabel(labelForStatus), // Logika internal
              'statusColor': _getStatusColor(labelForStatus), // Logika internal
              'time': _formatDate(item['created_at']),
              'imageUrl': imageUrl,
              'accuracy': item['accuracy'],
              'severity': item['severity'],
            };
          }).toList();
        } else {
          _totalScans = 0;
          _issuesFound = 0;
          _recentHistory = [];
        }
      }
    } catch (e) {
      print('Error loading history: $e');
      setState(() {
        _totalScans = 0;
        _issuesFound = 0;
        _recentHistory = [];
      });
    } finally {
      setState(() {
        _isLoadingHistory = false;
      });
    }
  }

  // Helper: Mendapatkan label status (LOGIKA INTERNAL, tidak tampil ke user)
 // Helper: Mendapatkan label status - SESUAI 11 LABEL
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

  // Helper: Mendapatkan warna status - SESUAI 11 LABEL
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


  // Helper: Format tanggal
  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null) return 'Unknown date';

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes}m ago';
        }
        return 'Today ${_formatTime(dateTime)}';
      } else if (difference.inDays == 1) {
        return 'Yesterday ${_formatTime(dateTime)}';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}';
      }
    } catch (e) {
      return dateTimeString;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Fungsi untuk refresh data
  Future<void> _onRefresh() async {
    await _loadUserProfile();
    await _loadHistoryData();
  }

  // Fungsi untuk handle navigasi bottom bar
  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/info').then((_) {
          _loadHistoryData();
        });
        break;
      case 2:
        Navigator.pushNamed(context, '/scan').then((_) {
          _loadHistoryData();
        });
        break;
      case 3:
        Navigator.pushNamed(context, '/HistoryPage').then((_) {
          _loadHistoryData();
        });
        break;
      case 4:
        Navigator.pushNamed(context, '/profil').then((_) {
          _loadUserProfile();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung responsive values
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _paddingHorizontal = _screenWidth < 600 ? 16 : 24;
    _cardWidth = _screenWidth * 0.75;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: _paddingHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: _screenHeight * 0.02),

                      _buildHeroSection(),
                      SizedBox(height: _screenHeight * 0.04),

                      _buildStatsGrid(),
                      SizedBox(height: _screenHeight * 0.04),

                      _buildRecentActivitySection(),
                      SizedBox(height: _screenHeight * 0.08),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  // Top App Bar - Responsive
  Widget _buildTopAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _paddingHorizontal,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profil').then((_) {
                _loadUserProfile();
              });
            },
            child: Row(
              children: [
                Container(
                  width: _screenWidth < 600 ? 50 : 55,
                  height: _screenWidth < 600 ? 50 : 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFADCFB5),
                      width: 2.5,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    backgroundImage:
                        _userProfile != null &&
                            _userProfile!['foto_profil'] != null &&
                            _userProfile!['foto_profil'] != ''
                        ? NetworkImage(_userProfile!['foto_profil'])
                        : null,
                    child:
                        _userProfile == null ||
                            _userProfile!['foto_profil'] == null ||
                            _userProfile!['foto_profil'] == ''
                        ? Icon(
                            Icons.person,
                            color: Colors.white,
                            size: _screenWidth < 600 ? 28 : 32,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: _screenWidth < 600 ? 14 : 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hai👋',
                      style: TextStyle(
                        fontSize: _screenWidth < 600 ? 15 : 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (_isLoadingProfile)
                      Container(
                        width: _screenWidth < 600 ? 100 : 120,
                        height: _screenWidth < 600 ? 16 : 18,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    else
                      SizedBox(
                        width: _screenWidth < 600 ? 150 : 180,
                        child: Text(
                          _userProfile?['nama_lengkap'] ?? 'Petani Tomat',
                          style: TextStyle(
                            fontSize: _screenWidth < 600 ? 18 : 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF191C1B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          
          
        ],
      ),
    );
  }

  // Hero Section
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Color(0xFF163321), Color(0xFF2A4D37)],
        ),
        borderRadius: BorderRadius.circular(_screenWidth < 600 ? 28 : 36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(_screenWidth < 600 ? 28 : 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pantau Kesehatan Tanaman Tomat Anda',
                  style: TextStyle(
                    fontSize: _screenWidth < 600 ? 28 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.3,
                  ),
                  softWrap: true,
                ),
                SizedBox(height: _screenWidth < 600 ? 16 : 20),
                Text(
                   'Arahkan kamera ke daun tomat\n anda untuk mendeteksi \n penyakit secara cepat \n dan akurat.',
                  style: TextStyle(
                    fontSize: _screenWidth < 600 ? 16 : 18,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                  softWrap: true,
                ),
                SizedBox(height: _screenWidth < 600 ? 32 : 40),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/prediction');
                  },
                  icon: Icon(
                    Icons.qr_code_scanner,
                    size: _screenWidth < 600 ? 24 : 28,
                  ),
                  label: Text(
                    'Scan\nSekarang',
                    style: TextStyle(
                      fontSize: _screenWidth < 600 ? 18 : 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC1F100),
                    foregroundColor: const Color(0xFF546B00),
                    padding: EdgeInsets.symmetric(
                      horizontal: _screenWidth < 600 ? 28 : 32,
                      vertical: _screenWidth < 600 ? 16 : 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        _screenWidth < 600 ? 18 : 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: _screenWidth * 0.35,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: _screenWidth < 600 ? 24 : 32),
              child: Opacity(
                opacity: 0.12,
                child: Icon(
                  Icons.grass,
                  size: _screenWidth < 600 ? 140 : 180,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stats Grid
  Widget _buildStatsGrid() {
    final stats = [
      {
        'icon': Icons.local_florist,
        'iconColor': const Color(0xFF506600),
        'label': 'Total Scans',
        'value': _isLoadingHistory ? '...' : '$_totalScans',
      },
      {
        'icon': Icons.warning,
        'iconColor': const Color(0xFFBA1A1A),
        'label': 'Terinfeksi',
        'value': _isLoadingHistory ? '...' : '$_issuesFound',
      },
    ];

    final isSmallScreen = _screenWidth < 600;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSmallScreen ? 2 : 4,
        childAspectRatio: isSmallScreen ? 1.4 : 1.6,
        crossAxisSpacing: isSmallScreen ? 12 : 16,
        mainAxisSpacing: isSmallScreen ? 12 : 16,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];

        return Container(
          padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F2),
            borderRadius: BorderRadius.circular(isSmallScreen ? 18 : 22),
            border: Border.all(color: const Color(0xFFC2C8C1).withOpacity(0.3)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    stat['icon'] as IconData,
                    color: stat['iconColor'] as Color,
                    size: constraints.maxHeight * 0.25,
                  ),
                  Text(
                    stat['label'] as String,
                    style: TextStyle(
                      fontSize: constraints.maxHeight * 0.12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      stat['value'] as String,
                      style: TextStyle(
                        fontSize: constraints.maxHeight * 0.28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF191C1B),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Recent Activity Section
  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Aktivitas Terbaru',
              style: TextStyle(
                fontSize: _screenWidth < 600 ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF191C1B),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/HistoryPage').then((_) {
                  _loadHistoryData();
                });
              },
              child: Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: _screenWidth < 600 ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF304D39),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: _screenWidth < 600 ? 16 : 20),

        if (_isLoadingHistory)
          Center(
            child: Padding(
              padding: EdgeInsets.all(_screenWidth < 600 ? 24 : 32),
              child: CircularProgressIndicator(
                color: const Color(0xFF163321),
                strokeWidth: _screenWidth < 600 ? 3 : 4,
              ),
            ),
          )
        else if (_recentHistory.isEmpty)
          Container(
            padding: EdgeInsets.all(_screenWidth < 600 ? 24 : 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_screenWidth < 600 ? 20 : 24),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: _screenWidth < 600 ? 48 : 56,
                  color: Colors.grey[400],
                ),
                SizedBox(height: _screenWidth < 600 ? 12 : 16),
                Text(
                  'No scan history yet',
                  style: TextStyle(
                    fontSize: _screenWidth < 600 ? 15 : 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: _screenWidth < 600 ? 6 : 10),
                Text(
                  'Start scanning to see your activity',
                  style: TextStyle(
                    fontSize: _screenWidth < 600 ? 13 : 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: _screenWidth < 600 ? 280 : 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recentHistory.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: _screenWidth < 600 ? 12 : 16),
              itemBuilder: (context, index) {
                final activity = _recentHistory[index];
                return SizedBox(
                  width: _cardWidth,
                  child: _buildActivityCard(activity),
                );
              },
            ),
          ),
      ],
    );
  }

  // Activity Card
  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final isSmallScreen = _screenWidth < 600;
    final imageUrl = activity['imageUrl']?.toString() ?? '';
    final hasImage = imageUrl.isNotEmpty;
    final statusColor = activity['statusColor'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isSmallScreen ? 20 : 24),
              topRight: Radius.circular(isSmallScreen ? 20 : 24),
            ),
            child: Container(
              height: isSmallScreen ? 160 : 180,
              width: double.infinity,
              color: statusColor.withOpacity(0.15),
              child: hasImage
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: statusColor,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder(
                              activity,
                              isSmallScreen,
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: isSmallScreen ? 12 : 16,
                          left: isSmallScreen ? 12 : 16,
                          child: _buildStatusBadge(activity, isSmallScreen),
                        ),
                        if (activity['accuracy'] != null)
                          Positioned(
                            top: isSmallScreen ? 12 : 16,
                            right: isSmallScreen ? 12 : 16,
                            child: _buildAccuracyBadge(activity, isSmallScreen),
                          ),
                      ],
                    )
                  : _buildImagePlaceholder(activity, isSmallScreen),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔥 HANYA menampilkan disease_name (plantName)
                Text(
                  activity['plantName'] as String,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 15 : 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF191C1B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 4 : 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: isSmallScreen ? 12 : 14,
                      color: Colors.grey,
                    ),
                    SizedBox(width: isSmallScreen ? 4 : 6),
                    Expanded(
                      child: Text(
                        activity['time'] as String,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (activity['severity'] != null &&
                    activity['severity'].toString().isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: isSmallScreen ? 8 : 10),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8 : 10,
                        vertical: isSmallScreen ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 8 : 10,
                        ),
                      ),
                      child: Text(
                        'Severity: ${activity['severity']}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11 : 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk status badge
  Widget _buildStatusBadge(Map<String, dynamic> activity, bool isSmallScreen) {
    final statusColor = activity['statusColor'] as Color;
    final status = activity['status'] as String;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 14,
        vertical: isSmallScreen ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status == 'Healthy'
                ? Icons.check_circle
                : status == 'Late Blight'
                ? Icons.report
                : Icons.error,
            size: isSmallScreen ? 14 : 16,
            color: statusColor,
          ),
          SizedBox(width: isSmallScreen ? 4 : 6),
          Text(
            status,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk accuracy badge
  Widget _buildAccuracyBadge(
    Map<String, dynamic> activity,
    bool isSmallScreen,
  ) {
    final accuracy = (activity['accuracy'] as num?)?.toDouble();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 14,
        vertical: isSmallScreen ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: isSmallScreen ? 12 : 14,
            color: const Color(0xFF71A166),
          ),
          SizedBox(width: isSmallScreen ? 4 : 6),
          Text(
            '${accuracy?.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF71A166),
            ),
          ),
        ],
      ),
    );
  }

  // Widget placeholder ketika gambar tidak tersedia
  Widget _buildImagePlaceholder(
    Map<String, dynamic> activity,
    bool isSmallScreen,
  ) {
    final statusColor = activity['statusColor'] as Color;

    return Stack(
      children: [
        Container(color: statusColor.withOpacity(0.15)),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.agriculture_rounded,
                size: isSmallScreen ? 60 : 70,
                color: statusColor.withOpacity(0.5),
              ),
              SizedBox(height: isSmallScreen ? 6 : 10),
              Text(
                'No Image',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: statusColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: isSmallScreen ? 12 : 16,
          left: isSmallScreen ? 12 : 16,
          child: _buildStatusBadge(activity, isSmallScreen),
        ),
        if (activity['accuracy'] != null)
          Positioned(
            top: isSmallScreen ? 12 : 16,
            right: isSmallScreen ? 12 : 16,
            child: _buildAccuracyBadge(activity, isSmallScreen),
          ),
      ],
    );
  }
}
