// lib/screens/Hotel/hotel_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/hotels.dart';

class HotelRepository {
  final _col = FirebaseFirestore.instance.collection('hotels');

  /// Upload dummyHotels → Firestore (URL only)
  Future<void> seedDummyHotels(List<Hotel> hotels,
      {required void Function(int, int) onProgress}) async {
    for (int i = 0; i < hotels.length; i++) {
      final h = hotels[i];
      await _col.add({
        'name': h.name,
        'imageUrls': h.imageUrls, // 👈 keep URL list
        'pricePerNight': h.pricePerNight,
        'starRating': h.starRating,
        'reviewsCount': h.reviewsCount,
        'amenities': h.amenities,
        'rooms': h.rooms
            .map((r) => {'name': r.name, 'pricePerNight': r.pricePerNight})
            .toList(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      onProgress(i + 1, hotels.length);
    }
  }

  /// Stream all hotels
  Stream<List<Hotel>> streamHotels() {
    return _col.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((doc) {
            final m = doc.data();
            return Hotel(
              name: m['name'] ?? '',
              imageUrls: List<String>.from(m['imageUrls'] ?? []),
              pricePerNight: (m['pricePerNight'] ?? 0).toDouble(),
              starRating: (m['starRating'] ?? 0).toDouble(),
              reviewsCount: m['reviewsCount'] ?? 0,
              amenities: List<String>.from(m['amenities'] ?? []),
              rooms: (m['rooms'] as List<dynamic>? ?? [])
                  .map((r) => RoomType(
                        name: r['name'] ?? '',
                        pricePerNight: (r['pricePerNight'] ?? 0).toDouble(),
                      ))
                  .toList(),
            );
          }).toList(),
        );
  }
}
