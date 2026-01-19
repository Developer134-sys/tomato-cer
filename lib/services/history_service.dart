import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/history_item.dart';

class HistoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Upload image to Supabase Storage
  Future<String> uploadImageToStorage(File imageFile) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final fileName = "${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final storageResponse = await _supabase.storage
        .from("history-images")
        .upload(fileName, imageFile);

    if (storageResponse.isEmpty) {
      throw Exception("Upload failed");
    }

    final publicUrl =
        _supabase.storage.from("history-images").getPublicUrl(fileName);
    return publicUrl;
  }

  /// Save history record to database
  Future<void> saveHistory({
    required String imageUrl,
    required String label,
    required double accuracy,
    required String severity,
    required String recommendation,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _supabase.from("history").insert({
      "user_id": user.id,
      "image_url": imageUrl,
      "label": label,
      "accuracy": accuracy,
      "severity": severity,
      "recommendation": recommendation,
    });
  }

  /// Fetch history list
  Future<List<HistoryItem>> fetchHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final response = await _supabase
        .from('history')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => HistoryItem.fromJson(item))
        .toList();
  }
}
