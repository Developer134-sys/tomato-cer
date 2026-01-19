import 'package:flutter/material.dart';
import '../models/disease_model.dart';

class DiseaseData {
  static List<DiseaseInfo> getDiseases() {
    return [
      DiseaseInfo(
        title: "Bacterial Spot",
        description: "Bercak hitam kecil di daun akibat infeksi bakteri.",
        icon: Icons.water_damage,
        color: const Color(0xFF080C18),
        materi: """
Bacterial Spot adalah penyakit bakteri yang disebabkan oleh Xanthomonas spp. 

**Gejala:**
- Bercak kecil berwarna hijau gelap hingga hitam pada daun
- Bercak dapat meluas dan bergabung menjadi area nekrotik besar
- Daun menguning dan rontok sebelum waktunya
- Lesi juga dapat muncul pada batang dan buah

**Penyebab:**
- Bakteri Xanthomonas campestris pv. vesicatoria
- Penyebaran melalui percikan air, alat pertanian, dan biji terinfeksi

**Pengendalian:**
- Gunakan benih sehat dan bebas penyakit
- Rotasi tanaman dengan tanaman non-solanaceae
- Hindari penyiraman dari atas tanaman
- Aplikasi bakterisida tembaga

**Pencegahan:**
- Sanitasi alat pertanian secara rutin
- Hindari bekerja di kebun saat tanaman basah
- Gunakan mulsa plastik untuk mengurangi percikan air
""",
        imageAsset: "assets/images/bacterial_spot.JPG",
      ),
      DiseaseInfo(
        title: "Early Blight",
        description: "Bercak coklat dengan lingkaran konsentris.",
        icon: Icons.brightness_high,
        color: Colors.orange,
        materi: """
Early Blight disebabkan oleh jamur Alternaria solani.

**Gejala:**
- Bercak coklat dengan pola lingkaran konsentris seperti target
- Biasanya menyerang daun tua terlebih dahulu
- Daun menguning di sekitar bercak
- Dapat menyerang batang dan buah

**Penyebab:**
- Jamur Alternaria solani
- Kondisi lembap dan hangat (20-30°C)
- Kelembapan tinggi dan curah hujan

**Pengendalian:**
- Rotasi tanaman minimal 3 tahun
- Pemangkasan daun terinfeksi
- Fungisida berbahan aktif chlorothalonil atau mancozeb
- Jarak tanam yang cukup untuk sirkulasi udara

**Pencegahan:**
- Pemupukan nitrogen yang seimbang
- Hindari kekurangan air yang membuat tanaman stres
- Panen dan buang daun terinfeksi
""",
        imageAsset: "assets/images/early_blight.JPG",
      ),
      DiseaseInfo(
        title: "Late Blight",
        description: "Daun tampak basah dan cepat menyebar saat lembap.",
        icon: Icons.cloudy_snowing,
        color: Colors.blueGrey,
        materi: """
Late Blight adalah penyakit mematikan yang disebabkan oleh Phytophthora infestans.

**Gejala:**
- Bercak basah berwarna hijau gelap pada daun
- Tepi bercak berwarna pucat seperti berjamur putih
- Menyebar sangat cepat dalam kondisi lembap
- Menyebabkan kebusukan total pada tanaman

**Penyebab:**
- Oomycete Phytophthora infestans
- Kondisi dingin dan lembap (10-25°C)
- Kelembapan relatif >90%

**Pengendalian:**
- Gunakan varietas tahan
- Hindari penanaman terlalu rapat
- Fungisida sistemik seperti metalaxyl
- Sanitasi lahan dari sisa tanaman sakit

**Pencegahan:**
- Monitoring cuaca untuk periode lembap
- Aplikasi fungisida preventif saat kondisi mendukung
- Hindari irigasi overhead
""",
        imageAsset: "assets/images/Late_blight.jpg",
      ),
      DiseaseInfo(
        title: "Leaf Mold",
        description: "Jamur menyebabkan warna kuning & bercak beludru.",
        icon: Icons.eco,
        color: Color(0xFFB4B23D),
        materi: """
Leaf Mold disebabkan oleh jamur Cladosporium fulvum.

**Gejala:**
- Bercak kuning tidak beraturan di permukaan daun atas
- Lapisan beludru berwarna hijau zaitun di bawah daun
- Daun mengering dan menggulung
- Pertumbuhan tanaman terhambat

**Penyebab:**
- Jamur Cladosporium fulvum
- Kelembapan tinggi dan suhu moderat
- Sirkulasi udara buruk

**Pengendalian:**
- Kontrol kelembapan dalam rumah kaca
- Ventilasi yang baik
- Fungisida seperti sulfur atau copper-based
- Hindari penyiraman berlebihan

**Pencegahan:**
- Jarak tanam yang memadai
- Pemangkasan daun bawah untuk sirkulasi udara
- Hindari suhu malam yang terlalu dingin
""",
        imageAsset: "assets/images/Leaf_Mold.JPG",
      ),
      DiseaseInfo(
        title: "Septoria Leaf Spot",
        description: "Banyak titik kecil coklat di daun bawah.",
        icon: Icons.circle_outlined,
        color: Colors.brown,
        materi: """
Septoria Leaf Spot disebabkan oleh jamur Septoria lycopersici.

**Gejala:**
- Bercak kecil bulat berwarna coklat pada daun tua
- Pusat bercak berwarna pucat dengan titik hitam (pycnidia)
- Daun menguning secara progresif dari bawah
- Daun rontok secara prematur

**Penyebab:**
- Jamur Septoria lycopersici
- Percikan air dari tanah
- Suhu optimal 15-27°C

**Pengendalian:**
- Mulsa untuk mencegah percikan air
- Rotasi tanaman 2-3 tahun
- Fungisida chlorothalonil atau maneb
- Pemangkasan daun terinfeksi

**Pencegahan:**
- Hindari overhead irrigation
- Sanitasi tanaman sakit
- Gunakan varietas yang lebih toleran
""",
        imageAsset: "assets/images/Septoria_leaf_spot.JPG",
      ),
      DiseaseInfo(
        title: "Spider Mites",
        description: "Bercak kuning dan putih seperti pasir.",
        icon: Icons.pest_control,
        color: Colors.purple,
        materi: """
Spider Mites (Two-spotted Spider Mite) adalah tungau kecil dari keluarga Tetranychidae.

**Gejala:**
- Bintik-bintik kuning atau putih seperti pasir pada daun
- Jaring halus di bawah daun atau antara daun
- Daun mengering dan keriting
- Pertumbuhan terhambat

**Penyebab:**
- Tungau Tetranychus urticae
- Kondisi panas dan kering
- Populasi tinggi di musim kemarau

**Pengendalian:**
- Semprotan air untuk meningkatkan kelembapan
- Predator alami seperti Phytoseiulus persimilis
- Akarisida seperti abamectin atau spiromesifen
- Minyak nimba atau sabun insektisida

**Pencegahan:**
- Monitoring rutin dengan kaca pembesar
- Hindari pemupukan nitrogen berlebihan
- Jaga kelembapan yang memadai
""",
        imageAsset: "assets/images/spider_mites.JPG",
      ),
      DiseaseInfo(
        title: "Target Spot",
        description: "Bercak seperti sasaran tembak dengan lingkaran.",
        icon: Icons.my_location,
        color: Colors.deepOrange,
        materi: """
Target Spot disebabkan oleh jamur Corynespora cassiicola.

**Gejala:**
- Bercak bulat dengan pola lingkaran konsentris seperti target
- Pusat bercak berwarna coklat dengan tepi kuning
- Dapat menyerang daun, batang, dan buah
- Daun rontok prematur saat infeksi berat

**Penyebab:**
- Jamur Corynespora cassiicola
- Suhu hangat (20-30°C) dan kelembapan tinggi
- Penyebaran melalui spora di udara

**Pengendalian:**
- Fungisida seperti azoxystrobin atau pyraclostrobin
- Rotasi tanaman dengan non-inang
- Sanitasi sisa tanaman

**Pencegahan:**
- Hindari kondisi yang terlalu lembap
- Pemangkasan untuk meningkatkan sirkulasi udara
- Monitoring rutin gejala awal
""",
        imageAsset: "assets/images/Target_Spot.JPG",
      ),
      DiseaseInfo(
        title: "Tomato Yellow Leaf Curl Virus",
        description: "Daun keriting dan menguning, pertumbuhan terhambat.",
        icon: Icons.coronavirus,
        color: Colors.yellow.shade700,
        materi: """
Tomato Yellow Leaf Curl Virus (TYLCV) adalah penyakit virus yang ditularkan oleh kutu kebul.

**Gejala:**
- Daun menguning dan menggulung ke atas
- Pertumbuhan tanaman kerdil
- Ruas antar daun memendek
- Produksi bunga dan buah menurun drastic

**Penyebab:**
- Virus TYLCV
- Vektor: Kutu kebul (Bemisia tabaci)
- Penularan melalui serangga vektor

**Pengendalian:**
- Kontrol kutu kebul dengan insektisida
- Gunakan varietas tahan virus
- Cabut dan hancurkan tanaman terinfeksi
- Penggunaan screen house

**Pencegahan:**
- Tanam bibit bebas virus
- Kontrol gulma inang alternatif
- Rotasi dengan tanaman non-inang
""",
        imageAsset: "assets/images/Tomato_Yellow_Leaf_Curl_Virus.jpg",
      ),
      DiseaseInfo(
        title: "Tomato Mosaic Virus",
        description: "Pola mosaik kuning-hijau pada daun.",
        icon: Icons.grain,
        color: Colors.amber,
        materi: """
Tomato Mosaic Virus (ToMV) adalah penyakit virus yang umum pada tanaman tomat.

**Gejala:**
- Pola mosaik hijau muda dan hijau tua pada daun
- Daun keriting dan deformasi
- Pertumbuhan terhambat
- Buah menunjukkan gejala mosaik dan kualitas menurun

**Penyebab:**
- Tomato Mosaic Virus (ToMV)
- Penularan melalui kontak, biji, dan alat pertanian
- Stabilitas virus yang tinggi di lingkungan

**Pengendalian:**
- Gunakan benih bersertifikat bebas virus
- Sanitasi alat pertanian dengan desinfektan
- Hindari merokok di sekitar tanaman (virus tahan pada tembakau)

**Pencegahan:**
- Cuci tangan sebelum menangani tanaman
- Rotasi tanaman yang cukup lama
- Hindari penanaman dekat tanaman terinfeksi
""",
        imageAsset: "assets/images/Tomato_mosaic_virus.JPG",
      ),
      DiseaseInfo(
        title: "Powdery Mildew",
        description: "Lapisan putih seperti tepung pada daun.",
        icon: Icons.ac_unit,
        color: Colors.blue.shade300,
        materi: """
Powdery Mildew adalah penyakit jamur yang menyerang permukaan daun.

**Gejala:**
- Lapisan tepung putih pada permukaan daun
- Daun menguning di bawah lapisan jamur
- Pertumbuhan terhambat
- Pada kasus berat, daun mengering dan rontok

**Penyebab:**
- Jamur Oidium lycopersici
- Kondisi kelembapan sedang dengan sirkulasi udara buruk
- Suhu optimal 20-27°C

**Pengendalian:**
- Fungisida sulfur atau potassium bicarbonate
- Minyak nimba atau minyak horticultural
- Biofungisida seperti Ampelomyces quisqualis

**Pencegahan:**
- Sirkulasi udara yang baik
- Hindari penanaman terlalu rapat
- Pemangkasan daun terinfeksi awal
""",
        imageAsset: "assets/images/powdery_mildew.jpg",
      ),
      DiseaseInfo(
        title: "Daun Sehat",
        description: "Daun normal tanpa gejala penyakit.",
        icon: Icons.health_and_safety,
        color: Colors.green,
        materi: """
Ciri-ciri tanaman tomat yang sehat dan normal.

**Karakteristik Daun Sehat:**
- Warna hijau merata dan cerah
- Tekstur daun halus dan kuat
- Bentuk daun simetris dan normal
- Pertumbuhan seragam dan vigor

**Indikator Kesehatan:**
- Tidak ada bercak, lubang, atau perubahan warna abnormal
- Batang kuat dan tegak
- Akar putih dan berkembang baik
- Produksi bunga dan buah normal

**Pemeliharaan Preventif:**
- Pemupukan berimbang sesuai fase pertumbuhan
- Penyiraman teratur dan konsisten
- Pengendalian hama secara preventif
- Pemantauan rutin kesehatan tanaman
- Rotasi tanaman untuk memutus siklus penyakit

**Tips Perawatan:**
- Lakukan inspeksi visual mingguan
- Catat perubahan yang tidak normal
- Segera tindak lanjuti gejala awal
- Pertahankan kebersihan kebun
""",
        imageAsset: "assets/images/healthy.jpg",
      ),
    ];
  }
}
