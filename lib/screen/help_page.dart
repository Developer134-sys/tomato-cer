import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  final List<String> categories = [
    'Semua',
    'Deteksi Penyakit',
    'Aplikasi',
    'Umum',
  ];

  // SEMUA ARTIKEL DISIMPAN LOKAL
  final List<HelpArticle> allArticles = [
    HelpArticle(
      id: '1',
      title: 'Cara foto daun yang benar',
      description:
          'Panduan mengambil foto daun tomat untuk hasil deteksi maksimal',
      content: '''
📸 CARA MEMFOTO DAUN TOMAT YANG BENAR

1️⃣ Pilih daun yang sakit
   • Ambil daun yang menunjukkan gejala penyakit
   • Hindari daun yang sudah terlalu kering atau busuk
   • Pilih daun dengan bercak/luka yang jelas

2️⃣ Latar belakang polos
   • Gunakan latar belakang gelap atau putih
   • Hindari background yang ramai (tanah, daun lain)
   • Letakkan daun di atas kertas putih jika perlu

3️⃣ Pencahayaan cukup
   • Foto di siang hari dengan cahaya alami
   • Hindari bayangan yang menutupi daun
   • Jangan gunakan flash (bisa membuat silau)

4️⃣ Posisi kamera
   • Jepret dari jarak 10-15 cm
   • Pastikan seluruh daun terlihat jelas
   • Fokuskan ke area yang terkena penyakit
   • Pegang HP dengan stabil (kedua tangan)

5️⃣ Yang HARUS dihindari:
   ✗ Daun basah/berembun
   ✗ Tangan yang menghalangi daun
   ✗ Foto buram/goyang
   ✗ Daun terlalu kecil

💡 TIPS: Ambil 2-3 foto dari sudut berbeda
''',
      category: 'Deteksi Penyakit',
      icon: Icons.photo_camera,
      isPopular: true,
    ),
    HelpArticle(
      id: '2',
      title: 'Hasil deteksi kurang akurat',
      description: 'Solusi jika hasil deteksi tidak sesuai',
      content: '''
⚠️ SOLUSI HASIL DETEKSI KURANG AKURAT

🔍 PENYEBAB UMUM:
   1. Foto kurang jelas/buram
   2. Pencahayaan tidak cukup
   3. Daun terlalu kecil atau terlalu muda
   4. Background (latar belakang) terlalu ramai
   5. Area penyakit tidak terlihat jelas

✅ SOLUSI:

☑️ Ulang foto dengan panduan "Cara foto yang benar"
☑️ Pastikan area penyakit terlihat jelas di foto
☑️ Gunakan daun dewasa yang sudah menunjukkan gejala
☑️ Coba deteksi ulang 2-3 kali
☑️ Ambil foto lebih dekat (zoom tapi tetap jelas)
☑️ Gunakan latar belakang polos (kertas putih)

📊 TINGKAT AKURASI:
   • Deteksi berhasil: >70% percaya diri
   • Perlu ulang: <70% percaya diri
   • Gagal: Foto terlalu buram

💡 Apakah aplikasi perlu internet?
   YA! TomatoCare membutuhkan koneksi internet
   untuk melakukan deteksi penyakit

❓ Jika masih bermasalah:
   Hubungi tim support melalui menu Hubungi Kami
''',
      category: 'Deteksi Penyakit',
      icon: Icons.warning,
      isPopular: true,
    ),
    HelpArticle(
      id: '3',
      title: 'Aplikasi force close',
      description: 'Mengatasi aplikasi yang tiba-tiba tertutup',
      content: '''
🔧 MENGATASI APLIKASI FORCE CLOSE

LANGKAH-LANGKAH:

1️⃣ Bersihkan Cache Aplikasi
   • Android: Settings → Apps → TomatoCare → Clear Cache
   • iOS: Settings → General → iPhone Storage → TomatoCare → Offload App

2️⃣ Update Aplikasi
   • Pastikan Anda menggunakan versi terbaru
   • Cek Google Play Store / App Store

3️⃣ Restart HP
   • Kadang solusi sederhana ini sangat ampuh!
   • Matikan HP selama 30 detik, nyalakan lagi

4️⃣ Reinstall Aplikasi
   • Hapus TomatoCare
   • Install ulang dari Google Play Store
   • Login kembali dengan akun Anda

5️⃣ Cek Ruang Penyimpanan
   • Pastikan masih ada ruang kosong minimal 500MB
   • Hapus file/cache yang tidak perlu

6️⃣ Cek Koneksi Internet
   • Pastikan internet Anda stabil
   • Coba ganti ke WiFi atau mobile data
''',
      category: 'Aplikasi',
      icon: Icons.error_outline,
      isPopular: false,
    ),
    HelpArticle(
      id: '4',
      title: 'Cara menggunakan TomatoCare',
      description:
          'Panduan lengkap mulai dari registrasi hingga deteksi penyakit',
      content: '''
🍅 PANDUAN LENGKAP TOMATOCARE

📝 LANGKAH 1: REGISTRASI AKUN
   • Buka aplikasi TomatoCare
   • Pastikan HP terhubung ke INTERNET
   • Klik tombol "Daftar" atau "Register"
   • Isi data yang diperlukan:
     - Nama lengkap
     - Email aktif
     - Password (minimal 6 karakter)
   • Klik "Daftar" untuk menyelesaikan

🔐 LANGKAH 2: LOGIN
   • Jika sudah punya akun, klik "Masuk"
   • Pastikan koneksi INTERNET aktif
   • Masukkan email dan password
   • Klik "Login" untuk masuk ke aplikasi
   • Centang "Ingat Saya" jika ingin tetap login

📱 LANGKAH 3: HALAMAN UTAMA
   • Setelah login, Anda akan masuk ke halaman utama
   • Pastikan INTERNET tetap aktif
   • Terdapat tombol KAMERA untuk deteksi
   • Menu RIWAYAT untuk melihat hasil deteksi
   • Menu BANTUAN untuk panduan (Anda di sini!)

📸 LANGKAH 4: AMBIL FOTO
   • Klik tombol KAMERA (ikon kamera)
   • Arahkan ke daun tomat yang sakit
   • Ikuti panduan "Cara foto yang benar"
   • Klik tombol lingkaran untuk ambil foto

🔍 LANGKAH 5: DETEKSI
   • Setelah foto diambil, klik "DETEKSI"
   • Pastikan INTERNET dalam keadaan AKTIF
   • Tunggu 3-5 detik (AI di server sedang menganalisa)
   • Hasil deteksi akan muncul

📊 LANGKAH 6: LIHAT HASIL
   • Nama penyakit yang terdeteksi
   • Tingkat akurasi (persentase kepercayaan)
   • Deskripsi penyakit
   • Rekomendasi penanganan
   • Riwayat akan tersimpan otomatis

💾 LANGKAH 7: SIMPAN ATAU ULANG
   • Klik "SIMPAN" → hasil tersimpan ke riwayat
   • Klik "ULANGI" → foto lagi
   • Klik "BAGIKAN" → share hasil ke WhatsApp/medsos

📜 LANGKAH 8: LIHAT RIWAYAT
   • Klik menu RIWAYAT (di bagian bawah)
   • Semua hasil deteksi tersimpan di sini
   • Klik salah satu untuk lihat detail
   • Riwayat tersimpan di cloud (butuh internet)

💡 FITUR YANG TERSEDIA:
   ✅ Registrasi & Login pengguna
   ✅ Deteksi penyakit (WAJIB internet)
   ✅ Riwayat deteksi tersimpan di cloud
   ✅ Share hasil ke media sosial
   ✅ Dukungan email (butuh internet)

⚠️ CATATAN PENTING:
   • APLIKASI WAJIB menggunakan INTERNET
   • Deteksi tidak bisa dilakukan offline
   • Pastikan koneksi internet stabil
   • Data riwayat tersimpan di cloud (aman)
   • Jangan lupa password Anda!
   • Ganti password bisa melalui menu Profil

❓ Lupa password?
   • Klik "Lupa Password" di halaman login
   • Masukkan email terdaftar
   • Pastikan internet aktif
   • Ikuti instruksi yang dikirim ke email

📶 REKOMENDASI:
   • Gunakan WiFi untuk hasil lebih stabil
   • Kuota data minimal 3G/4G
   • Hindari deteksi saat sinyal lemah
''',
      category: 'Umum',
      icon: Icons.play_circle_outline,
      isPopular: true,
    ),
    HelpArticle(
      id: '5',
      title: 'Apakah aplikasi butuh internet?',
      description: 'Penjelasan lengkap tentang kebutuhan internet',
      content: '''
📡 APLIKASI WAJIB INTERNET!

✅ WAJIB INTERNET (ONLINE):
   • Registrasi akun baru
   • Login ke aplikasi
   • DETEKSI PENYAKIT (FITUR UTAMA)
   • Melihat riwayat deteksi
   • Menghubungi support via email
   • Share hasil ke media sosial
   • Update aplikasi ke versi terbaru
   • Lupa password / reset password

💡 MENGAPA WAJIB INTERNET?

AI (Artificial Intelligence) yang mendeteksi 
penyakit berada di SERVER cloud kami.
Jadi HP Anda mengirim foto ke server,
server memproses, lalu mengirim hasilnya.

📱 KEUNTUNGAN DENGAN INTERNET:
   • Akurasi deteksi lebih tinggi
   • Database penyakit selalu update
   • Riwayat tersimpan di cloud (tidak hilang)
   • Bisa akses riwayat dari perangkat lain
   • Data lebih aman

⚠️ PERHATIAN:
   • JANGAN deteksi saat sinyal lemah
   • Pastikan kuota internet mencukupi
   • Deteksi membutuhkan sekitar 1-2MB per foto
   • Aplikasi TIDAK BISA digunakan offline

📶 TIPS KONEKSI INTERNET:
   • Gunakan WiFi di rumah/kantor
   • Pastikan sinyal 3G/4G stabil
   • Hindari daerah dengan sinyal buruk
   • Matikan mode hemat data jika perlu

🔋 TIPS HEMAT KUOTA:
   • Gunakan WiFi untuk deteksi rutin
   • Batch deteksi (kumpulkan beberapa daun)
   • Hindari deteksi berulang yang tidak perlu

❌ APLIKASI TIDAK BISA OFFLINE
   • Tidak ada fitur offline sama sekali
   • Semua fitur membutuhkan internet
   • Pastikan internet selalu aktif

📊 ESTIMASI PEMAKAIAN KUOTA:
   • Registrasi: ~500KB
   • Login: ~100KB
   • Deteksi per foto: ~1-2MB
   • Lihat riwayat: ~500KB
   • Share hasil: ~1MB

💪 REKOMENDASI:
   • Paket internet minimal 1GB/bulan
   • Atau gunakan WiFi gratis di tempat umum
''',
      category: 'Umum',
      icon: Icons.wifi,
      isPopular: false,
    ),
  ];

  List<HelpArticle> get _filteredArticles {
    List<HelpArticle> filtered = allArticles;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (article) =>
                article.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                article.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    if (_selectedCategory != 'Semua') {
      filtered = filtered
          .where((article) => article.category == _selectedCategory)
          .toList();
    }

    return filtered;
  }

  List<HelpArticle> get _popularArticles =>
      allArticles.where((a) => a.isPopular).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F4),
      appBar: AppBar(
        title: const Text(
          'Bantuan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic, color: Colors.black87),
            onPressed: () => _showContactDialog(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'about',
                child: Text('Tentang Aplikasi'),
              ),
              const PopupMenuItem(
                value: 'privacy',
                child: Text('Kebijakan Privasi'),
              ),
              const PopupMenuItem(value: 'rate', child: Text('Beri Rating')),
            ],
            onSelected: (value) {
              if (value == 'about') {
                _showAboutDialog();
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildSearchBar(),
        ),
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: _filteredArticles.isEmpty
                ? _buildEmptySearch()
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_searchQuery.isEmpty &&
                          _selectedCategory == 'Semua') ...[
                        _buildPopularTopics(),
                        const SizedBox(height: 24),
                      ],
                      _buildAllArticles(),
                      const SizedBox(height: 16),
                      _buildContactCard(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Cari bantuan...',
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _searchQuery = ''),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((category) {
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF2E7D32),
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF2E7D32)
                      : Colors.grey.shade300,
                ),
                shape: const StadiumBorder(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPopularTopics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Topik Populer',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: _popularArticles.length,
          itemBuilder: (context, index) {
            final article = _popularArticles[index];
            return _buildPopularCard(article);
          },
        ),
      ],
    );
  }

  Widget _buildPopularCard(HelpArticle article) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        onTap: () => _showArticleDetail(article),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  article.icon,
                  size: 24,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_searchQuery.isEmpty && _selectedCategory == 'Semua') ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Semua Bantuan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredArticles.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final article = _filteredArticles[index];
            return _buildArticleTile(article);
          },
        ),
      ],
    );
  }

  Widget _buildArticleTile(HelpArticle article) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => _showArticleDetail(article),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  article.icon,
                  size: 24,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.headset_mic,
              size: 28,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Butuh bantuan lebih lanjut?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hubungi tim support kami',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showContactDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Hubungi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Tidak ada hasil ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kata kunci yang lain',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _showArticleDetail(HelpArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF2E7D32,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    article.icon,
                                    size: 28,
                                    color: const Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        article.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              article.content,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              foregroundColor: Colors.black87,
                            ),
                            child: const Text('Tutup'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showContactDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Hubungi Support'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showContactDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.headset_mic, color: Color(0xFF2E7D32)),
                    SizedBox(width: 8),
                    Text(
                      'Hubungi Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF2E7D32),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kami akan merespon dalam 1x24 jam',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Email Support:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.email,
                            size: 20,
                            color: Color(0xFF2E7D32),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'cihuyprojek@gmail.com',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.copy,
                              size: 18,
                              color: Color(0xFF2E7D32),
                            ),
                            onPressed: () async {
                              await Clipboard.setData(
                                const ClipboardData(
                                  text: 'cihuyprojek@gmail.com',
                                ),
                              );
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email telah disalin'),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih metode:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildContactOption(
                      icon: Icons.email,
                      title: 'Buka Aplikasi Email',
                      subtitle: 'Gmail, Outlook, dll',
                      onTap: () async {
                        Navigator.pop(context);
                        await _openEmailWithMailto();
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildContactOption(
                      icon: Icons.web,
                      title: 'Buka Gmail Web',
                      subtitle: 'Via browser',
                      onTap: () async {
                        Navigator.pop(context);
                        await _openGmailWeb();
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildContactOption(
                      icon: Icons.copy,
                      title: 'Salin Email',
                      subtitle: 'Copy ke clipboard',
                      onTap: () async {
                        await Clipboard.setData(
                          const ClipboardData(text: 'cihuyprojek@gmail.com'),
                        );
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Email cihuyprojek@gmail.com telah disalin',
                              ),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openEmailWithMailto() async {
    final String email = 'cihuyprojek@gmail.com';
    final String subject =
        'Bantuan TomatoCare - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    final String body =
        'Halo Tim Support TomatoCare,%0A%0A'
        'Saya membutuhkan bantuan terkait:%0A'
        '(Jelaskan masalah Anda di sini)%0A%0A'
        'Detail:%0A'
        '- Versi Aplikasi: 1.0.0%0A'
        '- Perangkat: Android Device%0A%0A'
        'Terima kasih.';

    final mailtoUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );

    try {
      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri);
      } else {
        throw 'Cannot launch';
      }
    } catch (e) {
      if (mounted) {
        final bool? openWeb = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Tidak dapat membuka email'),
            content: const Text(
              'Aplikasi email tidak ditemukan. Buka Gmail via browser?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                ),
                child: const Text('Buka Gmail'),
              ),
            ],
          ),
        );

        if (openWeb == true) {
          await _openGmailWeb();
        }
      }
    }
  }

  Future<void> _openGmailWeb() async {
    final String email = 'cihuyprojek@gmail.com';
    final String subject =
        'Bantuan TomatoCare - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    final String body =
        'Halo Tim Support TomatoCare%0A%0A'
        'Saya membutuhkan bantuan terkait:%0A'
        '(Jelaskan masalah Anda di sini)%0A%0A'
        'Detail:%0A'
        '- Versi Aplikasi: 1.0.0%0A'
        '- Perangkat: Android Device%0A%0A'
        'Terima kasih.';

    final gmailUri = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=$subject&body=$body',
    );

    try {
      if (await canLaunchUrl(gmailUri)) {
        await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Cannot launch';
      }
    } catch (e) {
      if (mounted) {
        // Jika semua gagal, copy email ke clipboard
        await Clipboard.setData(
          const ClipboardData(text: 'cihuyprojek@gmail.com'),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email support: cihuyprojek@gmail.com (sudah disalin)',
            ),
            duration: Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Tentang TomatoCare',
          style: TextStyle(color: Colors.black87),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.eco, size: 48, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'TomatoCare',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Deteksi Penyakit Daun Tomat',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildInfoRow('Versi', '1.0.0'),
              const SizedBox(height: 4),
              _buildInfoRow('Mode', 'Online - WAJIB Internet'),
              const SizedBox(height: 4),
              _buildInfoRow('Developer', 'TomatoCare Team'),
              const SizedBox(height: 4),
              _buildInfoRow('Lisensi', 'Proprietary'),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  '© 2026 TomatoCare. All rights reserved.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.black87),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        Text(
          ': $value',
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}

class HelpArticle {
  final String id;
  final String title;
  final String description;
  final String content;
  final String category;
  final IconData icon;
  final bool isPopular;

  HelpArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.icon,
    required this.isPopular,
  });
}
