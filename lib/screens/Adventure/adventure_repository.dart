import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weekenddoit/models/adventre.dart';

class AdventureRepository {
  final _col = FirebaseFirestore.instance.collection('adventures');

  // 🔥 Upload dummy activities
  Future<void> seedDummyActivities(
    List<Activity> items, {
    void Function(int done, int total)? onProgress,
  }) async {
    int i = 0;
    for (final a in items) {
      await _col.doc(a.id).set(a.toMap(), SetOptions(merge: true));
      i++;
      onProgress?.call(i, items.length);
    }
  }

  // 🔥 Stream all adventures
  Stream<List<Activity>> streamActivities() {
    return _col.snapshots().map(
          (s) => s.docs
              .map((d) =>
                  Activity.fromMap(d.id, d.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}
