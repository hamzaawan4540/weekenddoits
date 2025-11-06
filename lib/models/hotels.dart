class Hotel {
  final String name;
  final List<String> imageUrls;
  final double pricePerNight;
  final double starRating;
  final int reviewsCount;
  final List<String> amenities;
  final List<RoomType> rooms;

  const Hotel({
    required this.name,
    required this.imageUrls,
    required this.pricePerNight,
    required this.starRating,
    required this.reviewsCount,
    required this.amenities,
    required this.rooms,
  });
}

class RoomType {
  final String name;
  final double pricePerNight;

  const RoomType({
    required this.name,
    required this.pricePerNight,
  });
}
