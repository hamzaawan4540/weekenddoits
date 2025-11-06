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
      // Service Bell (3D Fluency)
      networkUrl: 'https://img.icons8.com/?size=96&id=1sKGpz9F5DnT&format=png',
    ),
    _CategoryItem(
      title: 'Homestay',
      // Home (3D Fluency)
      networkUrl: 'https://img.icons8.com/?size=96&id=iJzm3AFQCS4W&format=png',
    ),
    _CategoryItem(
      title: 'Apartment',
      // School Building (3D Fluency)
      networkUrl: 'https://img.icons8.com/?size=96&id=XAg8ooTyo7Dl&format=png',
    ),
    _CategoryItem(
      title: 'Travel Package',
      // Suitcase (3D Fluency)
      networkUrl: 'https://img.icons8.com/?size=96&id=OzQUBn0YVaV9&format=png',
    ),
    _CategoryItem(
      title: 'Cab',
      // Taxi (3D Fluency)
      networkUrl: 'https://img.icons8.com/?size=96&id=Q2m4bLp5g5kF&format=png',
    ),
    _CategoryItem(
      title: 'Adventure Activities',
      // Mountain (3D Fluency)
      networkUrl: 'https://img.icons8.com/?size=96&id=1i1OucArxwqF&format=png',
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
          // Slightly taller to avoid vertical overflow on 2-line labels
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _PremiumCategoryCard(
            title: cat.title,
            networkUrl: cat.networkUrl,
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
  final String networkUrl;

  const _CategoryItem({
    required this.title,
    required this.networkUrl,
  });
}

class _PremiumCategoryCard extends StatelessWidget {
  final String title;
  final String networkUrl;
  final VoidCallback onTap;

  const _PremiumCategoryCard({
    super.key,
    required this.title,
    required this.networkUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 56;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Network image with loading & error handling
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  networkUrl,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stack) => Container(
                    width: iconSize,
                    height: iconSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Flexible text to prevent RenderFlex overflows
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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
