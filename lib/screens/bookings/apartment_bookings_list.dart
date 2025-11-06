import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApartmentBookingsList extends StatelessWidget {
  const ApartmentBookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Login to see your apartment bookings"));
    }

    final stream = FirebaseFirestore.instance
        .collection('apartmentBookings')
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
            child: Text("No apartment bookings",
                style: GoogleFonts.poppins(fontSize: 14)),
          );
        }

        // sort by createdAt locally
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
            final status = (m['status'] ?? 'pending').toString();

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: m['apartmentImage'] != null &&
                        (m['apartmentImage'] as String).isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          m['apartmentImage'],
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Icon(Icons.home_work, color: Colors.teal, size: 36),
                title: Text(
                  m['apartmentTitle'] ?? "Apartment",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Location: ${m['apartmentLocation'] ?? ''}\n"
                  "Months: ${m['months'] ?? 1} | Rent: ₹${m['pricePerMonth'] ?? ''}/mo",
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                trailing: Chip(
                  label: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  backgroundColor: _statusColor(status),
                ),
                onTap: () {
                  _showDetail(context, m);
                },
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(String status) {
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
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text("Apartment Booking Details",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("Apartment: ${m['apartmentTitle']}"),
            Text("Location: ${m['apartmentLocation']}"),
            Text("Rent: ₹${m['pricePerMonth']}/month"),
            Text("Months: ${m['months']}"),
            if (m['moveInDate'] is Timestamp)
              Text("Move-in: ${(m['moveInDate'] as Timestamp).toDate()}"),
            const SizedBox(height: 12),
            Text("Name: ${m['name']}"),
            Text("Phone: ${m['phone']}"),
            const SizedBox(height: 12),
            Text("Status: ${m['status']}"),
          ],
        ),
      ),
    );
  }
}
