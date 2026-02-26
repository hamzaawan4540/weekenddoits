import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:weekenddoit/models/hotels.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;
  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          hotel.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE67E22), // Matching theme
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hotel images
          CarouselSlider(
            items: hotel.imageUrls
                .map((url) => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(url,
                          width: double.infinity, fit: BoxFit.cover),
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
          Text(hotel.name,
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Text('${hotel.starRating} (${hotel.reviewsCount} reviews)',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.grey.shade700)),
            ],
          ),
          const SizedBox(height: 16),

          // Overview
          Text('Hotel Overview',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'Located in the heart of the city, this property is perfect for travelers looking for comfort and convenience.',
            style: GoogleFonts.poppins(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 20),

          // Amenities
          Text('Amenities',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: hotel.amenities
                .map((amenity) => Chip(
                      label: Text(amenity,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: const Color(0xFF5D78FF))),
                      backgroundColor: const Color(0xFF5D78FF).withOpacity(0.1),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ))
                .toList(),
          ),

          const SizedBox(height: 20),

          // Rooms
          Text('Room Options',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...hotel.rooms.map((room) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: 6)
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.king_bed, color: Color(0xFF5D78FF)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(room.name,
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      Text('₹${room.pricePerNight.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => _openBookingSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D78FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text(
              'Select Room & Book',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _openBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _HotelBookingSheet(hotel: hotel),
    );
  }
}

class _HotelBookingSheet extends StatefulWidget {
  final Hotel hotel;
  const _HotelBookingSheet({required this.hotel});

  @override
  State<_HotelBookingSheet> createState() => _HotelBookingSheetState();
}

class _HotelBookingSheetState extends State<_HotelBookingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _guests = TextEditingController(text: '2');
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _guests.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please login first.")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('hotelBookings').add({
        'userId': uid,
        'hotelName': widget.hotel.name,
        'hotelImage': widget.hotel.imageUrls.isNotEmpty
            ? widget.hotel.imageUrls.first
            : '',
        'guests': int.tryParse(_guests.text) ?? 2,
        'name': _name.text.trim(),
        'phone': _phone.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hotel booking submitted!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text("Hotel Booking",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                decoration: _input("Your Name"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                decoration: _input("Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.length < 10 ? "Enter valid phone" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _guests,
                decoration: _input("Guests"),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? "Enter guests"
                    : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submitting ? null : _submitBooking,
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(
                    _submitting ? "Submitting..." : "Confirm Booking",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D78FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label) => InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF5D78FF).withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );
}
