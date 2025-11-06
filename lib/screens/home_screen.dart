import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      appBar: const CustomAppBar(logoAssetPath: 'assets/app_logo.png'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),

            // Use a separate widget that returns a shrink-wrapped GridView
            const PremiumCategoryGridContent(),

            const SizedBox(height: 16),

            ImageSlider(imageUrls: sliderImages),

            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: dummyPackages.map((tour) {
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
              }).toList(),
            ),

            const SizedBox(height: 24),
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
