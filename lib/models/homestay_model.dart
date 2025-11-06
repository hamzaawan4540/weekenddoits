class HomestayModel {
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final double pricePerNight;
  final double rating;

  HomestayModel({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.pricePerNight,
    required this.rating,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'location': location,
        'imageUrl': imageUrl,
        'pricePerNight': pricePerNight,
        'rating': rating,
      };

  static HomestayModel fromMap(String id, Map<String, dynamic> m) {
    return HomestayModel(
      id: id,
      title: (m['title'] ?? '').toString(),
      location: (m['location'] ?? '').toString(),
      imageUrl: (m['imageUrl'] ?? '').toString(),
      pricePerNight: (m['pricePerNight'] ?? 0).toDouble(),
      rating: (m['rating'] ?? 0).toDouble(),
    );
  }
}
