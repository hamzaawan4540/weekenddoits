// lib/widgets/image_slider.dart  (drop-in replacement using ShimmerImage)
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'shimmer.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageUrls;
  final double height;
  const ImageSlider({
    super.key,
    required this.imageUrls,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        enableInfiniteScroll: true,
      ),
      items: imageUrls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: ShimmerImage(
                url: url,
                width: double.infinity,
                height: height,
                borderRadius: BorderRadius.circular(16),
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
