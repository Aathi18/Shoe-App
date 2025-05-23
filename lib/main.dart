import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shoe_app/pages/theme_provider.dart';

import 'firebase_options.dart';
import 'pages/HomePage.dart';
import 'pages/LoginPage.dart';
import 'pages/SignupPage.dart';
import 'pages/CartPage.dart';
import 'pages/OrdersPage.dart';
import 'pages/itemPage.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // <-- NEW
      ],
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
        HomePage.appRouteName: (context) => const HomePage(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
