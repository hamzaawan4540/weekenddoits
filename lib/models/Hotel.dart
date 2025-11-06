// lib/models/Hotel.dart
class HotelModel {
  final String name;
  final String imageUrl;
  final double pricePerNight;
  final String location;
  final double starRating;

  const HotelModel({
    required this.name,
    required this.imageUrl,
    required this.pricePerNight,
    required this.location,
    required this.starRating,
  });
}
