import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_check_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startApp();
  }

  void startApp() async {

    // ⏳ Splash delay
    await Future.delayed(const Duration(seconds: 2));

    // 🔥 Navigate to AuthCheck (handles admin/user)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthCheckScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🔥 NFC Icon
              const Icon(
                Icons.nfc,
                size: 90,
                color: Colors.white,
              ),

              const SizedBox(height: 20),

              // 🔥 App Name
              Text(
                "NFC Smart Cart",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              // 🔥 Subtitle
              Text(
                "Smart Shopping Experience",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 30),

              // 🔄 Loading Indicator
              const CircularProgressIndicator(
                color: Colors.cyanAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}