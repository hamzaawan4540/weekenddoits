import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/car.dart';

class CarBookingDetailScreen extends StatefulWidget {
  final Car car;
  final String location;

  const CarBookingDetailScreen({
    super.key,
    required this.car,
    required this.location,
  });

  @override
  State<CarBookingDetailScreen> createState() => _CarBookingDetailScreenState();
}

class _CarBookingDetailScreenState extends State<CarBookingDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool _saving = false;

  String get formattedDate => selectedDate != null
      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
      : '--/--/----';

  String get formattedTime =>
      selectedTime != null ? selectedTime!.format(context) : '--:--';

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FC),
      appBar: AppBar(
        title: Text('Booking - ${widget.car.name}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.teal.shade600,
        elevation: 5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 6))
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildTextField(nameController, 'Your Name'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      phoneController,
                      'Your Number',
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter Your Number';
                        }
                        final digits = v.replaceAll(RegExp(r'\D'), '');
                        if (digits.length < 7) return 'Phone looks too short';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(fromController, 'From'),
                    const SizedBox(height: 16),
                    _buildTextField(toController, 'To'),
                    const SizedBox(height: 16),
                    _buildDateTimeTile(Icons.calendar_today, 'Select Date',
                        formattedDate, pickDate),
                    const SizedBox(height: 12),
                    _buildDateTimeTile(Icons.access_time, 'Select Time',
                        formattedTime, pickTime),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saving ? null : _onConfirm,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(_saving ? 'Saving...' : 'Confirm Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        filled: true,
        fillColor: Colors.teal.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator ??
          (value) => value!.trim().isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDateTimeTile(
      IconData icon, String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.shade100),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 12),
            Expanded(
              child: Text('$label: $value',
                  style: GoogleFonts.poppins(
                      fontSize: 15, color: Colors.grey.shade800)),
            ),
            const Icon(Icons.edit_calendar, color: Colors.teal),
          ],
        ),
      ),
    );
  }

  Future<void> _onConfirm() async {
    // validate form + date/time
    if (!_formKey.currentState!.validate() ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      // combine date & time into a single DateTime
      final dt = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      final uid = FirebaseAuth.instance.currentUser?.uid;

      await FirebaseFirestore.instance.collection('car_bookings').add({
        // customer input
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'from': fromController.text.trim(),
        'to': toController.text.trim(),
        'pickupAt': Timestamp.fromDate(dt),

        // car info
        'carId': widget.car.id, // make sure your Car has an `id` field
        'carName': widget.car.name,
        'carImageUrl': widget.car.imageUrl,
        'pricePerDay': widget.car.pricePerDay,
        'location': widget.location,

        // auth + metadata
        'userId': uid, // can be null if not logged in
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking submitted!')),
      );
      Navigator.pop(context); // back to car list
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
