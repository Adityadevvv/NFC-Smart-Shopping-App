import 'dart:ui';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin/admin_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  Future<void> loginUser() async {

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;

final doc = await FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .get();

Map<String, dynamic>? data = doc.data();

String role = "user";

if (data != null && data.containsKey('role')) {
  role = data['role'];
}

if (role == "admin") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => AdminHomeScreen()),
  );
} else {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  );
};

    } on FirebaseAuthException catch (e) {

      String message;

      switch (e.code) {

        case 'user-not-found':
          message = "No user found with this email";
          break;

        case 'wrong-password':
          message = "Incorrect password";
          break;

        case 'invalid-email':
          message = "Invalid email format";
          break;

        case 'invalid-credential':
          message = "Email or password is incorrect";
          break;

        default:
          message = e.message ?? "Login failed";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
  Future<void> resetPassword() async {
  if (emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enter your email first")),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: emailController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password reset email sent")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
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

        child: SafeArea(
          child: Stack(
            children: [

              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(25),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 30),

                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white38),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyanAccent),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller: passwordController,
                            
                            obscureText: !isPasswordVisible,
                            style: const TextStyle(color: Colors.white),

                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(color: Colors.white70),

                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),

                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white38),
                              ),

                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyanAccent),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 50,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFFFE0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),

                              onPressed: loginUser,

                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Color(0xFF008080),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

Align(
  alignment: Alignment.center,
  child: GestureDetector(
    onTap: resetPassword,
    child: Text(
      "Forgot Password?",
      style: GoogleFonts.poppins(
        color: const Color(0xFFFFFFE0), // Pastel Yellow
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),
                          const SizedBox(height: 15),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

    Text(
      "Don't have an account? ",
      style: GoogleFonts.poppins(
        color: Colors.white70,
        fontSize: 13,
      ),
    ),

    GestureDetector(
      onTap: () {
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
        "Create One",
        style: GoogleFonts.poppins(
          color: const Color(0xFFFFFFE0), // Pastel Yellow
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}