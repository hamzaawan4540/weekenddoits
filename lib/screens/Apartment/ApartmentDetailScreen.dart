import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:weekenddoit/screens/Apartment/apartment_booking_screen.dart';
import '../../models/apartment.dart';

class ApartmentDetailScreen extends StatelessWidget {
  final Apartment apartment;
  const ApartmentDetailScreen({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: Text(apartment.title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CarouselSlider(
            items: (apartment.gallery.isNotEmpty
                    ? apartment.gallery
                    : [apartment.imageUrl])
                .map((url) => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(url,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                    child: Icon(Icons.broken_image)),
                              )),
                    ))
                .toList(),
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
            ),
          ),
          const SizedBox(height: 20),
          Text(apartment.title,
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.location_on, color: Colors.teal),
            const SizedBox(width: 6),
            Expanded(
              child: Text(apartment.location,
                  style: GoogleFonts.poppins(fontSize: 14)),
            ),
            Text('₹${apartment.pricePerMonth}/mo',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade800)),
          ]),
          const SizedBox(height: 20),

          // details chips with icons inferred from keys
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: apartment.details.entries.map((e) {
              final icon = apartmentDetailIcon(e.key);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.teal, size: 20),
                  const SizedBox(width: 6),
                  Text(e.value, style: GoogleFonts.poppins(fontSize: 13)),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://maps.gstatic.com/tactile/basepage/pegman_sherlock.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Description',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(apartment.description,
              style: GoogleFonts.poppins(fontSize: 14, height: 1.6)),
          const SizedBox(height: 20),
          Text('Amenities',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: const [
              'WiFi',
              'Balcony',
              'Parking',
              'Air Conditioning',
              'Security',
              'Furnished'
            ]
                .map((a) => Chip(
                      label: Text(a),
                      backgroundColor: Colors.tealAccent.withOpacity(0.2),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Text('Policies',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            '✓ Minimum stay: 3 months\n✓ No pets allowed\n✓ ID proof required\n✓ Rent payable on 1st of each month',
            style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.book),
            label: const Text('Book Apartment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ApartmentBookingScreen(apartment: apartment),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Contact Info"),
        content: Text(
          "Phone: +91 98765 43210\nEmail: stay@apartments.com",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(ctx),
          )
        ],
      ),
    );
  }
}
