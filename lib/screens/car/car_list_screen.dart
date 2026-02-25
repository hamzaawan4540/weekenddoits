import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/car.dart';
import 'CarBookingDetailScreen.dart';
import 'car_repository.dart';

class CarListScreen extends StatelessWidget {
  final String location;
  CarListScreen({super.key, required this.location});

  final _repo = CarRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
      appBar: AppBar(
        title: Text(
          'Cars in $location',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF00A896),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Car>>(
        stream: _repo.streamCars(location: location), // 🔥 live from Firestore
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text('Error: ${snap.error}', style: GoogleFonts.poppins()),
            );
          }
          final cars = snap.data ?? [];
          if (cars.isEmpty) {
            return Center(
              child:
                  Text('No cars available here.', style: GoogleFonts.poppins()),
            );
          }

          return _CarList(cars: cars, location: location);
        },
      ),
    );
  }
}

class _CarList extends StatefulWidget {
  final List<Car> cars;
  final String location;
  const _CarList({required this.cars, required this.location});

  @override
  State<_CarList> createState() => _CarListState();
}

class _CarListState extends State<_CarList> {
  Car? selectedCar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Expanded(
          child: ListView.separated(
            itemCount: widget.cars.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final car = widget.cars[index];
              final isSelected = selectedCar?.id == car.id;

              return GestureDetector(
                onTap: () => setState(() => selectedCar = car),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.teal.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: isSelected ? Colors.teal : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          car.imageUrl,
                          width: 100,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 100,
                            height: 70,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(car.name,
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('₹${car.pricePerDay.toStringAsFixed(0)} / day',
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.grey.shade700)),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Colors.teal),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: selectedCar != null
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarBookingDetailScreen(
                        car: selectedCar!,
                        location: widget.location,
                      ),
                    ),
                  );
                }
              : null,
          icon: const Icon(Icons.car_rental),
          label: const Text('Book Now'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A896),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            disabledForegroundColor: Colors.grey.shade500,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        )
      ]),
    );
  }
}
