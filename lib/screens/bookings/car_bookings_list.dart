import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarBookingsList extends StatelessWidget {
  const CarBookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Login to see your car bookings"));
    }

    final stream = FirebaseFirestore.instance
        .collection('car_bookings')
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
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Text("No car bookings",
                style: GoogleFonts.poppins(fontSize: 14)),
          );
        }

        // 🔥 Sort locally by createdAt descending
        docs.sort((a, b) {
          final da = (a['createdAt'] as Timestamp?)?.toDate();
          final db = (b['createdAt'] as Timestamp?)?.toDate();
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return db.compareTo(da); // newest first
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final m = docs[i].data() as Map<String, dynamic>;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: m['carImageUrl'] != null && m['carImageUrl'] != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          m['carImageUrl'],
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Icon(Icons.car_rental,
                        size: 40, color: Colors.teal),
                title: Text(
                  m['carName'] ?? "Car",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "${m['from'] ?? ''} → ${m['to'] ?? ''}",
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                trailing: Chip(
                  label: Text(
                    (m['status'] ?? 'pending').toString().toUpperCase(),
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
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
        return Colors.orange;
    }
  }
}
