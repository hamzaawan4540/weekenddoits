class TourPackage {
  final String id; // Firestore doc id
  final String title;
  final String location;
  final String duration;
  final String imageUrl; // Storage URL or original URL (fallback)
  final String description;
  final List<String> highlights;
  final List<String> itinerary;
  final double price; // Price in currency
  final double rating; // Rating out of 5

  const TourPackage({
    required this.id,
    required this.title,
    required this.location,
    required this.duration,
    required this.imageUrl,
    required this.description,
    required this.highlights,
    required this.itinerary,
    required this.price,
    this.rating = 4.5,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'duration': duration,
      'imageUrl': imageUrl,
      'description': description,
      'highlights': highlights,
      'itinerary': itinerary,
      'price': price,
      'rating': rating,
      'createdAt': DateTime.now().toUtc(),
    };
  }

  factory TourPackage.fromMap(String id, Map<String, dynamic> map) {
    return TourPackage(
      id: id,
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      duration: map['duration'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      highlights: (map['highlights'] as List?)?.cast<String>() ?? const [],
      itinerary: (map['itinerary'] as List?)?.cast<String>() ?? const [],
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
    );
  }
}
