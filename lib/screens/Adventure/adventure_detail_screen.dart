import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weekenddoit/models/adventre.dart';
import 'package:weekenddoit/screens/Adventure/adventure_booking_screen.dart';

class AdventureDetailScreen extends StatelessWidget {
  final Activity activity;
  const AdventureDetailScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text(
          activity.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF00A896),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(activity.imageUrl,
                height: 220, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(activity.title,
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Duration: ${activity.duration}",
              style: GoogleFonts.poppins(color: Colors.grey[700])),
          Text("₹${activity.price}",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal)),
          const SizedBox(height: 20),
          Text("About",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(activity.description,
              style: GoogleFonts.poppins(fontSize: 14, height: 1.5)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.directions_run),
            label: const Text("Book This Adventure"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A896),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AdventureBookingScreen(activity: activity)),
              );
            },
          )
        ],
      ),
    );
  }
}
