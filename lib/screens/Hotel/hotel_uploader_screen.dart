// // lib/screens/Hotel/hotel_uploader_screen.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../data/dummy_hotels.dart';
// import 'hotel_repository.dart';

// class HotelUploaderScreen extends StatefulWidget {
//   const HotelUploaderScreen({super.key});

//   @override
//   State<HotelUploaderScreen> createState() => _HotelUploaderScreenState();
// }

// class _HotelUploaderScreenState extends State<HotelUploaderScreen> {
//   final repo = HotelRepository();
//   bool isUploading = false;
//   int done = 0;
//   String status = 'Idle';

//   Future<void> _uploadAll() async {
//     setState(() {
//       isUploading = true;
//       done = 0;
//       status = 'Starting upload...';
//     });

//     try {
//       await repo.seedDummyHotels(dummyHotels, onProgress: (d, t) {
//         setState(() {
//           done = d;
//           status = 'Uploaded $d of $t';
//         });
//       });
//       setState(() => status = 'All uploaded!');
//     } catch (e) {
//       setState(() => status = 'Error: $e');
//     } finally {
//       if (mounted) setState(() => isUploading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final total = dummyHotels.length;
//     final progress = total == 0 ? null : (done / total);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Hotels',
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('Seed Firestore with demo hotels (URL only)',
//               style: GoogleFonts.poppins(fontSize: 14)),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: isUploading ? null : _uploadAll,
//             icon: const Icon(Icons.cloud_upload),
//             label: const Text('Upload All'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.teal,
//               foregroundColor: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text('Status: $status', style: GoogleFonts.poppins()),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: isUploading ? progress : null,
//             minHeight: 8,
//             backgroundColor: Colors.teal.shade50,
//             color: Colors.teal,
//           ),
//           const SizedBox(height: 8),
//           Text('Items: $total', style: GoogleFonts.poppins()),
//         ]),
//       ),
//     );
//   }
// }
