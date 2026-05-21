import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'bill_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    String userId = FirebaseAuth.instance.currentUser!.uid;

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

          child: Column(
            children: [

              /// TOP BAR
              Padding(
                padding: const EdgeInsets.all(20),

                child: Row(
                  children: [

                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),

                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "Order History",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),

              /// ORDERS
              Expanded(

                child: StreamBuilder<QuerySnapshot>(

                  stream: FirebaseFirestore.instance
                      .collection("orders")
                      .where("userId", isEqualTo: userId)
                      .orderBy("timestamp", descending: true)
                      .snapshots(),

                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {

                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.cyanAccent,
                        ),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {

                      return Center(
                        child: Text(
                          "No Orders Yet",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    var orders = snapshot.data!.docs;

                    return ListView.builder(

                      itemCount: orders.length,

                      itemBuilder: (context, index) {

                        var order = orders[index];

                        var timestamp = order["timestamp"];

                        String date = "";

                        if (timestamp != null) {
                          date = DateFormat("dd MMM yyyy - hh:mm a")
                              .format(timestamp.toDate());
                        }

                        return GestureDetector(
  onTap: () {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BillScreen(
          cartItems: List<Map<String, dynamic>>.from(order["items"]),
          totalPrice: order["totalPrice"],
          itemCount: order["itemCount"],
          paymentMethod: order["paymentMethod"],
        ),
      ),
    );

  },

  child: Container(

                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),

                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,

                            children: [

                              /// LEFT SIDE
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    "₹${order["totalPrice"]}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "${order["itemCount"]} items • ${order["paymentMethod"]}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    date,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),

                                ],
                              ),

                              /// ICON
                              const Icon(
                                Icons.receipt_long,
                                color: Color(0xFFFFFFE0),
                                size: 28,
                              ),

                            ],
                          ),
                        ));

                      },
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}