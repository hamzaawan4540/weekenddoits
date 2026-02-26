import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Overlapping 3 Cards
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildCustomHeader(context),
                Positioned(
                  bottom: -60, // Overlap halfway
                  left: 12,
                  right: 12,
                  child: Row(
                    children: [
                      _buildTopOverlapCard(
                          context, PremiumCategoryGridContent.categories[0]),
                      _buildTopOverlapCard(
                          context, PremiumCategoryGridContent.categories[1]),
                      _buildTopOverlapCard(
                          context, PremiumCategoryGridContent.categories[2]),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80), // Spacer for overlap

            // Grid for Remaining Categories
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: PremiumCategoryGridContent(
                  startIndex: 3), // Showing from index 3
            ),

            const SizedBox(height: 12),

            // Image Slider / Featured Offers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ImageSlider(imageUrls: sliderImages),
            ),

            const SizedBox(height: 24),

            // Offers For You Section
            _buildOffersSection(),

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
                childAspectRatio: 0.72,
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

  Widget _buildTopOverlapCard(BuildContext context, CategoryItem item) {
    return Expanded(
      child: GestureDetector(
        onTap: () => handleCategoryTap(context, item.title),
        child: Container(
          height: 125, // Increased height from 110 to 125
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(item.assetPath,
                  height: 55, fit: BoxFit.contain), // Icon from 50 to 55
              const SizedBox(height: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOffersSection() {
    final List<String> filters = [
      "All",
      "Hotels",
      "Apartments",
      "Cabs",
      "Home Stay",
      "Adventure Activities",
      "Travel Packages",
    ];
    int selectedIndex = 0;

    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Offers For You",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      Text(
                        "View All",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5D78FF),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_circle_right,
                          color: Color(0xFF5D78FF), size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFFE8EFFF) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF5D78FF)
                            : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        filters[index],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF5D78FF)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCustomHeader(BuildContext context) {
    return ClipPath(
      clipper: HeaderCurveClipper(),
      child: Container(
        width: double.infinity,
        height: 180, // Adjusted height for a smooth look
        decoration: const BoxDecoration(
          color: Color(0xFFE67E22), // Softer, lighter orange
        ),
        padding: const EdgeInsets.fromLTRB(
            10, 20, 10, 60), // Content higher and compact
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Profile & Name
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white,
                            width: 2), // Solid white border
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFD35400), // Tez (Intense Orange)
                            Color(0xFFF39C12), // Halka (Light Orange)
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "JM",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.menu,
                            size: 10, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8), // More compact
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hey Jonayat",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14, // Reduced from 16
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "goTribe",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11, // Reduced from 12
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 0.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "2",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 9, // Reduced from 10
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Right: Wallet, Notifications, Group
            Row(
              children: [
                // Wallet with Badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined,
                        color: Colors.white, size: 23), // Reduced
                    Positioned(
                      top: -10,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5D78FF), // Blue like image
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "₹ 100",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9, // Reduced from 10
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Notification with dot
                Stack(
                  children: [
                    const Icon(Icons.notifications_none_outlined,
                        color: Colors.white, size: 23), // Reduced
                    Positioned(
                      top: 3,
                      right: 3,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5D78FF), // Blue dot
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Group/Referral Icon
                const Icon(Icons.people_outline,
                    color: Colors.white, size: 23), // Reduced
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for the Smooth Curve
class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    // Smooth quadratic curve
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

const sliderImages = [
  'https://th.bing.com/th/id/OIP.Js8LNJNKy3JzAFJ62rc8AwHaFj?cb=iwc1&w=550&h=413&rs=1&pid=ImgDetMain',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
];
