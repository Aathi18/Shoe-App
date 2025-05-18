import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:shoe_app/pages/CartPage.dart';
import 'package:shoe_app/pages/HomePage.dart';
import 'package:shoe_app/pages/LoginPage.dart';
import 'package:shoe_app/pages/OrdersPage.dart';
import 'package:shoe_app/pages/SignupPage.dart';
import 'package:shoe_app/pages/itemPage.dart';
import 'package:shoe_app/pages/GoogleSignInPage.dart'; // ✅ Import GoogleSignInPage

import 'package:shoe_app/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCTW_u-SOEpvLiWSS6uaY7czERwPpblJ2o",
      appId: "1:662291047715:web:684c76aee3640ce480d896",
      messagingSenderId: "662291047715",
      projectId: "shoe-store-app-e9350",
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFCEDDEE),
        primarySwatch: Colors.blue,
      ),
      routes: {
        "loginPage": (context) => const LoginPage(),
        "signupPage": (context) => const SignupPage(),
        "cartPage": (context) => const CartPage(),
        "ordersPage": (context) => const OrdersPage(),
        "itemPage": (context) => const Itempage(),
        "googleSignInPage": (context) => const GoogleSignInPage(), // ✅ Add route
      },
      // ✅ Automatically navigate based on login state
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage(); // Could replace with GoogleSignInPage() for testing
          }
        },
      ),
    );
  }
}
