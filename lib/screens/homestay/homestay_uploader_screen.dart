// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../data/dummy_homestays.dart';
// import 'homestay_repository.dart';

// class HomestayUploaderScreen extends StatefulWidget {
//   const HomestayUploaderScreen({super.key});

//   @override
//   State<HomestayUploaderScreen> createState() => _HomestayUploaderScreenState();
// }

// class _HomestayUploaderScreenState extends State<HomestayUploaderScreen> {
//   final repo = HomestayRepository();
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
//       await repo.seedDummyHomestays(dummyHomestays, onProgress: (d, t) {
//         setState(() {
//           done = d;
//           status = 'Uploaded $d of $t';
//         });
//       });
//       setState(() => status = 'All uploaded!');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Homestays uploaded to Firebase')),
//         );
//       }
//     } catch (e) {
//       setState(() => status = 'Error: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Upload failed: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => isUploading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final total = dummyHomestays.length;
//     final progress = total == 0 ? null : (done / total);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Homestays',
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('Seed Firestore with demo homestays (URL images only)',
//               style: GoogleFonts.poppins(fontSize: 14)),
//           const SizedBox(height: 16),
//           Row(children: [
//             ElevatedButton.icon(
//               onPressed: isUploading ? null : _uploadAll,
//               icon: const Icon(Icons.cloud_upload),
//               label: const Text('Upload All'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//             const SizedBox(width: 12),
//             if (isUploading)
//               const SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               ),
//           ]),
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
