import 'package:flutter/material.dart';

class DiseaseInfo {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String materi;
  final String imageAsset;

  DiseaseInfo({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.materi,
    required this.imageAsset,
  });
}
