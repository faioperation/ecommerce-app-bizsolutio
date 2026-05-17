import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String iconEmoji; // Emojis representing the items as requested
  final Color backgroundColor;
  final Color textColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconEmoji,
    required this.backgroundColor,
    required this.textColor,
  });

  // Ideal for API Integration
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      iconEmoji: json['iconEmoji'] ?? '📦',
      backgroundColor: Color(int.parse(json['backgroundColor'] ?? '0xFFF3F4F6')),
      textColor: Color(int.parse(json['textColor'] ?? '0xFF1F2937')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconEmoji': iconEmoji,
      'backgroundColor': '0x${backgroundColor.value.toRadixString(16).toUpperCase()}',
      'textColor': '0x${textColor.value.toRadixString(16).toUpperCase()}',
    };
  }
}
