import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../welcome_screen.dart';
import 'product_management_screen.dart';
import 'order_management_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

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

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10),

                // 🔹 TOP BAR (same style as home)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "Admin Panel",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    IconButton(
  icon: const Icon(Icons.logout, color: Colors.redAccent),
  onPressed: () {

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          backgroundColor: const Color(0xFF203A43),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          title: Text(
            "Logout",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          content: Text(
            "Are you sure you want to logout?",
            style: GoogleFonts.poppins(
              color: Colors.white70,
            ),
          ),

          actions: [

            // ❌ Cancel
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                ),
              ),
            ),

            // ✅ Confirm Logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => WelcomeScreen()),
                  (route) => false,
                );

              },
              child: Text(
                "Logout",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),

          ],
        );

      },
    );

  },
),
                  ],
                ),

                const SizedBox(height: 30),

                // 🔹 DASHBOARD CARDS
                _buildAdminCard(
                  context,
                  "Manage Products",
                  "Add, edit, delete products",
                  Icons.inventory,
                  const ProductManagementScreen(),
                ),

                const SizedBox(height: 20),

                _buildAdminCard(
                  context,
                  "View Orders",
                  "Check all user orders",
                  Icons.receipt_long,
                  const OrderManagementScreen(),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => screen,
    transitionsBuilder: (_, animation, __, child) {

      const begin = Offset(1.0, 0.0); // right → left
      const end = Offset.zero;

      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  ),
);
      },

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),

        child: Row(
          children: [

            Icon(icon, color: Color(0xFFFFFFE0), size: 30),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}