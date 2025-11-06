// screens/bookings/booking_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'apartment_bookings_list.dart';
import 'car_bookings_list.dart';
import 'hotel_bookings_list.dart';
import 'tour_bookings_list.dart';
import 'homestay_bookings_list.dart';
import 'adventure_bookings_list.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      (Icons.tour, 'Tours'),
      (Icons.car_rental, 'Cars'),
      (Icons.hotel, 'Hotels'),
      (Icons.home_work, 'Homestays'),
      (Icons.apartment, 'Apartments'),
      (Icons.directions_run, 'Adventures'),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        // Subtle background
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, -1),
              end: Alignment(0, 0.5),
              colors: [Color(0xFFe8f6f3), Color(0xFFF7FBFA)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Premium header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Row(
                    children: [
                      Text(
                        "My Bookings",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF064e46),
                        ),
                      ),
                      const Spacer(),
                      // Decorative icon
                      // Container(
                      //   padding: const EdgeInsets.all(10),
                      //   decoration: BoxDecoration(
                      //     color: Colors.teal.withOpacity(.1),
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: const Icon(Icons.event_note, color: Colors.teal),
                      // ),
                    ],
                  ),
                ),

                // Glassy card with rounded pill TabBar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
                  child: _TabPillCard(
                    child: TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: Colors.teal.shade600,
                          width: 3, // thickness of the bottom line
                        ),
                        insets: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      labelColor: Colors.teal.shade800,
                      unselectedLabelColor: Colors.grey.shade600,
                      overlayColor:
                          WidgetStateProperty.all(Colors.teal.withOpacity(.05)),
                      tabs: tabs
                          .map(
                            (t) => Tab(
                              iconMargin: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(t.$1, size: 18),
                                  const SizedBox(width: 6),
                                  Text(t.$2),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Content area
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: const TabBarView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          TourBookingsList(),
                          CarBookingsList(),
                          HotelBookingsList(),
                          HomestayBookingsList(),
                          ApartmentBookingsList(),
                          AdventureBookingsList(),
                        ],
                      ),
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

/// A soft card to hold the rounded TabBar
class _TabPillCard extends StatelessWidget {
  final Widget child;
  const _TabPillCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.8),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.teal.withOpacity(.08)),
      ),
      child: child,
    );
  }
}

/// Rounded “pill” indicator for the TabBar
class _PillIndicator extends Decoration {
  final Color color;
  final BorderRadius radius;
  final double horizontalPadding;
  final double verticalPadding;

  const _PillIndicator({
    required this.color,
    required this.radius,
    this.horizontalPadding = 8,
    this.verticalPadding = 6,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _PillPainter(
      color: color,
      radius: radius,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
    );
  }
}

class _PillPainter extends BoxPainter {
  final Color color;
  final BorderRadius radius;
  final double horizontalPadding;
  final double verticalPadding;

  _PillPainter({
    required this.color,
    required this.radius,
    required this.horizontalPadding,
    required this.verticalPadding,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    if (cfg.size == null) return;
    final rect = offset & cfg.size!;
    final r = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        rect.left + horizontalPadding,
        rect.top + verticalPadding,
        rect.width - 2 * horizontalPadding,
        rect.height - 2 * verticalPadding,
      ),
      topLeft: radius.topLeft,
      topRight: radius.topRight,
      bottomLeft: radius.bottomLeft,
      bottomRight: radius.bottomRight,
    );

    final paint = Paint()..color = color;
    canvas.drawRRect(r, paint);
  }
}
