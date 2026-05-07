import '../services/recommendation_service.dart';
class HistoryItem {
  final String id;
  final String imageUrl;
  final String label;
  final String diseaseName;
  final double accuracy;
  final String severity;
  final String recommendation;
  final String description;
  final DateTime createdAt;

  HistoryItem({
    required this.id,
    required this.imageUrl,
    required this.label,
    required this.diseaseName,
    required this.accuracy,
    required this.severity,
    required this.recommendation,
    required this.description,
    required this.createdAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      label: json['label']?.toString() ?? 'Tidak diketahui',
       diseaseName: json['disease_name'] ?? RecommendationService.getDiseaseName(json['label'] ?? ''),
      accuracy: (json['accuracy'] is num)
          ? (json['accuracy'] as num).toDouble()
          : 0.0,
      severity: json['severity']?.toString() ?? '-',
      recommendation: json['recommendation']?.toString() ?? '-',
      description: json['description']?.toString() ?? '-', // 🔥 FIX UTAMA
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '')
          ?? DateTime.now(),
    );
  }
}