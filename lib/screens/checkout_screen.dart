import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_screen.dart';

class CheckoutScreen extends StatefulWidget {

  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final int itemCount;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.itemCount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  String paymentMethod = "UPI";

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
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                Text(
                  "Checkout",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// BILL CONTAINER
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Column(
                    children: [

                      /// ITEMS
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.cartItems.length,

                        itemBuilder: (context, index){

                          var item = widget.cartItems[index];

                          return Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    /// LEFT → NAME
    Expanded(
      child: Text(
        item["name"],
        maxLines: 2,
        overflow: TextOverflow.visible,
        style: GoogleFonts.poppins(
          color: Colors.white,
        ),
      ),
    ),

    const SizedBox(width: 10),

    /// RIGHT → QTY + PRICE
    Text(
      "${item["quantity"]} x ₹${item["price"]}",
      style: GoogleFonts.poppins(
        color: Colors.white70,
      ),
    ),

  ],
                          );
                        },
                      ),

                      const Divider(color: Colors.white38),

                      /// TOTAL
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            "Total Items",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                            ),
                          ),

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
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            "Total Price",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                            ),
                          ),

                          Text(
                            "₹${widget.totalPrice}",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// PAYMENT METHOD
                Text(
                  "Payment Method",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                RadioListTile(
  value: "UPI",
  groupValue: paymentMethod,
  title: Text(
    "UPI",
    style: GoogleFonts.poppins(color: Colors.white),
  ),
  activeColor: Color(0xFFFFFFE0),
  onChanged: (value){
    setState(() {
      paymentMethod = value!;
    });
  },
),

                RadioListTile(
  value: "Card",
  groupValue: paymentMethod,
  title: Text(
    "Card",
    style: GoogleFonts.poppins(color: Colors.white),
  ),
  activeColor: Color(0xFFFFFFE0),
  onChanged: (value){
    setState(() {
      paymentMethod = value!;
    });
  },
),

                RadioListTile(
  value: "Wallet",
  groupValue: paymentMethod,
  title: Text(
    "Smart Cart Wallet",
    style: GoogleFonts.poppins(color: Colors.white),
  ),
  activeColor: Color(0xFFFFFFE0),
  onChanged: (value){
    setState(() {
      paymentMethod = value!;
    });
  },
),

                const Spacer(),

                /// VERIFY BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFE0),
                      padding:
                          const EdgeInsets.symmetric(vertical: 15),
                    ),

                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OtpScreen(
                            cartItems: widget.cartItems,
                            totalPrice: widget.totalPrice,
                            itemCount: widget.itemCount,
                            paymentMethod: paymentMethod,
                          ),
                        ),
                      );

                    },

                    child: const Text(
                      "Verify Payment",
                      style: TextStyle(
                        color: Color(0xFF008080),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}