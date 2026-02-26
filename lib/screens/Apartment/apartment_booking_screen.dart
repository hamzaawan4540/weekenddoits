import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/apartment.dart';

class ApartmentBookingScreen extends StatefulWidget {
  final Apartment apartment;
  const ApartmentBookingScreen({super.key, required this.apartment});

  @override
  State<ApartmentBookingScreen> createState() => _ApartmentBookingScreenState();
}

class _ApartmentBookingScreenState extends State<ApartmentBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final monthsCtrl = TextEditingController(text: "3");
  DateTime? moveInDate;
  bool isSubmitting = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
    );
    if (picked != null) setState(() => moveInDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || moveInDate == null) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection("apartmentBookings").add({
        "userId": uid,
        "name": nameCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),
        "months": int.tryParse(monthsCtrl.text.trim()) ?? 1,
        "moveInDate": Timestamp.fromDate(moveInDate!),
        "apartmentTitle": widget.apartment.title,
        "apartmentLocation": widget.apartment.location,
        "apartmentImage": widget.apartment.imageUrl,
        "pricePerMonth": widget.apartment.pricePerMonth,
        "status": "pending",
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking Submitted!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Apartment",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE67E22),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Apartment: ${widget.apartment.title}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Your Name",
                  filled: true,
                  fillColor: const Color(0xFF5D78FF).withOpacity(0.05),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneCtrl,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  filled: true,
                  fillColor: const Color(0xFF5D78FF).withOpacity(0.05),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter your phone" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: monthsCtrl,
                decoration: InputDecoration(
                  labelText: "Months (default 3)",
                  filled: true,
                  fillColor: const Color(0xFF5D78FF).withOpacity(0.05),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(moveInDate == null
                    ? "Select Move-in Date"
                    : "${moveInDate!.day}/${moveInDate!.month}/${moveInDate!.year}"),
                trailing:
                    const Icon(Icons.calendar_today, color: Color(0xFF5D78FF)),
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: isSubmitting ? null : _submit,
                icon: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check_circle),
                label: Text(isSubmitting ? "Submitting..." : "Confirm Booking"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D78FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
