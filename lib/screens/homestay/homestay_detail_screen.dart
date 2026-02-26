// screens/homestay/homestay_detail_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/homestay_model.dart';
// If you already have a PhoneAuthPage, import it. Otherwise keep login in-sheet later.
// import '../auth/phone_auth_page.dart';

class HomestayDetailScreen extends StatelessWidget {
  final HomestayModel homestay;

  const HomestayDetailScreen({super.key, required this.homestay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          homestay.title,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Simple "carousel"
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: 3,
                itemBuilder: (_, __) => Image.network(
                  homestay.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(homestay.title,
                        style: GoogleFonts.poppins(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(homestay.location, style: GoogleFonts.poppins()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        const SizedBox(width: 6),
                        Text(homestay.rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins()),
                        const SizedBox(width: 12),
                        Text(
                            "₹${homestay.pricePerNight.toStringAsFixed(0)} / night",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text("Description",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(
                      "This is a beautiful homestay with modern amenities, located in a peaceful environment ideal for relaxation.",
                      style: GoogleFonts.poppins(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 18),
                    Text("Amenities",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        _Amenity(icon: FontAwesomeIcons.wifi, label: "WiFi"),
                        _Amenity(icon: FontAwesomeIcons.snowflake, label: "AC"),
                        _Amenity(
                            icon: FontAwesomeIcons.kitchenSet,
                            label: "Kitchen"),
                        _Amenity(icon: FontAwesomeIcons.car, label: "Parking"),
                      ],
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5D78FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            // If you already have a dedicated phone auth page, you can push it instead:
                            // final ok = await Navigator.push<bool>(context,
                            //   MaterialPageRoute(builder: (_) => const PhoneAuthPage()),
                            // );
                            // if (ok == true) _openBookingSheet(context, homestay);

                            _openPhoneLoginSheet(context, onSuccess: () {
                              Navigator.of(context).pop(); // close login sheet
                              _openBookingSheet(context, homestay);
                            });
                          } else {
                            _openBookingSheet(context, homestay);
                          }
                        },
                        child: const Text("Book Now",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  void _openBookingSheet(BuildContext context, HomestayModel h) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _HomestayBookingSheet(h: h),
    );
  }

  void _openPhoneLoginSheet(BuildContext context,
      {required VoidCallback onSuccess}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _PhoneLoginSheet(onSuccess: onSuccess),
    );
  }
}

class _Amenity extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Amenity({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 12, color: const Color(0xFF5D78FF))),
      avatar: FaIcon(icon, size: 14, color: const Color(0xFF5D78FF)),
      backgroundColor: const Color(0xFF5D78FF).withOpacity(0.1),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

/// Phone login mini-sheet (same pattern as tours)
class _PhoneLoginSheet extends StatefulWidget {
  final VoidCallback onSuccess;
  const _PhoneLoginSheet({required this.onSuccess});
  @override
  State<_PhoneLoginSheet> createState() => _PhoneLoginSheetState();
}

class _PhoneLoginSheetState extends State<_PhoneLoginSheet> {
  final _phone = TextEditingController(text: '+91');
  final _otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _verificationId;
  bool _codeSent = false;
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    _otp.dispose();
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
                    borderRadius: BorderRadius.circular(2))),
            Text('Login with Mobile',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              enabled: !_codeSent,
              keyboardType: TextInputType.phone,
              decoration: _dec('Phone (+CC)'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter phone';
                final d = v.replaceAll(RegExp(r'\D'), '');
                if (d.length < 10) return 'Phone seems invalid';
                return null;
              },
            ),
            const SizedBox(height: 12),
            if (_codeSent)
              TextFormField(
                controller: _otp,
                keyboardType: TextInputType.number,
                decoration: _dec('OTP'),
                validator: (v) {
                  if (!_codeSent) return null;
                  if (v == null || v.trim().isEmpty) return 'Enter OTP';
                  if (v.trim().length < 6) return '6 digits';
                  return null;
                },
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _busy
                    ? null
                    : () async {
                        if (!_codeSent) {
                          await _start();
                        } else {
                          await _verify();
                        }
                      },
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF5D78FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(_codeSent ? 'Verify OTP' : 'Send OTP',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  InputDecoration _dec(String l) => InputDecoration(
        labelText: l,
        labelStyle: GoogleFonts.poppins(fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF5D78FF).withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );

  Future<void> _start() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phone.text.trim(),
        verificationCompleted: (cred) async {
          await FirebaseAuth.instance.signInWithCredential(cred);
          if (!mounted) return;
          widget.onSuccess();
        },
        verificationFailed: (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed: ${e.message}')));
          setState(() => _busy = false);
        },
        codeSent: (id, _) {
          if (!mounted) return;
          setState(() {
            _verificationId = id;
            _codeSent = true;
            _busy = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('OTP sent')));
        },
        codeAutoRetrievalTimeout: (id) {
          _verificationId = id;
        },
      );
    } catch (_) {
      setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;
    if (_verificationId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Resend OTP')));
      return;
    }
    setState(() => _busy = true);
    try {
      final cred = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: _otp.text.trim());
      await FirebaseAuth.instance.signInWithCredential(cred);
      if (!mounted) return;
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid OTP: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _HomestayBookingSheet extends StatefulWidget {
  final HomestayModel h;
  const _HomestayBookingSheet({required this.h});
  @override
  State<_HomestayBookingSheet> createState() => _HomestayBookingSheetState();
}

class _HomestayBookingSheetState extends State<_HomestayBookingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _guests = TextEditingController(text: '2');
  final _notes = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final u = FirebaseAuth.instance.currentUser;
    if (u?.phoneNumber != null && u!.phoneNumber!.isNotEmpty) {
      _phone.text = u.phoneNumber!;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _guests.dispose();
    _notes.dispose();
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
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(2))),
                ),
                Text('Homestay Booking',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _name,
                  decoration: _dec('Your Name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: _dec('Phone Number'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter phone';
                    final d = v.replaceAll(RegExp(r'\D'), '');
                    if (d.length < 7) return 'Phone seems too short';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                      child: _dateTile('Check-in', _checkIn, () async {
                    final d = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate: _checkIn ?? DateTime.now(),
                    );
                    if (d != null) setState(() => _checkIn = d);
                  })),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _dateTile('Check-out', _checkOut, () async {
                    final start = _checkIn ?? DateTime.now();
                    final d = await showDatePicker(
                      context: context,
                      firstDate: start,
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate:
                          _checkOut ?? start.add(const Duration(days: 1)),
                    );
                    if (d != null) setState(() => _checkOut = d);
                  })),
                ]),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _guests,
                  keyboardType: TextInputType.number,
                  decoration: _dec('Guests'),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n <= 0) return 'Enter valid guests';
                    if (n > 20) return 'Too many';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notes,
                  minLines: 2,
                  maxLines: 3,
                  decoration: _dec('Notes (optional)'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _busy ? null : _submit,
                    icon: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_circle_outline),
                    label: Text(_busy ? 'Submitting...' : 'Confirm Booking',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF5D78FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF5D78FF).withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );

  Widget _dateTile(String label, DateTime? value, VoidCallback onTap) {
    final txt =
        value == null ? 'Select' : '${value.day}/${value.month}/${value.year}';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF5D78FF).withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF5D78FF).withOpacity(0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                color: Color(0xFF5D78FF), size: 18),
            const SizedBox(width: 10),
            Expanded(
                child: Text('$label: $txt',
                    style: GoogleFonts.poppins(fontSize: 14))),
            const Icon(Icons.edit_calendar, color: Color(0xFF5D78FF), size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select dates')));
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please login again')));
      Navigator.of(context).pop();
      return;
    }

    setState(() => _busy = true);
    try {
      await FirebaseFirestore.instance.collection('homestayBookings').add({
        'userId': uid,

        // homestay snapshot
        'homestayId': widget.h.id,
        'homestayTitle': widget.h.title,
        'homestayLocation': widget.h.location,
        'homestayImageUrl': widget.h.imageUrl,
        'pricePerNight': widget.h.pricePerNight,
        'rating': widget.h.rating,

        // booking info
        'name': _name.text.trim(),
        'phone': _phone.text.trim(),
        'guests': int.tryParse(_guests.text.trim()) ?? 1,
        'checkIn': Timestamp.fromDate(_checkIn!),
        'checkOut': Timestamp.fromDate(_checkOut!),
        'notes': _notes.text.trim(),

        // meta
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.of(context).pop(); // close sheet
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Booking submitted!')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
