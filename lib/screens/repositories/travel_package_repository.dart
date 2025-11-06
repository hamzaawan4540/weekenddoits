import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:weekenddoit/models/tour_package.dart';

class TravelPackageRepository {
  static const String collection = 'tour_packages';
  final _fire = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Stream<List<TourPackage>> streamPackages() {
    return _fire
        .collection(collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => TourPackage.fromMap(d.id, d.data())).toList());
  }

  Future<String> _tryUploadToStorage({
    required String imageUrl,
    required String docId,
  }) async {
    // Download source image
    final res = await http.get(Uri.parse(imageUrl));
    if (res.statusCode != 200) {
      throw Exception('Image download failed: HTTP ${res.statusCode}');
    }
    final Uint8List data = res.bodyBytes;

    // Upload
    final fileName = 'cover_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('packages/$docId/$fileName');
    final task = await ref.putData(
      data,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await task.ref.getDownloadURL();
  }

  Future<void> addFromDummy(TourPackage pkg) async {
    final doc = _fire.collection(collection).doc(); // auto id
    String finalImageUrl = pkg.imageUrl;

    // Try Storage; fallback to original URL if Storage fails
    try {
      finalImageUrl =
          await _tryUploadToStorage(imageUrl: pkg.imageUrl, docId: doc.id);
    } catch (_) {
      // keep original URL
    }

    final payload = {
      'title': pkg.title,
      'location': pkg.location,
      'duration': pkg.duration,
      'imageUrl': finalImageUrl,
      'description': pkg.description,
      'highlights': pkg.highlights,
      'itinerary': pkg.itinerary,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await doc.set(payload);
  }

  Future<void> seedIfEmpty(List<TourPackage> list) async {
    final snap = await _fire.collection(collection).limit(1).get();
    if (snap.docs.isNotEmpty) return; // already seeded

    for (final p in list) {
      try {
        await addFromDummy(p);
      } catch (_) {
        // continue with next item; do not abort batch
      }
    }
  }
}
