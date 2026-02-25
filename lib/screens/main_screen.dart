import 'package:flutter/material.dart';
import 'package:weekenddoit/screens/bookings/BookingPage.dart';
import 'package:weekenddoit/screens/SettingsScreen.dart';
import 'package:weekenddoit/screens/TravelPackageListScreen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    BookingPage(),
    TravelPackageListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFF00A896),
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w700, height: 1.5),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w500, height: 1.5),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 24),
              activeIcon: Icon(Icons.home_rounded, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded, size: 24),
              activeIcon: Icon(Icons.calendar_month_rounded, size: 28),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_travel_rounded, size: 24),
              activeIcon: Icon(Icons.card_travel_rounded, size: 28),
              label: 'Tour',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded, size: 24),
              activeIcon: Icon(Icons.settings_rounded, size: 28),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for future screens
class PlaceholderWidget extends StatelessWidget {
  final String title;
  const PlaceholderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Screen',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
