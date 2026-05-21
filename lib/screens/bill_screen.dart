import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillScreen extends StatefulWidget {

  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final int itemCount;
  final String paymentMethod;
  final bool isAdminView;

  const BillScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.itemCount,
    required this.paymentMethod,
    this.isAdminView = false,
  });

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {

  String username = "User";
  String billNumber = "";
  
  Future<void> generatePdf() async {
  final pdf = pw.Document();

  String date =
      DateFormat("dd MMM yyyy - hh:mm a").format(DateTime.now());

  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(24),
      build: (pw.Context context) {

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            /// HEADER
            pw.Center(
              child: pw.Text(
                "NFC SMART CART",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 10),
            pw.Divider(),

            /// BILL INFO
            pw.Text("Bill No: $billNumber"),
            pw.Text("Customer: $username"),
            pw.Text("Date: $date"),
            pw.Text("Payment: ${widget.paymentMethod}"),

            pw.SizedBox(height: 15),
            pw.Divider(),

            /// TABLE HEADER
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Item", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("Qty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("Price", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("Total", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),

            pw.Divider(),

            /// ITEMS
            ...widget.cartItems.map((item) {

              double price = (item["price"] as num).toDouble();
              int qty = (item["quantity"] as num).toInt();
              double total = price * qty;

              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [

                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(item["name"].toString()),
                    ),

                    pw.Expanded(
                      child: pw.Text(
                        "$qty",
                        textAlign: pw.TextAlign.center,
                      ),
                    ),

                    pw.Expanded(
                      child: pw.Text(
                        "Rs. ${price.toStringAsFixed(2)}",
                        textAlign: pw.TextAlign.center,
                      ),
                    ),

                    pw.Expanded(
                      child: pw.Text(
                        "Rs. ${total.toStringAsFixed(2)}",
                        textAlign: pw.TextAlign.right,
                      ),
                    ),

                  ],
                ),
              );

            }).toList(),

            pw.Divider(),

            /// TOTAL
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Total Items"),
                pw.Text("${widget.itemCount}"),
              ],
            ),

            pw.SizedBox(height: 5),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [

                pw.Text(
                  "Grand Total",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.Text(
                  "Rs. ${(widget.totalPrice).toStringAsFixed(2)}",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

              ],
            ),

            pw.SizedBox(height: 20),

            /// FOOTER
            pw.Center(
              child: pw.Text(
                "Thank you for shopping, Visit Again!!!",
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),

          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

  @override
  void initState() {
    super.initState();
    generateBillNumber();
    fetchUser();
  }

  void generateBillNumber() {
    billNumber = "ECA${1000 + Random().nextInt(9000)}";
  }

  Future<void> fetchUser() async {

    var user = FirebaseAuth.instance.currentUser;

    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        username = doc.data()!["name"];
      });
    }
  }

  @override
  @override
Widget build(BuildContext context) {

  String date =
      DateFormat("dd MMM yyyy - hh:mm a").format(DateTime.now());

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
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              /// ✅ HEADER (CENTERED)
              Center(
                child: Column(
                  children: [

                    const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 80,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "NFC Smart Cart",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Bill No: $billNumber",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),

                    Text(
                      "Customer: $username",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),

                    Text(
                      "Date: $date",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Divider(color: Colors.white38),

              /// ✅ ITEM LIST
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {

                    var item = widget.cartItems[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// LEFT SIDE
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  item["name"],
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "Qty: ${item["quantity"]}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),

                              ],
                            ),
                          ),

                          /// RIGHT SIDE (PRICE)
                          Text(
                            "₹${item["price"] * item["quantity"]}",
                            style: GoogleFonts.poppins(
                              color: Color(0xFFFFFFE0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                        ],
                      ),
                    );
                  },
                ),
              ),

              const Divider(color: Colors.white38),

              /// ✅ SUMMARY (RIGHT ALIGNED VALUES)
              Row(
                children: [

                  Text(
                    "Items",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "${widget.itemCount}",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  Text(
                    "Total",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "₹${widget.totalPrice}",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                "Payment Method: ${widget.paymentMethod}",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  "Payment Successful ✅",
                  style: GoogleFonts.poppins(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ✅ BUTTONS (POLISHED)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: generatePdf,

                  child: Text(
                    "Download Bill (PDF)",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

SizedBox(
  width: double.infinity,
  child: ElevatedButton(

    style: ElevatedButton.styleFrom(
      backgroundColor: widget.isAdminView
          ? Color(0xFFFFFFE0)
          : Color(0xFFFFFFE0),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),

    onPressed: () {
      if (widget.isAdminView) {
        Navigator.pop(context); // 🔥 BACK
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    },

    child: Text(
      widget.isAdminView ? "Back" : "Back to Home",
      style: GoogleFonts.poppins(
        color: widget.isAdminView ? Color(0xFF008080) : Color(0xFF008080),
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
  );
}
}