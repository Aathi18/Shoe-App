import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shoe_app/pages/theme_provider.dart';

import '../providers/cart_provider.dart';
import 'CartPage.dart';
import 'UserProfilePage.dart';

class HomePage extends StatelessWidget {
  static const appRouteName = "/homepage";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Shoe Store"),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, "ordersPage"),
            child: const Text("My Orders", style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserProfilePage()),
              );
            },
          ),

          Consumer<CartProvider>(
            builder: (context, cart, _) => IconButton(
              icon: badges.Badge(
                badgeContent: Text(
                  cart.itemCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
                child: const Icon(Icons.shopping_cart),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              ),
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "loginPage");
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 👤 Display user info
            if (user != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : null,
                      child: user.photoURL == null
                          ? const Icon(Icons.person, size: 30)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName ?? 'Welcome!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // 👟 Product grid
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('shoes').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No shoes found"));
                  }

                  final shoes = snapshot.data!.docs;

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: shoes.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final shoe = shoes[index];
                      final data = shoe.data() as Map<String, dynamic>;

                      final price = data['price'];
                      final priceText = (price is int || price is double)
                          ? "\$${price.toStringAsFixed(2)}"
                          : "\$0.00";

                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F9FD),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              data['image'] ?? '',
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['name'] ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475269),
                              ),
                            ),
                            Text(
                              data['description'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  priceText,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                                  onPressed: () {
                                    Provider.of<CartProvider>(context, listen: false).addItem(
                                      id: shoe.id,
                                      name: data['name'],
                                      image: data['image'],
                                      price: (data['price'] as num).toDouble(), quantity: null,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("${data['name']} added to cart"),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
