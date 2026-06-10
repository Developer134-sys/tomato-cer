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

Bacterial Spot adalah penyakit bakteri pada tanaman tomat yang disebabkan oleh Xanthomonas spp. Penyakit ini menyerang daun, batang, dan buah, serta mudah menyebar pada kondisi lembap.

**GEJALA**
Gejalanya berupa bercak kecil berwarna hijau gelap hingga hitam pada daun. Bercak dapat meluas dan bergabung menjadi area nekrotik besar. Daun akan menguning dan rontok sebelum waktunya, serta lesi juga dapat muncul pada batang dan buah.

**PENYEBAB**
Penyebab utamanya adalah bakteri Xanthomonas campestris pv. vesicatoria. Penyebaran terjadi melalui percikan air hujan atau irigasi, alat pertanian yang terkontaminasi, serta biji yang terinfeksi dari musim tanam sebelumnya.

**PENANGANAN**
Gunakan benih sehat dan bebas penyakit, lakukan rotasi tanaman dengan tanaman non-solanaceae (bukan keluarga terong-terongan), hindari penyiraman dari atas tanaman (gunakan irigasi tetes), serta aplikasikan bakterisida berbahan aktif tembaga secara berkala. Untuk pencegahan, sterilkan alat pertanian secara rutin dengan larutan desinfektan, hindari bekerja di kebun saat tanaman basah, dan gunakan mulsa plastik untuk mengurangi percikan air ke daun.
""",
        imageAsset: "assets/images/bacterial_spot.JPG",
      ),
      DiseaseInfo(
        title: "Early Blight",
        description: "Bercak coklat dengan lingkaran konsentris.",
        icon: Icons.brightness_high,
        color: Colors.orange,
        materi: """

Early Blight adalah penyakit jamur pada tanaman tomat yang disebabkan oleh Alternaria solani. Penyakit ini biasanya menyerang daun-daun tua terlebih dahulu dan dapat menyebar ke batang serta buah.

**GEJALA**
Gejalanya ditandai dengan bercak coklat yang memiliki pola lingkaran konsentris seperti sasaran. Penyakit ini menyerang daun bagian bawah (tua) terlebih dahulu, daun menguning di sekitar bercak, dan pada serangan berat daun akan mengering serta rontok.

**PENYEBAB**
Penyebabnya adalah jamur Alternaria solani yang berkembang pesat pada kondisi lembap dan hangat dengan suhu 20-30°C, kelembapan tinggi, curah hujan yang sering, serta sirkulasi udara yang buruk di sekitar tanaman.

**PENANGANAN**
Lakukan rotasi tanaman minimal 3 tahun dengan tanaman bukan inang, pangkas daun yang terinfeksi segera setelah terlihat, gunakan fungisida berbahan aktif chlorothalonil atau mancozeb, dan atur jarak tanam yang cukup untuk sirkulasi udara. Untuk pencegahan, berikan pupuk nitrogen secara seimbang (jangan berlebihan), hindari kekeringan yang membuat tanaman stres, serta kumpulkan dan buang daun yang terinfeksi (jangan dikompos).
""",
        imageAsset: "assets/images/early_blight.JPG",
      ),
      DiseaseInfo(
        title: "Late Blight",
        description: "Daun tampak basah dan cepat menyebar saat lembap.",
        icon: Icons.cloudy_snowing,
        color: Colors.blueGrey,
        materi: """

Late Blight adalah penyakit sangat serius pada tanaman tomat yang disebabkan oleh Phytophthora infestans (sejenis jamur air). Penyakit ini dapat menyebar dengan sangat cepat pada kondisi lembap dan dingin, serta dapat memusnahkan seluruh tanaman dalam waktu singkat.

**GEJALA**
Gejalanya berupa bercak basah berwarna hijau gelap hingga hitam pada daun. Tepi bercak tampak seperti berjamur putih, terutama saat pagi hari. Penyakit ini menyebar sangat cepat dalam kondisi lembap (hanya dalam hitungan hari) dan menyebabkan kebusukan total pada batang, daun, dan buah.

**PENYEBAB**
Penyebabnya adalah oomycete (jamur air) Phytophthora infestans yang berkembang pada kondisi dingin dan lembap dengan suhu 10-25°C, kelembapan relatif di atas 90% dalam waktu lama, serta spora yang menyebar melalui udara dan percikan air.

**PENANGANAN**
Gunakan varietas tomat yang tahan terhadap Late Blight, hindari penanaman terlalu rapat, aplikasikan fungisida sistemik seperti metalaxyl atau mancozeb, serta lakukan sanitasi lahan dengan membakar sisa tanaman sakit. Untuk pencegahan, pantau prakiraan cuaca untuk periode lembap yang berkepanjangan, aplikasikan fungisida preventif saat kondisi cuaca mendukung, hindari irigasi overhead (dari atas), dan segera cabut serta musnahkan tanaman yang terinfeksi.
""",
        imageAsset: "assets/images/Late_blight.jpg",
      ),
      DiseaseInfo(
        title: "Leaf Mold",
        description: "Jamur menyebabkan warna kuning & bercak beludru.",
        icon: Icons.eco,
        color: Color(0xFFB4B23D),
        materi: """

Leaf Mold adalah penyakit jamur pada tanaman tomat yang disebabkan oleh Cladosporium fulvum. Penyakit ini umumnya muncul pada kondisi lembap dengan sirkulasi udara buruk, terutama di dalam rumah kaca atau greenhouse.

**GEJALA**
Gejalanya berupa bercak kuning tidak beraturan di permukaan atas daun, serta lapisan beludru berwarna hijau zaitun hingga keabu-abuan di bawah daun. Daun akan mengering, menggulung, dan rontok, sedangkan pertumbuhan tanaman terhambat dan produksi buah menurun.

**PENYEBAB**
Penyebabnya adalah jamur Cladosporium fulvum yang berkembang pada kelembapan tinggi (di atas 85%) dan suhu sedang (22-24°C), sirkulasi udara yang buruk, serta tanaman terlalu rapat sehingga daun saling menutupi.

**PENANGANAN**
Kontrol kelembapan dalam rumah kaca (jaga di bawah 85%), pastikan ventilasi udara berjalan baik, aplikasikan fungisida berbahan sulfur atau copper-based, serta hindari penyiraman berlebihan terutama sore hari. Untuk pencegahan, atur jarak tanam yang memadai, pangkas daun bagian bawah untuk meningkatkan sirkulasi udara, hindari suhu malam yang terlalu dingin, dan gunakan mulsa reflektif untuk mengurangi kelembapan.
""",
        imageAsset: "assets/images/Leaf_Mold.JPG",
      ),
      DiseaseInfo(
        title: "Septoria Leaf Spot",
        description: "Banyak titik kecil coklat di daun bawah.",
        icon: Icons.circle_outlined,
        color: Colors.brown,
        materi: """

Septoria Leaf Spot adalah penyakit jamur pada tanaman tomat yang disebabkan oleh Septoria lycopersici. Penyakit ini biasanya menyerang daun bagian bawah terlebih dahulu dan dapat menyebabkan kerontokan daun secara prematur.

**GEJALA**
Gejalanya ditandai dengan bercak kecil bulat berwarna coklat pada daun tua. Pusat bercak berwarna pucat dengan titik-titik hitam (disebut pycnidia). Daun menguning secara progresif dari bawah ke atas dan rontok secara prematur, membuat buah terbakar sinar matahari.

**PENYEBAB**
Penyebabnya adalah jamur Septoria lycopersici yang menyebar melalui percikan air dari tanah yang membawa spora jamur, dengan suhu optimal untuk perkembangan 15-27°C dan kelembapan tinggi dalam waktu lama.

**PENANGANAN**
Gunakan mulsa untuk mencegah percikan air dari tanah, lakukan rotasi tanaman 2-3 tahun dengan tanaman bukan inang, aplikasikan fungisida berbahan chlorothalonil atau maneb, serta pangkas daun yang terinfeksi segera setelah terlihat. Untuk pencegahan, hindari irigasi overhead (dari atas), buang dan musnahkan sisa tanaman sakit setelah panen, serta gunakan varietas tomat yang lebih toleran jika tersedia.
""",
        imageAsset: "assets/images/Septoria_leaf_spot.JPG",
      ),
      DiseaseInfo(
        title: "Spider Mites",
        description: "Bercak kuning dan putih seperti pasir.",
        icon: Icons.pest_control,
        color: Colors.purple,
        materi: """

Spider Mites (Tungau laba-laba, khususnya Two-spotted Spider Mite) adalah hama tungau kecil dari keluarga Tetranychidae. Hama ini biasanya muncul pada kondisi panas dan kering serta dapat menyebabkan kerusakan serius pada daun tanaman tomat.

**GEJALA**
Gejalanya berupa bintik-bintik kuning atau putih seperti pasir pada permukaan daun, serta jaring-jaring halus seperti sarang laba-laba di bawah daun atau antar daun. Daun akan mengering, menguning, dan akhirnya keriting, sedangkan pertumbuhan tanaman terhambat dan hasil panen menurun.

**PENYEBAB**
Penyebabnya adalah tungau Tetranychus urticae yang berkembang pesat pada kondisi panas (di atas 30°C) dan udara kering. Populasi meledak di musim kemarau yang panjang, serta kurangnya predator alami akibat penggunaan insektisida berlebihan.

**PENANGANAN**
Semprot air secara teratur ke daun untuk meningkatkan kelembapan, gunakan predator alami seperti Phytoseiulus persimilis (tungau predator), aplikasikan akarisida seperti abamectin atau spiromesifen, serta gunakan minyak nimba atau sabun insektisida sebagai alternatif. Untuk pencegahan, lakukan monitoring rutin dengan kaca pembesar (periksa bawah daun), hindari pemupukan nitrogen berlebihan, jaga kelembapan yang memadai di sekitar tanaman, dan tanam tanaman perangkap seperti jagung atau bunga marigold.
""",
        imageAsset: "assets/images/spider_mites.JPG",
      ),
      DiseaseInfo(
        title: "Target Spot",
        description: "Bercak seperti sasaran tembak dengan lingkaran.",
        icon: Icons.my_location,
        color: Colors.deepOrange,
        materi: """

Target Spot adalah penyakit jamur pada tanaman tomat yang disebabkan oleh Corynespora cassiicola. Penyakit ini ditandai dengan bercak khas berbentuk lingkaran konsentris seperti sasaran tembak.

**GEJALA**
Gejalanya berupa bercak bulat dengan pola lingkaran konsentris seperti sasaran, di mana pusat bercak berwarna coklat dengan tepi berwarna kuning. Penyakit ini dapat menyerang daun, batang, dan buah, serta menyebabkan daun rontok secara prematur saat infeksi sudah berat.

**PENYEBAB**
Penyebabnya adalah jamur Corynespora cassiicola yang berkembang pada suhu hangat antara 20-30°C dengan kelembapan tinggi. Spora menyebar melalui udara dan percikan air, dan tanaman yang terlalu rapat akan mempercepat penyebaran.

**PENANGANAN**
Aplikasikan fungisida seperti azoxystrobin atau pyraclostrobin, lakukan rotasi tanaman dengan tanaman non-inang, serta sanitasi dengan membuang dan memusnahkan sisa tanaman sakit. Untuk pencegahan, hindari kondisi yang terlalu lembap dengan ventilasi baik, lakukan pemangkasan untuk meningkatkan sirkulasi udara, lakukan monitoring rutin untuk mendeteksi gejala awal, serta hindari irigasi overhead.
""",
        imageAsset: "assets/images/Target_Spot.JPG",
      ),
      DiseaseInfo(
        title: "Tomato Yellow Leaf Curl Virus",
        description: "Daun keriting dan menguning, pertumbuhan terhambat.",
        icon: Icons.coronavirus,
        color: Colors.yellow.shade700,
        materi: """

Tomato Yellow Leaf Curl Virus (TYLCV) adalah penyakit virus pada tanaman tomat yang ditularkan oleh kutu kebul (Bemisia tabaci). Penyakit ini sangat merugikan karena dapat menghambat pertumbuhan dan produksi buah secara drastis.

**GEJALA**
Gejalanya berupa daun menguning di bagian tepi dan menggulung ke atas, pertumbuhan tanaman menjadi kerdil (stunting), ruas antar daun memendek sehingga tanaman tampak rimbun tapi kecil, serta produksi bunga dan buah menurun drastis (buah yang terbentuk pun kecil).

**PENYEBAB**
Penyebabnya adalah virus TYLCV yang ditularkan oleh vektor kutu kebul (Bemisia tabaci). Virus tidak menular melalui sentuhan atau biji, hanya melalui serangga vektor. Gulma di sekitar kebun dapat menjadi sumber inang virus.

**PENANGANAN**
Kontrol populasi kutu kebul dengan insektisida yang tepat, gunakan varietas tomat yang tahan terhadap TYLCV, cabut dan hancurkan (bakar) tanaman yang terinfeksi, serta gunakan screen house atau jaring serangga untuk melindungi tanaman. Untuk pencegahan, gunakan bibit yang bebas virus dari sumber terpercaya, kontrol gulma di sekitar kebun yang bisa menjadi inang alternatif, lakukan rotasi tanaman dengan tanaman non-inang seperti padi atau jagung, serta tanam perangkap seperti bunga matahari untuk mengalihkan kutu kebul.
""",
        imageAsset: "assets/images/Tomato_Yellow_Leaf_Curl_Virus.jpg",
      ),
      DiseaseInfo(
        title: "Tomato Mosaic Virus",
        description: "Pola mosaik kuning-hijau pada daun.",
        icon: Icons.grain,
        color: Colors.amber,
        materi: """

Tomato Mosaic Virus (ToMV) adalah penyakit virus yang umum dan sangat mudah menular pada tanaman tomat. Virus ini sangat stabil dan dapat bertahan lama di lingkungan, alat pertanian, serta biji.

**GEJALA**
Gejalanya berupa pola mosaik (bercak-bercak) hijau muda dan hijau tua pada daun, daun keriting, menyempit, dan mengalami deformasi bentuk, pertumbuhan tanaman terhambat (kerdil), serta buah menunjukkan gejala mosaik, ukuran kecil, dan kualitas menurun.

**PENYEBAB**
Penyebabnya adalah Tomato Mosaic Virus (ToMV) yang menular melalui kontak langsung antar tanaman, melalui biji yang terinfeksi, melalui alat pertanian (gunting, pisau, tangan) yang terkontaminasi. Virus tembakau pada rokok juga dapat menulari tomat.

**PENANGANAN**
Gunakan benih bersertifikat yang bebas virus, sterilkan alat pertanian dengan larutan desinfektan (pemutih 10% atau susu skim), hindari merokok di sekitar tanaman (virus tahan pada tembakau/rokok), serta cabut dan musnahkan tanaman sakit segera. Untuk pencegahan, cuci tangan dengan sabun sebelum menangani tanaman, lakukan rotasi tanaman yang cukup lama (minimal 2 tahun), hindari menanam tomat dekat dengan tanaman yang terinfeksi, serta gunakan varietas tahan virus jika tersedia.
""",
        imageAsset: "assets/images/Tomato_mosaic_virus.JPG",
      ),
      DiseaseInfo(
        title: "Powdery Mildew",
        description: "Lapisan putih seperti tepung pada daun.",
        icon: Icons.ac_unit,
        color: Colors.blue.shade300,
        materi: """

Powdery Mildew (Embun Tepung) adalah penyakit jamur pada tanaman tomat yang menyerang permukaan daun. Penyakit ini berbeda dengan kebanyakan jamur karena tidak membutuhkan air bebas untuk berkembang, justru menyukai kelembapan sedang.

**GEJALA**
Gejalanya berupa lapisan tepung putih seperti bedak pada permukaan atas dan bawah daun. Daun akan menguning di bawah lapisan jamur, pertumbuhan tanaman terhambat, dan pada kasus berat daun akan mengering, mengkerut, serta rontok.

**PENYEBAB**
Penyebabnya adalah jamur Oidium lycopersici yang berkembang pada kondisi kelembapan sedang (50-70%) dengan sirkulasi udara buruk, suhu optimal antara 20-27°C, serta tanaman yang terlalu rapat dan kurang sinar matahari langsung.

**PENANGANAN**
Aplikasikan fungisida berbahan sulfur atau potassium bicarbonate, gunakan minyak nimba atau minyak hortikultura (hindari saat panas terik), gunakan biofungisida seperti Ampelomyces quisqualis (jamur predator), serta semprot dengan larutan baking soda (1 sdm/liter air) sebagai alternatif alami. Untuk pencegahan, pastikan sirkulasi udara yang baik dengan jarak tanam cukup, hindari penanaman terlalu rapat, pangkas daun yang terinfeksi sejak awal, serta jangan memupuk nitrogen berlebihan karena akan membuat daun terlalu lembut.
""",
        imageAsset: "assets/images/powdery_mildew.jpg",
      ),
      DiseaseInfo(
        title: "Daun Sehat",
        description: "Daun normal tanpa gejala penyakit.",
        icon: Icons.health_and_safety,
        color: Colors.green,
        materi: """

Daun sehat adalah indikator utama tanaman tomat yang tumbuh optimal. Daun yang sehat menunjukkan bahwa tanaman mendapatkan nutrisi cukup, air yang sesuai, dan bebas dari serangan hama maupun penyakit.

**GEJALA** (Ciri-ciri)
Daun sehat memiliki warna hijau merata dan cerah (tidak pucat atau keunguan), tekstur daun halus, lentur, dan tidak mudah robek, bentuk daun simetris sesuai varietas (tidak keriting atau cacat), serta pertumbuhan seragam dan tanaman tampak vigor (bersemangat). Tidak ada bercak, lubang, atau perubahan warna abnormal pada daun; batang kokoh, tegak, dan berwarna hijau keunguan (normal); akar putih bersih dan berkembang dengan baik; serta produksi bunga melimpah dan buah terbentuk normal.

**PENYEBAB** (Faktor pendukung kesehatan)
Tanaman sehat dapat tercapai dengan pemupukan berimbang sesuai fase pertumbuhan (N, P, K, dan mikro), penyiraman teratur dan konsisten (tidak terlalu basah atau terlalu kering), pengendalian hama secara preventif (bukan hanya setelah ada serangan), serta pemantauan kesehatan tanaman setiap minggu secara rutin.

**PENANGANAN** (Perawatan)
Lakukan inspeksi visual setiap 2-3 hari sekali, catat setiap perubahan yang tidak normal (buku harian tanaman), segera tindak lanjuti jika menemukan gejala awal penyakit, jaga kebersihan kebun dari gulma dan sisa tanaman sakit, serta lakukan rotasi tanaman setiap musim tanam untuk memutus siklus penyakit.
""",
        imageAsset: "assets/images/healthy.jpg",
      ),
    ];
  }
}