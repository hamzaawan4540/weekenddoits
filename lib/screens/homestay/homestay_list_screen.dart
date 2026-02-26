import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/homestay_model.dart';
import 'homestay_repository.dart';
import 'homestay_detail_screen.dart';

class HomestayListScreen extends StatefulWidget {
  const HomestayListScreen({super.key});

  @override
  State<HomestayListScreen> createState() => _HomestayListScreenState();
}

class _HomestayListScreenState extends State<HomestayListScreen> {
  final repo = HomestayRepository();
  final _search = TextEditingController();
  String _locationFilter = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stream = repo.streamHomestays(
      location: _locationFilter.isEmpty ? null : _locationFilter,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          'Homestays',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE67E22), // Matching theme
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // top search / filters
          Container(
            color: const Color(0xFFE67E22), // Matching theme
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _SearchField(
                    controller: _search,
                    hint: 'Search by location (e.g., Goa)',
                    onSubmitted: (v) => setState(() {
                      _locationFilter = v.trim();
                    }),
                    onClear: () => setState(() {
                      _search.clear();
                      _locationFilter = '';
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  tooltip: 'Quick locations',
                  onSelected: (v) => setState(() {
                    _search.text = v;
                    _locationFilter = v;
                  }),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'Goa', child: Text('Goa')),
                    PopupMenuItem(
                        value: 'Manali, Himachal', child: Text('Manali')),
                    PopupMenuItem(value: 'Mumbai', child: Text('Mumbai')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // content
          Expanded(
            child: StreamBuilder<List<HomestayModel>>(
              stream: stream,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const _GridSkeleton();
                }
                if (snap.hasError) {
                  return _CenteredState(
                    icon: Icons.error_outline,
                    title: 'Something went wrong',
                    subtitle: snap.error.toString(),
                  );
                }

                final homes = snap.data ?? [];
                if (homes.isEmpty) {
                  return _CenteredState(
                    icon: Icons.home_outlined,
                    title: 'No homestays found',
                    subtitle: _locationFilter.isEmpty
                        ? 'Try uploading demo data or check back later.'
                        : 'No results for “$_locationFilter”.',
                    ctaText: _locationFilter.isEmpty ? null : 'Clear filter',
                    onCta: _locationFilter.isEmpty
                        ? null
                        : () => setState(() {
                              _search.clear();
                              _locationFilter = '';
                            }),
                  );
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: GridView.builder(
                    itemCount: homes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: .72,
                    ),
                    itemBuilder: (_, i) {
                      final h = homes[i];
                      return _HomestayCard(
                        homestay: h,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomestayDetailScreen(homestay: h),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomestayCard extends StatelessWidget {
  final HomestayModel homestay;
  final VoidCallback onTap;

  const _HomestayCard({
    required this.homestay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = '₹${homestay.pricePerNight.toStringAsFixed(0)} / night';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: const Color(0xFF5D78FF).withOpacity(.08),
        highlightColor: const Color(0xFF5D78FF).withOpacity(.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image + badges
            Stack(
              children: [
                Hero(
                  tag: 'homestay:${homestay.id}',
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.network(
                      homestay.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image, size: 28),
                      ),
                      loadingBuilder: (c, child, p) {
                        if (p == null) return child;
                        return Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // price badge
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.55),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      price,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // text
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homestay.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Color(0xFF5D78FF)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          homestay.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: Colors.grey.shade700,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  const _SearchField({
    required this.controller,
    required this.hint,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      style: GoogleFonts.poppins(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(.8)),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: onClear,
              ),
        filled: true,
        fillColor: Colors.white.withOpacity(.15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(.25)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _CenteredState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? ctaText;
  final VoidCallback? onCta;

  const _CenteredState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.ctaText,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF5D78FF)),
            const SizedBox(height: 12),
            Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!,
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.poppins(fontSize: 13, color: Colors.black54)),
            ],
            if (ctaText != null && onCta != null) ...[
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: onCta,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF5D78FF),
                  side: const BorderSide(color: Color(0xFF5D78FF)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(ctaText!,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: .72,
        ),
        itemBuilder: (_, __) {
          return _SkelCard();
        },
      ),
    );
  }
}

class _SkelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget box([double h = 14]) => Container(
          height: h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                box(16),
                const SizedBox(height: 8),
                box(),
                const SizedBox(height: 8),
                SizedBox(height: 14, child: box(14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
