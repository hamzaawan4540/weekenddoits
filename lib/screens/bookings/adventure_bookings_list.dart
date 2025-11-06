import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdventureBookingsList extends StatelessWidget {
  const AdventureBookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Login to see your adventure bookings"));
    }

    final stream = FirebaseFirestore.instance
        .collection('adventureBookings')
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
            child: Text("No adventure bookings",
                style: GoogleFonts.poppins(fontSize: 14)),
          );
        }

        // 🔥 Local sort by createdAt
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
              elevation: 2,
              child: ListTile(
                leading: m['imageUrl'] != null && m['imageUrl'] != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          m['imageUrl'],
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Icon(Icons.directions_run,
                        size: 40, color: Colors.teal),
                title: Text(
                  m['title'] ?? "Adventure",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "${m['duration'] ?? ''} • ₹${m['price'] ?? ''}",
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
                onTap: () => _showDetail(context, m),
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

  void _showDetail(BuildContext context, Map<String, dynamic> m) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text("Adventure Booking",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("Title: ${m['title'] ?? ''}"),
            Text("Duration: ${m['duration'] ?? ''}"),
            Text("Price: ₹${m['price'] ?? ''}"),
            const Divider(height: 20),
            Text("Name: ${m['name'] ?? ''}"),
            Text("Phone: ${m['phone'] ?? ''}"),
            const SizedBox(height: 12),
            Text("Status: ${m['status'] ?? 'pending'}"),
          ],
        ),
      ),
    );
  }
}
