import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shoe_app/pages/AddShoePage.dart';
import 'package:shoe_app/pages/theme_provider.dart';

import 'firebase_options.dart';
import 'pages/HomePage.dart';
import 'pages/LoginPage.dart';
import 'pages/SignupPage.dart';
import 'pages/CartPage.dart';
import 'pages/OrdersPage.dart';
import 'pages/itemPage.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart'; // ✅ ThemeProvider here

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ✅ Added ThemeProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>( // ✅ Wrap with Consumer
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Shoe Store',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.currentTheme, // ✅ Get from provider

          routes: {
            "loginPage": (context) => const LoginPage(),
            "signupPage": (context) => const SignupPage(),
            "cartPage": (context) => const CartPage(),
            "ordersPage": (context) => const OrdersPage(),
            "itemPage": (context) => const Itempage(),
            "addShoePage": (context) => const AddShoePage(),
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
      },
    );
  }
}
