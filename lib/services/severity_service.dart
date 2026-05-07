class SeverityService {
  static String getSeverity(String label) {
    // normalisasi biar aman
    label = label.toLowerCase().replaceAll("tomato___", "").trim();

    switch (label) {
      case "bacterial_spot":
      case "early_blight":
      case "spider_mites two-spotted_spider_mite":
      case "target_spot":
      case "tomato_mosaic_virus":
        return "Peringatan Sedang";

      case "late_blight":
      case "tomato_yellow_leaf_curl_virus":
        return "Peringatan Tinggi";

      case "leaf_mold":
      case "septoria_leaf_spot":
      case "powdery_mildew":
        return "Peringatan Rendah";

      case "healthy":
        return "Aman";

      default:
        return "Tidak diketahui";
    }
  }
}