import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TourBookingsList extends StatelessWidget {
  const TourBookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Login to see your tour bookings"));
    }

    final stream = FirebaseFirestore.instance
        .collection('bookings') // mixed collection
        .where('userId', isEqualTo: uid)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text("Error: ${snap.error}"));
        }

        // keep only TOUR docs (heuristic)
        final docs = (snap.data?.docs ?? []).where((d) {
          final m = d.data() as Map<String, dynamic>;
          // prefer a definitive field if present:
          // return m['type'] == 'tour';
          return m['tourId'] != null || m['tourTitle'] != null;
        }).toList();

        if (docs.isEmpty) {
          return Center(
            child: Text("No tour bookings",
                style: GoogleFonts.poppins(fontSize: 14)),
          );
        }

        // sort locally by createdAt desc (no Firestore index needed)
        docs.sort((a, b) {
          final da = (a['createdAt'] as Timestamp?)?.toDate();
          final db = (b['createdAt'] as Timestamp?)?.toDate();
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return db.compareTo(da);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final m = docs[i].data() as Map<String, dynamic>;
            final img = (m['tourImageUrl'] ?? '') as String;
            final title = (m['tourTitle'] ?? "Tour") as String;
            final location = (m['tourLocation'] ?? "") as String;
            final status = (m['status'] ?? 'pending').toString();

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: img.isNotEmpty
                      ? Image.network(
                          img,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.tour),
                ),
                title: Text(title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                subtitle:
                    Text(location, style: GoogleFonts.poppins(fontSize: 13)),
                trailing: Chip(
                  label: Text(status.toUpperCase(),
                      style: const TextStyle(color: Colors.white)),
                  backgroundColor: _statusColor(status),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
