import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/homestay_model.dart';

class HomestayRepository {
  final _col = FirebaseFirestore.instance.collection('homestays');

  // Seed with URL images only (no Storage upload)
  Future<void> seedDummyHomestays(
    List<HomestayModel> items, {
    void Function(int done, int total)? onProgress,
  }) async {
    int i = 0;
    for (final h in items) {
      // Use id as docId so repeated seeding overwrites
      await _col.doc(h.id).set(h.toMap(), SetOptions(merge: true));
      i++;
      onProgress?.call(i, items.length);
    }
  }

  // Stream all (optionally filter by location exact match)
  Stream<List<HomestayModel>> streamHomestays({String? location}) {
    Query<Map<String, dynamic>> q = _col;
    if (location != null && location.trim().isNotEmpty) {
      q = q.where('location', isEqualTo: location.trim());
    }
    return q.snapshots().map((snap) {
      return snap.docs
          .map((d) =>
              HomestayModel.fromMap(d.id, d.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
