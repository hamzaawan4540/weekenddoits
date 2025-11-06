import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelBookingsList extends StatelessWidget {
  const HotelBookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Login to see your hotel bookings"));
    }

    final stream = FirebaseFirestore.instance
        .collection('hotelBookings')
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

        final docs = (snap.data?.docs ?? []).toList();

        // 🔥 sort locally by createdAt desc
        docs.sort((a, b) {
          final da = (a['createdAt'] as Timestamp?)?.toDate();
          final db = (b['createdAt'] as Timestamp?)?.toDate();
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return db.compareTo(da);
        });

        if (docs.isEmpty) {
          return Center(
            child: Text("No hotel bookings",
                style: GoogleFonts.poppins(fontSize: 14)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final m = docs[i].data() as Map<String, dynamic>;
            final image = (m['hotelImage'] ?? '') as String;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: image.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Icon(Icons.hotel, size: 40, color: Colors.indigo),
                title: Text(
                  m['hotelName'] ?? "Hotel",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Guests: ${m['guests'] ?? 1}",
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                trailing: Chip(
                  label: Text(
                    (m['status'] ?? 'pending').toString().toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _statusColor(m['status']),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(dynamic status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.indigo;
    }
  }
}
