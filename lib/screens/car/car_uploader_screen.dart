import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/dummy_cars.dart';
import 'car_repository.dart';

class CarUploaderScreen extends StatefulWidget {
  const CarUploaderScreen({super.key});

  @override
  State<CarUploaderScreen> createState() => _CarUploaderScreenState();
}

class _CarUploaderScreenState extends State<CarUploaderScreen> {
  final repo = CarRepository();
  bool isUploading = false;
  int done = 0;
  String status = 'Idle';

  Future<void> _uploadAll() async {
    setState(() {
      isUploading = true;
      done = 0;
      status = 'Starting upload...';
    });

    try {
      await repo.seedDummyCars(dummyCars, onProgress: (d, t) {
        setState(() {
          done = d;
          status = 'Uploaded $d of $t';
        });
      });
      setState(() => status = 'All uploaded!');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cars uploaded to Firebase')),
        );
      }
    } catch (e) {
      setState(() => status = 'Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = dummyCars.length;
    final progress = total == 0 ? null : (done / total);

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Cars',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Seed Firestore + Storage with demo cars',
              style: GoogleFonts.poppins(fontSize: 14)),
          const SizedBox(height: 16),
          Row(children: [
            ElevatedButton.icon(
              onPressed: isUploading ? null : _uploadAll,
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Upload All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            if (isUploading)
              const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2)),
          ]),
          const SizedBox(height: 16),
          Text('Status: $status', style: GoogleFonts.poppins()),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: isUploading ? progress : null,
            minHeight: 8,
            backgroundColor: Colors.teal.shade50,
            color: Colors.teal,
          ),
          const SizedBox(height: 8),
          Text('Items: $total', style: GoogleFonts.poppins()),
        ]),
      ),
    );
  }
}
