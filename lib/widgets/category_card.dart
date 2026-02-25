import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Screens & data (adjust paths if your project differs)
import 'package:weekenddoit/data/dummy_activities.dart';
import 'package:weekenddoit/screens/Adventure/AdventureListScreen.dart';
import 'package:weekenddoit/screens/Apartment/ApartmentListScreen.dart';
import 'package:weekenddoit/screens/Hotel/HotelListScreen.dart';
import 'package:weekenddoit/screens/TravelPackageListScreen.dart';
import 'package:weekenddoit/screens/car/car_location_selection_screen.dart';
import 'package:weekenddoit/screens/homestay/homestay_list_screen.dart';

class PremiumCategoryGridContent extends StatelessWidget {
  const PremiumCategoryGridContent({super.key});

  // All categories use networkUrl icons only
  static const List<_CategoryItem> categories = [
    _CategoryItem(
      title: 'Hotel',
      assetPath: 'assets/3d icon/hotel.png',
    ),
    _CategoryItem(
      title: 'Homestay',
      assetPath: 'assets/3d icon/home.png',
    ),
    _CategoryItem(
      title: 'Apartment',
      assetPath: 'assets/3d icon/apartment.png',
    ),
    _CategoryItem(
      title: 'Travel Package',
      assetPath: 'assets/3d icon/travel.png',
    ),
    _CategoryItem(
      title: 'Cab',
      assetPath: 'assets/3d icon/taxi.png',
    ),
    _CategoryItem(
      title: 'Adventure Activities',
      assetPath: 'assets/3d icon/adventure.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          // Adjusted ratio for larger icons
          childAspectRatio: 0.82,
        ),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _PremiumCategoryCard(
            title: cat.title,
            assetPath: cat.assetPath,
            onTap: () {
              switch (cat.title.toLowerCase()) {
                case 'hotel':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HotelListScreen()),
                  );
                  break;
                case 'homestay':
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TravelPackageListScreen()),
                  );
                  break;
                case 'cab':
                case 'outstation cabs':
                case 'airport cabs':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CarLocationSelectionScreen()),
                  );
                  break;
                case 'adventure activities':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdventureListScreen(),
                    ),
                  );
                  break;
                default:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${cat.title} screen coming soon")),
                  );
              }
            },
          );
        },
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final String assetPath;

  const _CategoryItem({
    required this.title,
    required this.assetPath,
  });
}

class _PremiumCategoryCard extends StatelessWidget {
  final String title;
  final String assetPath;
  final VoidCallback onTap;

  const _PremiumCategoryCard({
    super.key,
    required this.title,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 58;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F2F6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    assetPath,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) => const Icon(
                      Icons.image_not_supported_rounded,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3436),
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
