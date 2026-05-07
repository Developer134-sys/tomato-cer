// File: lib/services/recommendation_service.dart

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

  // DESKRIPSI PENYAKIT (penyebab, gejala, dampak)
  static final Map<String, String> descriptions = {
    "Bacterial_spot": 
        "Penyakit ini disebabkan oleh bakteri **Xanthomonas campestris pv. vesicatoria**. "
        "Gejala awal berupa bercak-bercak kecil berwarna hijau tua seperti basah air pada daun, "
        "kemudian berubah menjadi hitam kecoklatan dengan pinggiran kuning. "
        "Pada kondisi lembab, bercak dapat menyatu dan menyebabkan daun mengering. "
        "Penyakit ini menyebar cepat melalui percikan air hujan, angin, dan serangga. "
        "Infeksi berat dapat menyebabkan kerontokan daun dan menurunkan hasil panen hingga 50%.",

    "Early_blight": 
        "Disebabkan oleh jamur **Alternaria solani**. Gejala khas berupa bercak coklat kehitaman "
        "berbentuk lingkaran konsentris seperti **target panah** pada daun tua. "
        "Bercak mulai dari daun bagian bawah kemudian menyebar ke atas. "
        "Pada batang, muncul bercak coklat agak oval. Buah juga dapat terinfeksi "
        "menyebabkan bercak hitam di sekitar tangkai. Penyakit ini berkembang cepat "
        "pada suhu hangat (25-30°C) dengan kelembaban tinggi.",

    "Late_blight": 
        "Penyakit paling berbahaya pada tomat yang disebabkan oleh **Phytophthora infestans**, "
        "jamur air yang sama penyebab hawar daun kentang. Gejala awal berupa bercak basah "
        "kehijauan pada daun yang cepat meluas menjadi hitam kecoklatan. "
        "Pada batang, muncul bercak hitam memanjang. Dalam kondisi lembab, tumbuh "
        "jamur putih seperti beludru di tepi bawah daun. Tanaman dapat mati dalam "
        "waktu 7-10 hari setelah infeksi pertama. Menyebabkan gagal panen total.",

    "Leaf_Mold": 
        "Disebabkan oleh jamur **Passalora fulva** (sebelumnya Fulvia fulva). "
        "Gejala muncul bercak kuning pucat pada permukaan atas daun. "
        "Pada permukaan bawah daun, tumbuh lapisan jamur berwarna **zaitun keabu-abuan** "
        "seperti beludru. Daun yang terinfeksi berat menggulung, mengering, dan rontok. "
        "Penyakit ini sangat umum terjadi pada rumah kaca atau tanaman dengan "
        "sirkulasi udara buruk dan kelembaban tinggi (85%+).",

    "Septoria_leaf_spot": 
        "Penyebabnya adalah jamur **Septoria lycopersici**. Gejala khas berupa **bercak kecil bulat** "
        "berdiameter 2-5 mm dengan pinggiran hitam dan pusat berwarna abu-abu keputihan. "
        "Bercak muncul pertama pada daun bagian bawah kemudian menyebar ke atas. "
        "Daun yang terinfeksi berat menguning dan rontok dari bawah ke atas. "
        "Penyakit ini menyebar melalui percikan air dan spora jamur yang dapat "
        "bertahan di sisa-sisa tanaman selama 2-3 tahun.",

    "Spider_mites Two-spotted_spider_mite": 
        "Disebabkan oleh tungau kecil **Tetranychus urticae** yang sulit dilihat dengan mata telanjang. "
        "Gejala awal berupa **bercak-bercak kuning kecil** (stippling) pada permukaan atas daun. "
        "Daun tampak berbintik-bintik, kemudian menguning, mengering, dan rontok. "
        "Ciri khas adanya **anyaman halus seperti sutra** di bawah daun dan di pucuk tanaman. "
        "Hama ini berkembang sangat cepat di cuaca panas dan kering. Serangan berat "
        "dapat menyebabkan daun menggulung dan tanaman kerdil.",

    "Target_Spot": 
        "Disebabkan oleh jamur **Corynespora cassiicola**. Nama 'Target Spot' berasal dari "
        "bentuk bercak yang khas yaitu **lingkaran konsentris seperti sasaran panah**. "
        "Bercak berukuran 5-15 mm dengan pinggiran kuning dan pusat coklat tua. "
        "Pada buah, menyebabkan bercak hitam cekung di sekitar tangkai. "
        "Penyakit ini menyukai suhu panas (25-30°C) dan kelembaban tinggi. "
        "Spora jamur dapat menyebar melalui udara, air, dan peralatan pertanian.",

    "Tomato_Yellow_Leaf_Curl_Virus": 
        "Penyakit virus yang ditularkan oleh **kutu kebul (Bemisia tabaci)**. "
        "Virus ini tidak bisa disembuhkan setelah tanaman terinfeksi. Gejala utama: "
        "daun muda **menggulung ke atas**, menguning di tepi, dan ukuran daun mengecil. "
        "Tanaman menjadi **kerdil (stunting)** dengan ruas batang memendek. "
        "Bunga rontok dan buah yang terbentuk kecil-kecil serta tidak matang sempurna. "
        "Virus ini dapat menyebabkan kehilangan hasil hingga 100% jika menyerang "
        "tanaman muda. Masa inkubasi gejala sekitar 2-3 minggu.",

    "Tomato_mosaic_virus": 
        "Disebabkan oleh **Tobacco Mosaic Virus (TMV)** yang sangat mudah menular melalui "
        "kontak mekanis (tangan, alat kebun, pakaian). Gejala: daun tampak **belang hijau tua "
        "dan hijau muda** (mosaik) serta menggulung ke bawah. "
        "Tanaman menjadi kerdil dengan pertumbuhan terhambat. "
        "Buah yang terinfeksi menunjukkan pola warna tidak merata (marbling) dan "
        "mengalami pematangan tidak sempurna. Virus dapat bertahan dalam "
        "sisa-sisa tanaman selama bertahun-tahun.",

    "powdery_mildew": 
        "Disebabkan oleh jamur **Oidium neolycopersici** (atau Leveillula taurica). "
        "Gejala khas muncul **lapisan tepung berwarna putih** pada permukaan atas daun, "
        "batang, dan terkadang buah. Bercak putih meluas hingga menutupi seluruh permukaan daun. "
        "Daun yang terinfeksi menguning, mengering, dan rontok dari bawah ke atas. "
        "Berbeda dengan penyakit jamur lain, embun tepung menyukai kondisi **kering** "
        "dengan kelembaban udara rendah (40-60%) dan suhu sedang (20-25°C).",

    "healthy": 
        "Tanaman tomat Anda dalam **kondisi sehat**! Daun berwarna hijau segar, "
        "tidak ditemukan tanda-tanda infeksi penyakit atau serangan hama. "
        "Tanaman menunjukkan pertumbuhan normal dengan daun yang tidak menguning, "
        "tidak berbintik, dan tidak menggulung. Pertahankan kondisi ini dengan "
        "pola perawatan yang konsisten dan terus lakukan pemantauan rutin untuk "
        "deteksi dini jika terjadi perubahan."
  };

 // Rekomendasi penanganan lengkap
static final Map<String, String> recommendations = {
  "Bacterial_spot":
      "Sanitasi & Pembersihan\n"
      "Pangkas dan segera musnahkan bagian tanaman yang terinfeksi untuk mencegah penyebaran bakteri. "
      "Jangan gunakan sisa tanaman sebagai kompos karena bakteri dapat bertahan hidup dan menyebar kembali. "
      "Lakukan rotasi tanaman dengan jenis non-solanaceae selama minimal dua tahun dan gunakan mulsa plastik untuk mencegah percikan tanah.\n\n"

      "Penyesuaian Penyiraman\n"
      "Lakukan penyiraman di pagi hari dengan metode irigasi tetes atau langsung ke akar tanaman. "
      "Hindari penyiraman dari atas karena dapat membuat daun tetap basah dan mempercepat perkembangan bakteri.\n\n"

      "Aplikasi Bakterisida\n"
      "Gunakan bakterisida berbahan dasar tembaga (copper) secara berkala sesuai dosis anjuran. "
      "Penyemprotan rutin membantu menghambat perkembangan bakteri dan melindungi tanaman dari infeksi lanjutan.",

  "Early_blight":
      "Sanitasi & Pembersihan\n"
      "Buang daun bagian bawah yang sudah terinfeksi bercak dan jaga kebersihan area tanam. "
      "Gunakan mulsa jerami untuk mencegah penyebaran spora dari tanah ke daun dan pilih varietas tahan jika tersedia.\n\n"

      "Penyesuaian Penyiraman\n"
      "Atur jarak tanam agar sirkulasi udara baik dan lingkungan tidak lembap. "
      "Siram tanaman langsung ke akar dan hindari membasahi daun.\n\n"

      "Aplikasi Fungisida\n"
      "Semprot fungisida seperti chlorothalonil atau mancozeb setiap 7–10 hari untuk menghambat perkembangan jamur.",

  "Late_blight":
      "Sanitasi & Pembersihan\n"
      "Segera cabut dan musnahkan tanaman yang terinfeksi parah dan jangan dijadikan kompos. "
      "Penyakit ini sangat cepat menyebar sehingga penanganan harus dilakukan segera.\n\n"

      "Penyesuaian Penyiraman\n"
      "Kurangi kelembaban dengan meningkatkan sirkulasi udara dan gunakan irigasi tetes. "
      "Hindari penyiraman dari atas agar daun tetap kering.\n\n"

      "Aplikasi Fungisida\n"
      "Gunakan fungisida seperti mancozeb untuk pencegahan dan metalaxyl untuk pengobatan serta lakukan pemantauan setiap hari.",

  "Leaf_Mold":
      "Sanitasi & Pembersihan\n"
      "Buang daun yang terinfeksi dan jaga kebersihan tanaman untuk mengurangi sumber jamur.\n\n"

      "Penyesuaian Penyiraman\n"
      "Kurangi kelembaban dengan meningkatkan sirkulasi udara dan hindari penyiraman pada daun.\n\n"

      "Aplikasi Fungisida\n"
      "Gunakan fungisida berbahan chlorothalonil atau tembaga secara rutin untuk mengendalikan penyakit.",

  "Septoria_leaf_spot":
      "Sanitasi & Pembersihan\n"
      "Pangkas daun bagian bawah yang terinfeksi dan bersihkan sisa tanaman setelah panen.\n\n"

      "Penyesuaian Penyiraman\n"
      "Gunakan mulsa untuk mencegah percikan tanah dan lakukan rotasi tanaman dengan tanaman non-tomat.\n\n"

      "Aplikasi Fungisida\n"
      "Gunakan fungisida berbahan tembaga atau chlorothalonil secara berkala.",

  "Spider_mites Two-spotted_spider_mite":
      "Sanitasi & Pembersihan\n"
      "Isolasi tanaman yang terinfeksi dan bersihkan daun menggunakan air sabun ringan atau minyak neem.\n\n"

      "Penyesuaian Lingkungan\n"
      "Tingkatkan kelembaban karena tungau tidak menyukai lingkungan lembap.\n\n"

      "Pengendalian Hama\n"
      "Gunakan akarisida seperti abamectin atau fenpyroximate dan manfaatkan predator alami.",

  "Target_Spot":
      "Sanitasi & Pembersihan\n"
      "Buang daun yang terinfeksi secara rutin dan jaga kebersihan lingkungan tanaman.\n\n"

      "Penyesuaian Penyiraman\n"
      "Perbaiki ventilasi dan kurangi kelembaban di sekitar tanaman.\n\n"

      "Aplikasi Fungisida\n"
      "Gunakan fungisida seperti difenokonazol, azoksistrobin, atau mancozeb secara berkala.",

  "Tomato_Yellow_Leaf_Curl_Virus":
      "Sanitasi & Pembersihan\n"
      "Cabut dan musnahkan tanaman yang terinfeksi karena virus tidak dapat disembuhkan.\n\n"

      "Penyesuaian Lingkungan\n"
      "Gunakan mulsa reflektif untuk mengusir kutu kebul dan kurangi penyebaran virus.\n\n"

      "Pengendalian Hama\n"
      "Kendalikan kutu kebul menggunakan insektisida dan perangkap kuning serta gunakan varietas tahan.",

  "Tomato_mosaic_virus":
      "Sanitasi & Pembersihan\n"
      "Buang tanaman terinfeksi dan sterilkan alat kebun dengan larutan pemutih.\n\n"

      "Kebersihan\n"
      "Cuci tangan sebelum dan sesudah menyentuh tanaman dan hindari merokok di dekat tanaman.\n\n"

      "Pencegahan\n"
      "Gunakan varietas tahan untuk mengurangi risiko infeksi.",

  "powdery_mildew":
      "Sanitasi & Pembersihan\n"
      "Buang bagian tanaman yang terinfeksi dan jaga kebersihan area tanam.\n\n"

      "Penyesuaian Lingkungan\n"
      "Kurangi kelembaban dan tingkatkan sirkulasi udara.\n\n"

      "Aplikasi Fungisida\n"
      "Gunakan sulfur, kalium bikarbonat, atau alternatif organik seperti larutan susu dan neem oil.",

  "healthy":
      "Perawatan Rutin\n"
      "Jaga kebersihan tanaman dan lingkungan serta lakukan pemantauan secara berkala.\n\n"

      "Penyiraman\n"
      "Siram tanaman secara teratur di pagi hari langsung ke akar.\n\n"

      "Nutrisi\n"
      "Berikan pupuk seimbang setiap dua minggu dan bersihkan gulma di sekitar tanaman."
};

  // Helper method untuk mendapatkan deskripsi
  static String getDescription(String label) {
    return descriptions[label] ?? 
        "Informasi lebih lanjut tentang penyakit ini sedang dikumpulkan. "
        "Konsultasikan dengan ahli pertanian setempat untuk penanganan yang tepat.";
  }

  // Helper method untuk mendapatkan nama penyakit
  static String getDiseaseName(String label) {
    return diseaseNames[label] ?? label;
  }

  // Helper method untuk mendapatkan rekomendasi
  static String getRecommendation(String label) {
    return recommendations[label] ?? 
        "Lakukan konsultasi dengan ahli pertanian untuk penanganan lebih lanjut.";
  }
}