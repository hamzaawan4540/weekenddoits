import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weekenddoit/widgets/custom_appbar.dart';
import 'package:weekenddoit/widgets/image_slider.dart';
import '../data/dummy_packages.dart';
import '../widgets/tour_card.dart';
import '../widgets/category_card.dart'; // Import this
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar:  CustomAppBar(logoAssetPath: 'assets/app_logo.png', size: 90,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero/Welcome Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explore the world",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    "Discover your next adventure",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Category Grid
            const PremiumCategoryGridContent(),

            const SizedBox(height: 12),

            // Image Slider / Featured Offers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ImageSlider(imageUrls: sliderImages),
            ),

            const SizedBox(height: 24),

            // Popular Packages Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Popular Packages",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Tours Grid
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.72, // Increased height space to avoid overflow
              ),
              itemCount: dummyPackages.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final tour = dummyPackages[index];
                return TourCard(
                  tour: tour,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(tour: tour),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

const sliderImages = [
  'https://th.bing.com/th/id/OIP.Js8LNJNKy3JzAFJ62rc8AwHaFj?cb=iwc1&w=550&h=413&rs=1&pid=ImgDetMain',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
];
