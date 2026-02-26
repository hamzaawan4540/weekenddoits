import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weekenddoit/models/adventre.dart';

class AdventureBookingScreen extends StatefulWidget {
  final Activity activity;
  const AdventureBookingScreen({super.key, required this.activity});

  @override
  State<AdventureBookingScreen> createState() => _AdventureBookingScreenState();
}

class _AdventureBookingScreenState extends State<AdventureBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  DateTime? selectedDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // prefill phone from FirebaseAuth if available
    final ph = FirebaseAuth.instance.currentUser?.phoneNumber;
    if (ph != null && ph.isNotEmpty) phoneController.text = ph;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // must be logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to book.")),
      );
      return;
    }
    if (!_formKey.currentState!.validate() || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('adventureBookings').add({
        // who
        'userId': user.uid,
        'userPhone': user.phoneNumber ?? phoneController.text.trim(),

        // customer input
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'date': Timestamp.fromDate(selectedDate!), // selected day

        // adventure snapshot
        'activityTitle': widget.activity.title,
        'activityImageUrl': widget.activity.imageUrl,
        'price': widget.activity.price,
        'duration': widget.activity.duration,

        // meta
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Adventure booked successfully")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate == null
        ? "Pick Date"
        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Adventure",
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
              Text("Adventure: ${widget.activity.title}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Your Name",
                  filled: true,
                  fillColor: const Color(0xFF5D78FF).withOpacity(0.05),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  filled: true,
                  fillColor: const Color(0xFF5D78FF).withOpacity(0.05),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return "Enter phone";
                  if (t.replaceAll(RegExp(r'\D'), '').length < 7)
                    return "Phone looks short";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(dateText),
                trailing:
                    const Icon(Icons.calendar_month, color: Color(0xFF5D78FF)),
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF5D78FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(
                    _saving ? "Submitting..." : "Confirm Booking",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
