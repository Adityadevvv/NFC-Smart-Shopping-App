import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen.dart';
import 'admin/admin_home_screen.dart';
import 'welcome_screen.dart';

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return  WelcomeScreen();
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {

  // 🔄 Loading
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  // ❌ Error
  if (snapshot.hasError) {
    return const Scaffold(
      body: Center(child: Text("Something went wrong")),
    );
  }

  // ❌ No data / user doc missing
  if (!snapshot.hasData || !snapshot.data!.exists) {
    return const HomeScreen(); // default user
  }

  // ✅ Safe data access
  var data = snapshot.data!.data() as Map<String, dynamic>;
  String role = data['role'] ?? "user";

  if (role == "admin") {
    return const AdminHomeScreen();
  } else {
    return const HomeScreen();
  }
},
    );
  }
}