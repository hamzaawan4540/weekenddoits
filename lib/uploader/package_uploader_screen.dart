// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:weekenddoit/screens/repositories/travel_package_repository.dart';
// import '../../data/dummy_packages.dart';

// class PackageUploaderScreen extends StatefulWidget {
//   const PackageUploaderScreen({super.key});

//   @override
//   State<PackageUploaderScreen> createState() => _PackageUploaderScreenState();
// }

// class _PackageUploaderScreenState extends State<PackageUploaderScreen> {
//   final repo = TravelPackageRepository();
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
//       await repo.seedDummyPackages(dummyPackages, onProgress: (d, t) {
//         setState(() {
//           done = d;
//           status = 'Uploaded $d of $t';
//         });
//       });
//       setState(() {
//         status = 'All uploaded!';
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('All packages uploaded to Firebase')),
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
//       setState(() => isUploading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Packages',
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(
//             'Seed Firestore + Storage with dummy tour packages',
//             style: GoogleFonts.poppins(fontSize: 14),
//           ),
//           const SizedBox(height: 20),
//           Row(children: [
//             ElevatedButton.icon(
//               onPressed: isUploading ? null : _uploadAll,
//               icon: const Icon(Icons.cloud_upload),
//               label: const Text('Upload All'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 foregroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
//           const SizedBox(height: 20),
//           Text('Status: $status', style: GoogleFonts.poppins()),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: (done == 0 || dummyPackages.isEmpty)
//                 ? null
//                 : done / dummyPackages.length,
//             backgroundColor: Colors.teal.shade50,
//             color: Colors.teal,
//             minHeight: 8,
//           ),
//           const SizedBox(height: 12),
//           Text('Items: ${dummyPackages.length}', style: GoogleFonts.poppins()),
//         ]),
//       ),
//     );
//   }
// }
