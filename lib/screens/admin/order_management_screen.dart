import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bill_screen.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
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

                // 🔹 Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "Orders",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 Orders List
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("orders")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      var orders = snapshot.data!.docs;

                      if (orders.isEmpty) {
                        return Center(
                          child: Text(
                            "No orders yet",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {

                          var order = orders[index];

                         var data = order.data() as Map<String, dynamic>;

// ✅ SUPPORT totalPrice + total
double total = data.containsKey('totalPrice')
    ? data['totalPrice']
    : (data.containsKey('total') ? data['total'] : 0);

// ✅ SAFE DATE
var date = data.containsKey('timestamp') && data['timestamp'] != null
    ? data['timestamp'].toDate()
    : null;

// ✅ ITEM COUNT
int itemCount = data.containsKey('items')
    ? data['items'].length
    : 0;

                          return GestureDetector(
  onTap: () {

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => BillScreen(
          
          cartItems: List<Map<String, dynamic>>.from(data["items"] ?? []),
          totalPrice: total,
          itemCount: itemCount,
          paymentMethod: data["paymentMethod"] ?? "N/A",
          isAdminView: true,
        ),
        transitionsBuilder: (_, animation, __, child) {

          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;

          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );

  },

  child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // 🔹 Total Price
                                Text(
                                  "₹$total",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                // 🔹 Date
                                Text(
                                  date != null
    ? "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}"
    : "No date",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // 🔹 Items (if stored)
                                if (data.containsKey('items'))
                                  Text(
                                    "Items: $itemCount",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFFFFFFE0),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          )
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}