import 'package:flutter/material.dart';

class Apartment {
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final List<String> gallery;
  final String description;
  final int pricePerMonth;

  /// Store string keys (e.g. beds/baths/area/parking) -> label
  final Map<String, String> details;

  const Apartment({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.gallery,
    required this.description,
    required this.pricePerMonth,
    required this.details,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'location': location,
        'imageUrl': imageUrl,
        'gallery': gallery,
        'description': description,
        'pricePerMonth': pricePerMonth,
        'details': details,
      };

  factory Apartment.fromMap(String id, Map<String, dynamic> map) => Apartment(
        id: id,
        title: (map['title'] ?? '') as String,
        location: (map['location'] ?? '') as String,
        imageUrl: (map['imageUrl'] ?? '') as String,
        gallery: (map['gallery'] as List?)?.map((e) => e.toString()).toList() ??
            const [],
        description: (map['description'] ?? '') as String,
        pricePerMonth: (map['pricePerMonth'] ?? 0) as int,
        details: Map<String, String>.from(map['details'] ?? {}),
      );
}

/// helper for detail icons
IconData apartmentDetailIcon(String key) {
  switch (key) {
    case 'beds':
      return Icons.bed;
    case 'baths':
      return Icons.bathtub_outlined;
    case 'area':
      return Icons.square_foot;
    case 'parking':
      return Icons.local_parking;
    default:
      return Icons.info_outline;
  }
}
