import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weekenddoit/models/tour_package.dart';
import 'package:weekenddoit/screens/repositories/travel_package_repository.dart';

import 'package:weekenddoit/widgets/tour_card.dart';
import 'detail_screen.dart';

class TravelPackageListScreen extends StatelessWidget {
  const TravelPackageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = TravelPackageRepository();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: AppBar(
        title: Text(
          'Travel Packages',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: StreamBuilder<List<TourPackage>>(
          stream: repo.streamPackages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: GoogleFonts.poppins()),
              );
            }
            final items = snapshot.data ?? const [];
            if (items.isEmpty) {
              return Center(
                child: Text(
                  'No packages found.\nSeeding will run automatically on first launch.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              );
            }

            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              childAspectRatio: 0.75,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              children: items.map((tour) {
                return TourCard(
                  tour: tour,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailScreen(tour: tour)),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
