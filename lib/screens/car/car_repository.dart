import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/car.dart';
import 'package:flutter/foundation.dart';

typedef Progress = void Function(int done, int total);

class CarRepository {
  final _cars = FirebaseFirestore.instance.collection('cars');

  /// Seed cars to Firestore (URL-only, no Storage). Adds/updates by slug id.
  Future<void> seedDummyCars(List<Car> cars, {Progress? onProgress}) async {
    int i = 0;
    for (final car in cars) {
      try {
        // create a doc id slug from name
        final id =
            car.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

        // Write URL-only data (no Storage)
        await _cars.doc(id).set({
          'name': car.name,
          'imageUrl': car.imageUrl,
          'pricePerDay': car.pricePerDay,
          // optional: locations that offer this car (so you can filter)
          'locations':
              car.locations ?? ['New York', 'Los Angeles', 'Miami', 'Chicago'],
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        i++;
        onProgress?.call(i, cars.length);
        debugPrint('✅ Seeded car: ${car.name}');
      } catch (e, st) {
        debugPrint('❌ Failed to seed ${car.name}: $e');
        debugPrintStack(stackTrace: st);
        rethrow;
      }
    }
  }

  /// Stream cars; if [location] provided, filter by array-contains.
  Stream<List<Car>> streamCars({String? location}) {
    Query<Map<String, dynamic>> q =
        FirebaseFirestore.instance.collection('cars');
    if (location != null && location.isNotEmpty) {
      q = q.where('locations', arrayContains: location); // 🔥 no orderBy
    }
    return q.snapshots().map((snap) {
      final list =
          snap.docs.map((d) => Car.fromMap(d.data(), id: d.id)).toList();
      // client-side sort (no index required)
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return list;
    });
  }
}
