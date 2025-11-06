// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../data/dummy_apartments.dart';
// import 'apartment_repository.dart';

// class ApartmentUploaderScreen extends StatefulWidget {
//   const ApartmentUploaderScreen({super.key});
//   @override
//   State<ApartmentUploaderScreen> createState() =>
//       _ApartmentUploaderScreenState();
// }

// class _ApartmentUploaderScreenState extends State<ApartmentUploaderScreen> {
//   final repo = ApartmentRepository();
//   bool isUploading = false;
//   int done = 0;
//   String status = 'Idle';

//   Future<void> _seed() async {
//     setState(() {
//       isUploading = true;
//       done = 0;
//       status = 'Starting...';
//     });
//     try {
//       await repo.seedDummyApartments(dummyApartments, onProgress: (d, t) {
//         setState(() {
//           done = d;
//           status = 'Uploaded $d of $t';
//         });
//       });
//       setState(() => status = 'All uploaded!');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Apartments uploaded to Firebase')),
//         );
//       }
//     } catch (e) {
//       setState(() => status = 'Error: $e');
//     } finally {
//       if (mounted) setState(() => isUploading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final total = dummyApartments.length;
//     final progress = total == 0 ? null : (done / total);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Apartments',
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('Seed Firestore with dummy apartments (URL images only)',
//               style: GoogleFonts.poppins(fontSize: 14)),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: isUploading ? null : _seed,
//             icon: const Icon(Icons.cloud_upload),
//             label: const Text('Upload All'),
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal, foregroundColor: Colors.white),
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
