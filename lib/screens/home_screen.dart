import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'cart_screen.dart';
import 'welcome_screen.dart';
import 'order_history_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> cartItems = [];

  double totalPrice = 0;
  int itemCount = 0;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  bool isScanning = false;
  bool showViewCart = false;

  void updateItemCount() {
  itemCount = cartItems.fold(
    0,
    (sum, item) => sum + (item["quantity"] as int),
  );
}

  Future<String> getLocation() async {

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    return "Location disabled";
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude);

  return placemarks.first.locality ?? "Unknown location";
}
  
Future<void> startNfcScan() async {
  try {

    print("Scanning...");

    NFCTag tag = await FlutterNfcKit.poll(
      timeout: const Duration(seconds: 20),
    );

    String tagId = tag.id;

    print("TAG ID: $tagId");

    var product = await FirebaseFirestore.instance
        .collection("products")
        .doc(tagId)
        .get();

    if (product.exists) {

      var data = product.data();

      print("Product: ${data!['name']}");
      print("Price: ₹${data['price']}");

      setState(() {

       bool found = false;

for (var item in cartItems) {
  if (item["name"] == data["name"]) {

    item["quantity"]++;

    totalPrice += item["price"];

    found = true;

    break;
  }
}

if (!found) {

  cartItems.insert(0, {
    "name": data["name"],
    "price": data["price"],
    "quantity": 1,
  });

  _listKey.currentState?.insertItem(0);

  totalPrice += data["price"];
}

updateItemCount();

  });

}

    await Future.delayed(const Duration(seconds: 2));

    await FlutterNfcKit.finish();

  } catch (e) {
    print("NFC Error: $e");
  }
}
void startAutoScan() async {

  setState(() {
  isScanning = true;
  showViewCart = false;
});

  while (isScanning && mounted) {

    await startNfcScan();

  }

}
void stopScanning() {

  setState(() {
  isScanning = false;
  showViewCart = true;
});

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("NFC scanning stopped"),
      duration: Duration(seconds: 2),
    ),
  );

}
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
  child: Container(
    width: double.infinity,
    constraints: BoxConstraints(
      minHeight: MediaQuery.of(context).size.height,
    ),

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

                // 🔹 TOP SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // User Info
                    Row(
                      children: [

                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          FutureBuilder<DocumentSnapshot>(
  future: FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get(),
  builder: (context, snapshot) {

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text(
        "Hello...",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }

    if (!snapshot.hasData || !snapshot.data!.exists) {
      return Text(
        "Hello User",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }

    var data = snapshot.data!.data() as Map<String, dynamic>;
    String username = data['name'] ?? "User";

    return Text(
      "Hello, $username",
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  },
),
                            Text(
                              "Welcome back",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Icons
                    Row(
                      children: [

                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF203A43),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              "Settings",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),
            ListTile(
  leading: const Icon(Icons.history, color: Colors.white),
  title: Text(
    "Order History",
    style: GoogleFonts.poppins(color: Colors.white),
  ),
  onTap: () {

    Navigator.pop(context); // close settings sheet

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OrderHistoryScreen(),
      ),
    );

  },
),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                "Logout",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: () {

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

          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                color: Colors.white70,
              ),
            ),
          ),

          TextButton(
            onPressed: () async {

  Navigator.pop(context); // close dialog
  Navigator.pop(context); // 🔥 close bottom sheet

  await FirebaseAuth.instance.signOut();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => WelcomeScreen()),
    (route) => false,
  );

},
            child: Text(
              "Logout",
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
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
      );

    },
  );
},
                        ),

                        IconButton(
  icon: const Icon(
    Icons.shopping_cart,
    color: Colors.white,
  ),
  onPressed: () async {

    final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CartScreen(
      cartItems: cartItems,
      totalPrice: totalPrice,
      itemCount: itemCount,
    ),
  ),
);

if (result != null) {
  setState(() {
    cartItems = List<Map<String, dynamic>>.from(result["cartItems"]);
    totalPrice = result["totalPrice"];
    itemCount = result["itemCount"];
  });
}

  },
),

                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 🔹 Store Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFFFFFE0),
                      size: 18,
                    ),

                    const SizedBox(width: 5),

                    FutureBuilder<String>(
  future: getLocation(),
  builder: (context, snapshot) {

    if (!snapshot.hasData) {
      return Text(
        "Getting location...",
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 14,
        ),
      );
    }

    return Text(
      snapshot.data!,
      style: GoogleFonts.poppins(
        color: Colors.white70,
        fontSize: 14,
      ),
    );
  },
),
                  ],
                ),
SizedBox(height: 20),

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [

      Column(
        children: [
          Text(
            "Total Price",
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "₹$totalPrice",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      Container(
        height: 40,
        width: 1,
        color: Colors.white30,
      ),

      Column(
        children: [
          Text(
            "Items",
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "$itemCount",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

    ],
  ),
),
                const SizedBox(height: 40),

                // 🔹 NFC Scan Button (your existing button)
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFE0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    onPressed: () {

  if (isScanning) {
    stopScanning();
  } 

  else {
    startAutoScan();

  }

},
                    
                    child: Row(
  mainAxisSize: MainAxisSize.min,
  children: [

    if (isScanning)
      const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.black,
        ),
      ),

    if (isScanning) const SizedBox(width: 10),

    Text(
      isScanning ? "Stop Scanning" : "Start NFC Scan",
      style: GoogleFonts.poppins(
        color: Color(0xFF008080),
        fontWeight: FontWeight.w600,
      ),
    ),

  ],
),
                  ),
                ),
                const SizedBox(height: 30),
                

Text(
  "Recent Items",
  style: GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 10),

cartItems.isEmpty
    ? Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [

              

              const SizedBox(height: 10),

              Text(
                "No items scanned yet",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Tap 'Start NFC Scan' to begin shopping",
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),

            ],
          ),
        ),
      )
    : AnimatedList(
        key: _listKey,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        initialItemCount: cartItems.length,
        itemBuilder: (context, index, animation) {

          var item = cartItems[index];

          return SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: Card(
              color: Colors.white.withOpacity(0.1),
              child: ListTile(
                title: Text(
                  item["name"],
                  style: GoogleFonts.poppins(color: Colors.white),
                ),

                subtitle: Text(
                  "Subtotal: ₹${item["price"] * item["quantity"]}",
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),

                trailing: Text(
                  "${item["quantity"]} x ₹${item["price"]}",
                  style: GoogleFonts.poppins(
                    color: Color(0xFFFFFFE0),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );

        },
      ),
const SizedBox(height: 20),

AnimatedSlide(
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeOut,
  offset: (showViewCart && cartItems.isNotEmpty) ? const Offset(0, 0) : const Offset(0, 0.5),

  child: AnimatedOpacity(
    duration: const Duration(milliseconds: 400),
    opacity: (showViewCart && cartItems.isNotEmpty) ? 1 : 0,

    child: Center(
      child: TextButton.icon(

        onPressed: () async {

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CartScreen(
        cartItems: cartItems,
        totalPrice: totalPrice,
        itemCount: itemCount,
      ),
    ),
  );

  if (result != null) {
    setState(() {
      cartItems = List<Map<String, dynamic>>.from(result["cartItems"]);
      totalPrice = result["totalPrice"];
      itemCount = result["itemCount"];
    });
  }

},

        icon: const Icon(
          Icons.arrow_forward,
          color: Color(0xFFFFFFE0),
        ),

        label: Text(
          "View Cart",
          style: GoogleFonts.poppins(
            color: Color(0xFFFFFFE0),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

      ),
    ),
  ),
),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
