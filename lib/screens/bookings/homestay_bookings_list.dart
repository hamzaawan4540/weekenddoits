import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomestayBookingsList extends StatelessWidget {
  const HomestayBookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Login to see your homestay bookings"));
    }

    // No orderBy -> no composite index required. We'll sort locally.
    final stream = FirebaseFirestore.instance
        .collection('homestayBookings')
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

        // Sort locally by createdAt desc (newest first)
        docs.sort((a, b) {
          final da =
              (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
          final db =
              (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
          final ad = da?.toDate();
          final bd = db?.toDate();
          if (ad == null && bd == null) return 0;
          if (ad == null) return 1;
          if (bd == null) return -1;
          return bd.compareTo(ad);
        });

        if (docs.isEmpty) {
          return Center(
            child: Text("No homestay bookings",
                style: GoogleFonts.poppins(fontSize: 14)),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final m = docs[i].data() as Map<String, dynamic>;

            final title = (m['homestayTitle'] ?? 'Homestay') as String;
            final location = (m['homestayLocation'] ?? '') as String;
            final imageUrl = (m['homestayImageUrl'] ?? '') as String;
            final status = (m['status'] ?? 'pending').toString();

            // optional extra fields you might save:
            final guests = (m['guests'] ?? m['adults'] ?? 1).toString();
            final nights = (m['nights'] ?? 1).toString();
            final createdAt = (m['createdAt'] as Timestamp?)?.toDate();

            return Material(
              color: Colors.white,
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showDetail(context, m),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 56,
                              height: 56,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.home, color: Colors.grey),
                            ),
                          )
                        : Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.home, color: Colors.grey),
                          ),
                  ),
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (location.isNotEmpty)
                        Text(location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        "Guests: $guests • Nights: $nights"
                        "${createdAt != null ? " • ${_dateShort(createdAt)}" : ""}",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      status.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: _statusColor(status),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDetail(BuildContext context, Map<String, dynamic> m) {
    final createdAt = (m['createdAt'] as Timestamp?)?.toDate();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('Homestay Booking',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _row('Title', m['homestayTitle']),
            _row('Location', m['homestayLocation']),
            _row('Guests', m['guests'] ?? m['adults']),
            _row('Nights', m['nights']),
            _row('Name', m['name']),
            _row('Phone', m['phone']),
            if (m['checkInAt'] is Timestamp)
              _row('Check-in',
                  (m['checkInAt'] as Timestamp).toDate().toString()),
            if (m['checkOutAt'] is Timestamp)
              _row('Check-out',
                  (m['checkOutAt'] as Timestamp).toDate().toString()),
            _row('Status', m['status']),
            if (createdAt != null) _row('Created', createdAt.toString()),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, dynamic value) {
    final v = (value ?? '').toString();
    if (v.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110,
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: Colors.black87))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(v, style: GoogleFonts.poppins(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  static Color _statusColor(String s) {
    switch (s) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.indigo; // pending / others
    }
  }

  static String _dateShort(DateTime d) {
    // dd MMM
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${d.day} ${months[d.month - 1]}';
    // (you can swap to intl if you’re already using it)
  }
}
