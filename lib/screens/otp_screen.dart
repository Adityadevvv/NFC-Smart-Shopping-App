import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bill_screen.dart';

class OtpScreen extends StatefulWidget {

  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final int itemCount;
  final String paymentMethod;

  const OtpScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.itemCount,
    required this.paymentMethod,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final TextEditingController otpController = TextEditingController();
  late int generatedOtp;

  @override
  void initState() {
    super.initState();
    generatedOtp = 1000 + Random().nextInt(9000);
    print("Generated OTP: $generatedOtp");
  }

  void verifyOtp() async {

    if (otpController.text == generatedOtp.toString()) {

      await FirebaseFirestore.instance
          .collection("orders")
          .add({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "items": widget.cartItems,
        "totalPrice": widget.totalPrice,
        "itemCount": widget.itemCount,
        "paymentMethod": widget.paymentMethod,
        "timestamp": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Successful")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => BillScreen(
            cartItems: widget.cartItems,
            totalPrice: widget.totalPrice,
            itemCount: widget.itemCount,
            paymentMethod: widget.paymentMethod,
          ),
        ),
        (route) => false,
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,

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

          child: LayoutBuilder(
            builder: (context, constraints) {

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),

                  child: IntrinsicHeight(

                    child: Column(
                      children: [

                        /// CENTER CONTENT
                        Expanded(
                          child: Center(

                            child: Padding(
                              padding: const EdgeInsets.all(20),

                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(25),

                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFFFFFFE0),
                                      size: 60,
                                    ),

                                    const SizedBox(height: 20),

                                    Text(
                                      "OTP Verification",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      "Enter the OTP to confirm payment",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    /// DEMO OTP
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Demo OTP: $generatedOtp",
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFFFFFFE0),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 25),

                                    /// OTP INPUT
                                    TextField(
                                      controller: otpController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      textAlign: TextAlign.center,

                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 5,
                                      ),

                                      decoration: InputDecoration(
                                        counterText: "",
                                        hintText: "----",
                                        hintStyle: const TextStyle(
                                          color: Colors.white54,
                                          letterSpacing: 5,
                                        ),
                                        filled: true,
                                        fillColor: Colors.black.withOpacity(0.3),

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    /// BUTTON
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFFFFFE0),
                                          padding: const EdgeInsets.symmetric(vertical: 15),
                                        ),

                                        onPressed: verifyOtp,

                                        child: Text(
                                          "Verify OTP",
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFF008080),
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
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}