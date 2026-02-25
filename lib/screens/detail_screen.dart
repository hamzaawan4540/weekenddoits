import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weekenddoit/auth/phone_auth_page.dart';
import '../models/tour_package.dart';

class DetailScreen extends StatefulWidget {
  final TourPackage tour;
  const DetailScreen({super.key, required this.tour});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final tour = widget.tour;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          tour.title,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                tour.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              tour.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.teal),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    tour.location,
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer, size: 18, color: Colors.teal),
                const SizedBox(width: 6),
                Text(
                  tour.duration,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _sectionTitle("Description"),
            Text(tour.description, style: GoogleFonts.poppins(fontSize: 14)),
            const SizedBox(height: 24),
            _sectionTitle("Highlights"),
            const SizedBox(height: 8),
            ...tour.highlights.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 18, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item, style: GoogleFonts.poppins())),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            _sectionTitle("Itinerary"),
            const SizedBox(height: 12),
            ...tour.itinerary.asMap().entries.map((entry) {
              final index = entry.key;
              final plan = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade100,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade900,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        plan,
                        style: GoogleFonts.poppins(fontSize: 14.5, height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A896),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _onBookNowPressed,
            child: const Text(
              'Book Now',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onBookNowPressed() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Navigate to dedicated login page; wait for result
      final success = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const PhoneAuthPage()),
      );
      if (success == true && mounted) {
        _openBookingSheet(context, widget.tour); // open form after login
      }
    } else {
      _openBookingSheet(context, widget.tour);
    }
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
      );

  void _openBookingSheet(BuildContext context, TourPackage tour) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _BookingSheet(tour: tour),
    );
  }
}

class _BookingSheet extends StatefulWidget {
  final TourPackage tour;
  const _BookingSheet({required this.tour});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _adults = TextEditingController(text: '2');
  final _children = TextEditingController(text: '0');

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final u = FirebaseAuth.instance.currentUser;
    final phone = u?.phoneNumber;
    if (phone != null && phone.isNotEmpty) {
      _phone.text = phone;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _adults.dispose();
    _children.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text('Booking Details',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: _input('Client name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: _input('Phone number'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter phone number';
                final digits = v.replaceAll(RegExp(r'\D'), '');
                if (digits.length < 7) return 'Phone looks too short';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              minLines: 2,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              decoration: _input('Address'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter address' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _adults,
                    keyboardType: TextInputType.number,
                    decoration: _input('Adults'),
                    validator: _validateCount,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _children,
                    keyboardType: TextInputType.number,
                    decoration: _input('Children'),
                    validator: _validateCount,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _submitting ? 'Submitting...' : 'Confirm Booking',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF00A896),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  InputDecoration _input(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.teal.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  String? _validateCount(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = int.tryParse(v);
    if (n == null || n < 0) return 'Enter a valid number';
    if (n > 20) return 'Too many';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      final adults = int.parse(_adults.text.trim());
      final children = int.parse(_children.text.trim());
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login again.')),
        );
        Navigator.of(context).pop();
        return;
      }

      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': uid,
        'name': _name.text.trim(),
        'phone': _phone.text.trim(),
        'address': _address.text.trim(),
        'adults': adults,
        'children': children,
        'tourId': widget.tour.id,
        'tourTitle': widget.tour.title,
        'tourLocation': widget.tour.location,
        'tourDuration': widget.tour.duration,
        'tourImageUrl': widget.tour.imageUrl,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context).pop(); // close sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking submitted!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
