import 'package:flutter/material.dart';
import 'package:weekenddoit/screens/Hotel/HotelListScreen.dart';
import 'package:weekenddoit/screens/car/car_location_selection_screen.dart';
import 'package:weekenddoit/screens/homestay/homestay_list_screen.dart';
import 'package:weekenddoit/screens/Apartment/ApartmentListScreen.dart';
import 'package:weekenddoit/screens/TravelPackageListScreen.dart';
import 'package:weekenddoit/screens/Adventure/AdventureListScreen.dart';

class PremiumCategoryGridContent extends StatelessWidget {
  final int startIndex;
  const PremiumCategoryGridContent({super.key, this.startIndex = 0});

  static const List<CategoryItem> categories = [
    CategoryItem(
      title: 'Hotel',
      assetPath: 'assets/3d icon/hotel.png',
    ),
    CategoryItem(
      title: 'Homestay',
      assetPath: 'assets/3d icon/home.png',
    ),
    CategoryItem(
      title: 'Apartment',
      assetPath: 'assets/3d icon/apartment.png',
    ),
    CategoryItem(
      title: 'Travel Package',
      assetPath: 'assets/3d icon/travel.png',
    ),
    CategoryItem(
      title: 'Cab',
      assetPath: 'assets/3d icon/taxi.png',
    ),
    CategoryItem(
      title: 'Adventure Activities',
      assetPath: 'assets/3d icon/adventure.png',
    ),
    CategoryItem(
      title: 'Hotels',
      assetPath: 'assets/3d icon/hotel.png', // Using existing for demo
    ),
    CategoryItem(
      title: 'Apartments',
      assetPath: 'assets/3d icon/apartment.png', // Using existing for demo
    ),
    CategoryItem(
      title: 'Homes',
      assetPath: 'assets/3d icon/home.png', // Using existing for demo
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final displayCategories = categories.sublist(startIndex);

    return Column(
      children: [
        SizedBox(
          height: 115, // Increased from 100 to 115
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: displayCategories.length,
            itemBuilder: (context, index) {
              final cat = displayCategories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6), // Reduced from 12 to 6
                child: PremiumCategoryCard(
                  title: cat.title,
                  assetPath: cat.assetPath,
                  onTap: () => handleCategoryTap(context, cat.title),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Indicator bar like image
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE67E22), // Orange indicator
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryItem {
  final String title;
  final String assetPath;

  const CategoryItem({
    required this.title,
    required this.assetPath,
  });
}

void handleCategoryTap(BuildContext context, String title) {
  switch (title.toLowerCase()) {
    case 'hotel':
    case 'hourly stays':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HotelListScreen()),
      );
      break;
    case 'homestay':
    case 'hostels':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomestayListScreen()),
      );
      break;
    case 'apartment':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ApartmentListScreen()),
      );
      break;
    case 'travel package':
    case 'holiday packages':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TravelPackageListScreen()),
      );
      break;
    case 'cab':
    case 'cabs':
    case 'outstation cabs':
    case 'airport cabs':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CarLocationSelectionScreen()),
      );
      break;
    case 'adventure activities':
    case 'travel insurance':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdventureListScreen(),
        ),
      );
      break;
  }
}

class PremiumCategoryCard extends StatelessWidget {
  final String title;
  final String assetPath;
  final VoidCallback onTap;

  const PremiumCategoryCard({
    super.key,
    required this.title,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 85, // Increased from 75 to 85 to accommodate larger text/icons
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath,
                height: 48, fit: BoxFit.contain), // Increased from 40 to 48
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 13.5, // Increased from 12 to 13.5
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
