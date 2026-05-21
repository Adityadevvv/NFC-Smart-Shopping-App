import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool useSvgLogo = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 10, end: 30).animate(_controller);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Column(
                  children: [

                    useSvgLogo
    ? SvgPicture.asset(
        'assets/logo.svg',
        height: 100,
      )
    : Icon(
        Icons.nfc,
        size: 90,
        color: Colors.cyanAccent,
      ),

    SizedBox(height: 20),

    Text(
      "NsC",
      style: GoogleFonts.poppins(
        fontSize: 52,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 4,
      ),
    ),

    SizedBox(height: 10),

    Text(
      "Next-Gen Smart NFC",
      style: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
    ),
  ],
),

                SizedBox(height: 60),

                ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [

          // 🔥 SignUp Button (UPDATED)
          SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFFFE0), // ✅ Pastel Yellow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => SignupScreen(),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    },
    child: Text(
      "SignUp",
      style: TextStyle(
        color: const Color(0xFF008080), // ✅ Teal text
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

          SizedBox(height: 15),

          // 🔥 Login Button (UPDATED)
          SizedBox(
  width: double.infinity,
  height: 50,
  child: OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Color(0xFFFFFFE0)), // ✅ Pastel Yellow border
      //backgroundColor: const Color(0xFFFFFFE0), // ✅ same as filled button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    },
    child: Text(
      "Login",
      style: TextStyle(
        color: const Color(0xFFFFFFE0), // ✅ PASTEL YELLOW text
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
        ],
      ),
    ),
  ),
),
              ],
            );
          },
        ),
      ),
    ),
  );
}

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
}