import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // App Check disabled in dev to avoid “No AppCheckProvider”:
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );

  // Optional: only if you configured TEST phone numbers in console
  if (kDebugMode && Platform.isAndroid) {
    await FirebaseAuth.instance
        .setSettings(appVerificationDisabledForTesting: false);
  }

  runApp(const WeekendDoItApp());
}

class WeekendDoItApp extends StatelessWidget {
  const WeekendDoItApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weekend Do It',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
