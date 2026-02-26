import 'package:flutter/material.dart';
import 'car_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class CarLocationSelectionScreen extends StatelessWidget {
  const CarLocationSelectionScreen({super.key});

  final List<String> locations = const [
    'New York',
    'Los Angeles',
    'Miami',
    'Chicago',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: AppBar(
        title: Text(
          'Select Pickup Location',
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF5D78FF).withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF5D78FF)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Choose a city to explore available cars for rent.',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey.shade800),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: locations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(16),
                    shadowColor: const Color(0xFF5D78FF).withOpacity(0.1),
                    color: Colors.white,
                    child: ListTile(
                      leading:
                          const Icon(Icons.place, color: Color(0xFF5D78FF)),
                      title: Text(
                        locations[index],
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.chevron_right,
                          color: Color(0xFF5D78FF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CarListScreen(location: locations[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
