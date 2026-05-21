import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
final List<Map<String, dynamic>> cartItems;
final double totalPrice;
final int itemCount;

const CartScreen({
super.key,
required this.cartItems,
required this.totalPrice,
required this.itemCount,
});

@override
State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

late List<Map<String, dynamic>> cartItems;
late double totalPrice;
late int itemCount;
Set<int> selectedIndexes = {};
bool selectionMode = false;

@override
void initState() {
super.initState();


cartItems = List.from(widget.cartItems);
totalPrice = widget.totalPrice;
itemCount = widget.itemCount;


}

void updateItemCount() {
itemCount = cartItems.fold(
0,
(sum, item) => sum + (item["quantity"] as int),
);
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
      child: Column(
        children: [

          /// Top Bar
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),

            child: Row(
              children: [

                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white),

                  onPressed: () {
  Navigator.pop(context, {
    "cartItems": cartItems,
    "totalPrice": totalPrice,
    "itemCount": itemCount,
  });
},
                ),

                const SizedBox(width: 10),

                Text(
                  "Your Cart",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 10),

          /// CART ITEMS
          Expanded(
  child: cartItems.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.remove_shopping_cart,
                size: 70,
                color: Colors.white54,
              ),

              const SizedBox(height: 15),

              Text(
                "Cart is empty!!",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ],
          ),
        )
      : ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {

            var item = cartItems[index];

            return Dismissible(
  key: Key(item["name"]), // unique key

  direction: DismissDirection.endToStart,

  onDismissed: (_) {
    setState(() {

      totalPrice -= item["price"] * item["quantity"];
      cartItems.removeAt(index);
      updateItemCount();

    });
  },

  background: Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    color: Colors.redAccent,
    child: const Icon(Icons.delete, color: Colors.white),
  ),

  child: AnimatedSize(
    duration: const Duration(milliseconds: 300),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    /// ✅ CHECKBOX
    if (selectionMode)
  Checkbox(
    shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(4),
  ),
    value: selectedIndexes.contains(index),
    onChanged: (value) {
      setState(() {
        if (value == true) {
          selectedIndexes.add(index);
        } else {
          selectedIndexes.remove(index);
        }
      });
    },
    activeColor: const Color.fromARGB(255, 0, 255, 21), //checked

  checkColor: const Color.fromARGB(255, 255, 255, 255), // tick color

  side: const BorderSide(
    color: Color(0xFFD0F0C0), // outline color (unchecked)
    width: 2,
  ),
  ),

    const SizedBox(width: 10),

    /// LEFT SIDE
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            item["name"],
            maxLines: 2,
            overflow: TextOverflow.visible,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "₹${item["price"]}",
            style: GoogleFonts.poppins(
              color: Colors.white70,
            ),
          ),

        ],
      ),
    ),

    /// RIGHT SIDE
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Text(
          "Qty: ${item["quantity"]}",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          "₹${item["price"] * item["quantity"]}",
          style: GoogleFonts.poppins(
            color: Color(0xFFFFFFE0),
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    ),

  ],
),
    ),
  ),
);
          },
        ),
),

          /// CHECKOUT PANEL
          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),

            child: Column(
              children: [

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
                      "${cartItems.isEmpty ? 0 : itemCount}",
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
                      "₹${cartItems.isEmpty ? 0 : totalPrice}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 20),
const SizedBox(height: 10),

TextButton(
  onPressed: cartItems.isEmpty ? null : () {
    setState(() {
      selectionMode = !selectionMode;

      if (!selectionMode) {
        selectedIndexes.clear(); // reset when exiting
      }
    });
  },
  child: Text(
    selectionMode ? "Cancel Selection" : "Select Items",
    style: GoogleFonts.poppins(
      color: Color(0xFFFFFFE0),
      fontWeight: FontWeight.w600,
    ),
  ),
),

if (selectionMode && selectedIndexes.isNotEmpty)
  TextButton(
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
          "Delete Selected Items",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        content: Text(
          "Are you sure you want to delete selected items?",
          style: GoogleFonts.poppins(
            color: Colors.white70,
          ),
        ),

        actions: [

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

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {

              setState(() {

                var indexes = selectedIndexes.toList()
                  ..sort((b, a) => a.compareTo(b));

                for (var i in indexes) {
                  totalPrice -= cartItems[i]["price"] * cartItems[i]["quantity"];
                  cartItems.removeAt(i);
                }

                selectedIndexes.clear();
                selectionMode = false;
                updateItemCount();

              });

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
    child: Text(
      "Delete Selected",
      style: GoogleFonts.poppins(
        color: Colors.redAccent,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

TextButton(
  onPressed: cartItems.isEmpty ? null : () {

  showDialog(
    context: context,
    builder: (context) {

      return AlertDialog(
        backgroundColor: const Color(0xFF203A43),

        shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(15),
),

        title: Text(
          "Clear Cart",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        content: Text(
          "Are you sure you want to remove all items from the cart?",
          style: GoogleFonts.poppins(
            color: Colors.white70,
          ),
        ),

        actions: [

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

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),

            onPressed: () {

              setState(() {
                cartItems.clear();
                totalPrice = 0;
                itemCount = 0;
              });

              Navigator.pop(context);

            },

            child: Text(
              "Clear",
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),

        ],
      );

    },
  );

},

  child: Text(
    "Clear Cart",
    style: GoogleFonts.poppins(
      color: Colors.redAccent,
      fontWeight: FontWeight.w600,
    ),
  ),
),

const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFE0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15),
                    ),

                    onPressed: cartItems.isEmpty ? null : () {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CheckoutScreen(
        cartItems: cartItems,
        totalPrice: totalPrice,
        itemCount: itemCount,
      ),
    ),
  );

},

                    child: Text(
                      "Checkout",
                      style: GoogleFonts.poppins(
                        color: Color(0xFF008080),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )

              ],
            ),
          )

        ],
      ),
    ),
  ),
);


}
}
