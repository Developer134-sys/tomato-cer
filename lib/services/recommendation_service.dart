class RecommendationService {
  // Nama penyakit agar lebih ramah di UI
  static final Map<String, String> diseaseNames = {
    "Bacterial_spot": "Bacterial Spot",
    "Early_blight": "Early Blight",
    "Late_blight": "Late Blight",
    "Leaf_Mold": "Leaf Mold",
    "Septoria_leaf_spot": "Septoria Leaf Spot",
    "Spider_mites Two-spotted_spider_mite": "Spider Mite",
    "Target_Spot": "Target Spot",
    "Tomato_Yellow_Leaf_Curl_Virus": "Tomato Yellow Leaf Curl Virus",
    "Tomato_mosaic_virus": "Tomato Mosaic Virus",
    "powdery_mildew": "Powdery Mildew",
    "healthy": "Daun Sehat"
  };

  // Rekomendasi penanganan lengkap
  static final Map<String, String> recommendations = {
    "Bacterial_spot":
        "• Gunakan fungisida berbahan **copper** secara berkala.\n"
            "• Hindari daun basah terlalu lama.\n"
            "• Buang daun yang terinfeksi parah.",
    "Early_blight":
        "• Semprot fungisida **chlorothalonil** atau **mancozeb**.\n"
            "• Tingkatkan jarak tanam agar sirkulasi udara baik.\n"
            "• Buang daun yang sudah bercak berat.",
    "Late_blight": "• Gunakan fungisida **mancozeb** atau **metalaxyl**.\n"
        "• Segera pisahkan tanaman yang terinfeksi.\n"
        "• Kurangi kelembaban berlebih.",
    "Leaf_Mold": "• Tingkatkan sirkulasi udara di sekitar tanaman.\n"
        "• Semprot fungisida berbahan **chlorothalonil**.\n"
        "• Hindari penyiraman pada daun.",
    "Septoria_leaf_spot": "• Gunakan fungisida **tembaga (copper)**.\n"
        "• Pangkas daun bagian bawah.\n"
        "• Gunakan mulsa agar percikan tanah tidak menyentuh daun.",
    "Spider_mites Two-spotted_spider_mite":
        "• Gunakan **akarisida** seperti abamectin.\n"
            "• Tingkatkan kelembaban (tungau tidak suka lingkungan lembab).\n"
            "• Cuci daun dengan air sabun ringan.",
    "Target_Spot":
        "• Semprot fungisida **difenokonazol** atau **azoksistrobin**.\n"
            "• Perbaiki ventilasi dan kurangi kelembapan.\n"
            "• Buang daun yang terinfeksi berat.",
    "Tomato_Yellow_Leaf_Curl_Virus":
        "• Kendalikan **kutu kebul (whitefly)** penyebab utama.\n"
            "• Gunakan perangkap kuning.\n"
            "• Tanam varietas tahan TYLCV.",
    "Tomato_mosaic_virus": "• Sterilisasi semua alat kebun.\n"
        "• Buang tanaman terinfeksi (virus tidak bisa disembuhkan).\n"
        "• Hindari kontak langsung antara tanaman sehat & sakit.",
    "powdery_mildew": "• Gunakan **belerang cair (sulfur)**.\n"
        "• Kurangi kelembapan dan tingkatkan ventilasi.\n"
        "• Bisa pakai larutan susu 10% sebagai alternatif organik.",
    "healthy":
        "Daun sehat. Tidak diperlukan tindakan. Pertahankan pola perawatan rutin."
  };
}
