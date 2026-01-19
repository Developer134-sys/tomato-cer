class SeverityService {
  static String getSeverity(String label) {
    switch (label) {
      case "Bacterial_spot":
        return "Sedang";

      case "Early_blight":
        return "Sedang";

      case "Late_blight":
        return "Berat"; // Paling berbahaya pada tomat

      case "Leaf_Mold":
        return "Ringan"; // Biasanya tidak mematikan

      case "Septoria_leaf_spot":
        return "Ringan"; // bercak kecil-kecil

      case "Spider_mites Two-spotted_spider_mite":
        return "Sedang"; // serangan bisa menyebar cepat

      case "Target_Spot":
        return "Sedang"; // bercak besar, tapi tidak mematikan

      case "Tomato_Yellow_Leaf_Curl_Virus":
        return "Berat"; // virus hanya bisa dikendalikan, tidak bisa disembuhkan

      case "Tomato_mosaic_virus":
        return "Sedang";

      case "powdery_mildew":
        return "Ringan"; // jamur, umumnya ringan–sedang

      case "healthy":
      case "Healthy":
        return "Tidak ada serangan";

      default:
        return "Tidak diketahui";
    }
  }
}
