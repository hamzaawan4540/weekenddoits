import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
          _h('1. Introduction'),
          _p('This is a demo privacy policy for the Weekend Do It application. '
              'It explains how we may collect, use, and protect your data.'),
          _h('2. Information We Collect'),
          _p('• Contact info (phone) for authentication.\n'
              '• Booking details (name, address, participants) to complete your bookings.\n'
              '• Analytics information to improve app performance.'),
          _h('3. How We Use Your Information'),
          _p('We use your information strictly to provide and improve the services, '
              'including processing bookings, offering support, and communicating important updates.'),
          _h('4. Data Retention'),
          _p('We retain data for as long as necessary to provide services or as required by law.'),
          _h('5. Contact'),
          _p('For questions, contact: support@weekenddoit.example'),
          const SizedBox(height: 20),
          Text('Last updated: Jan 1, 2025',
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
