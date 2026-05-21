import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),

      // 🔹 Floating Add Button (styled)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFFFFE0),
        child: const Icon(Icons.add, color: Color(0xFF008080)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
      ),

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
                      "Products",
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

                // 🔹 Product List
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      var docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No products available",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {

                          var doc = docs[index];
var data = doc.data() as Map<String, dynamic>;



return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProductScreen(
          docId: doc.id,
          data: data,
        ),
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

    child: Row(
      children: [

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                data['name'] ?? "No name",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "₹${(data['price'] ?? 0).toInt()}",
                style: GoogleFonts.poppins(
                  color: Color(0xFFFFFFE0),
                  fontSize: 14,
                  fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
  onTap: () {}, // prevents parent tap

  child: IconButton(
    icon: const Icon(Icons.delete, color: Colors.redAccent),
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
              "Delete Product",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            content: Text(
              "Are you sure you want to delete this product?",
              style: GoogleFonts.poppins(
                color: Colors.white70,
              ),
            ),

            actions: [

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("products")
                      .doc(doc.id)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product deleted")),
                  );

                  Navigator.pop(context);
                },
                child: Text(
                  "Delete",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  ),
),
      ],
    ),
  ),
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