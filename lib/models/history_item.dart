class HistoryItem {
  final String id;
  final String imageUrl;
  final String label;
  final double accuracy;
  final String severity;
  final String recommendation;
  final DateTime createdAt;

  HistoryItem({
    required this.id,
    required this.imageUrl,
    required this.label,
    required this.accuracy,
    required this.severity,
    required this.recommendation,
    required this.createdAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      imageUrl: json['image_url'],
      label: json['label'],
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      severity: json['severity'],
      recommendation: json['recommendation'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
