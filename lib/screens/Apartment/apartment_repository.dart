import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/apartment.dart';

class ApartmentRepository {
  final _col = FirebaseFirestore.instance.collection('apartments');

  Future<void> seedDummyApartments(
    List<Apartment> items, {
    void Function(int done, int total)? onProgress,
  }) async {
    int i = 0;
    for (final a in items) {
      await _col.doc(a.id).set(a.toMap(), SetOptions(merge: true));
      i++;
      onProgress?.call(i, items.length);
    }
  }

  Stream<List<Apartment>> streamApartments({String? location}) {
    Query q = _col;
    if (location != null && location.trim().isNotEmpty) {
      q = q.where('location', isEqualTo: location.trim());
    }
    return q.snapshots().map(
          (s) => s.docs
              .map((d) =>
                  Apartment.fromMap(d.id, d.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}
