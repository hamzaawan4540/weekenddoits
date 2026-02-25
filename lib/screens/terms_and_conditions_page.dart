import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
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
        padding: const EdgeInsets.all(16),
        children: [
          _h('1. Agreement'),
          _p('By using Weekend Do It, you agree to the terms below. This is demo content.'),
          _h('2. Bookings'),
          _p('All bookings are subject to availability. Changes/cancellations may incur fees.'),
          _h('3. User Responsibilities'),
          _p('Provide accurate information, comply with local laws, and respect community guidelines.'),
          _h('4. Limitation of Liability'),
          _p('We are not liable for indirect or incidental damages arising from service use.'),
          _h('5. Governing Law'),
          _p('These terms are governed by the applicable laws of your region.'),
          _h('6. Changes'),
          _p('We may revise these terms; continued use constitutes acceptance.'),
          const SizedBox(height: 20),
          Text('Effective date: Jan 1, 2025',
              style: GoogleFonts.poppins(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _h(String text) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 6),
        child: Text(text,
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
      );

  Widget _p(String text) => Text(text, style: GoogleFonts.poppins(height: 1.6));
}
