import 'package:flutter/material.dart';

/// Optional field overrides for [Note.copyWith] (single parameter keeps Sonar S107 happy).
class NotePatch {
  final String? id;
  final String? title;
  final String? body;
  final String? category;
  final String? colorHex;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isPinned;
  final bool? isFavourite;
  final String? imageUrl;

  const NotePatch({
    this.id,
    this.title,
    this.body,
    this.category,
    this.colorHex,
    this.createdAt,
    this.updatedAt,
    this.isPinned,
    this.isFavourite,
    this.imageUrl,
  });
}

class Note {
  String id;
  String title;
  String body;
  String category;      // e.g., "WORK", "URGENT", "MOOD"
  String colorHex;      // e.g., "#FF0000"
  DateTime createdAt;
  DateTime updatedAt;
  bool isPinned;
  bool isFavourite;
  String? imageUrl;     // optional attached image

  // Derived property for UI
  Color get categoryColor {
    final hexCode = colorHex.replaceAll('#', '0xff');
    return Color(int.parse(hexCode));
  }

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.colorHex,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.isFavourite = false,
    this.imageUrl,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String,
      colorHex: json['color_hex'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
      isPinned: json['is_pinned'] as bool? ?? false,
      isFavourite: json['is_favourite'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'title': title,
      'body': body,
      'category': category,
      'color_hex': colorHex,
      'is_pinned': isPinned,
      'is_favourite': isFavourite,
      'image_url': imageUrl,
      // created_at / updated_at handled by Postgres mostly, but can pass
    };
  }

  /// Create Note from Supabase data
  factory Note.fromSupabase(Map<String, dynamic> data) {
    return Note(
      id: data['id'] as String,
      title: data['title'] as String,
      body: data['body'] as String,
      category: data['category'] as String,
      colorHex: data['color_hex'] as String,
      createdAt: DateTime.parse(data['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(data['updated_at'] as String).toLocal(),
      isPinned: data['is_pinned'] as bool? ?? false,
      isFavourite: data['is_favourite'] as bool? ?? false,
      imageUrl: data['image_url'] as String?,
    );
  }

  /// Convert Note to Supabase-compatible map
  Map<String, dynamic> toSupabase() {
    return {
      'title': title,
      'body': body,
      'category': category,
      'color_hex': colorHex,
      'is_pinned': isPinned,
      'is_favourite': isFavourite,
      'image_url': imageUrl,
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  Note copyWith([NotePatch patch = const NotePatch()]) {
    return Note(
      id: patch.id ?? id,
      title: patch.title ?? title,
      body: patch.body ?? body,
      category: patch.category ?? category,
      colorHex: patch.colorHex ?? colorHex,
      createdAt: patch.createdAt ?? createdAt,
      updatedAt: patch.updatedAt ?? updatedAt,
      isPinned: patch.isPinned ?? isPinned,
      isFavourite: patch.isFavourite ?? isFavourite,
      imageUrl: patch.imageUrl ?? imageUrl,
    );
  }
}
