import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/cart_provider.dart';
import 'CartPage.dart';
import 'ShoeDetailsPage.dart';
import 'package:shoe_app/pages/theme_provider.dart';

class HomePage extends StatefulWidget {
  static const appRouteName = "/homepage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            Image.asset('images/4.png', height: 50),
            const SizedBox(width: 8),
            const Text("Shoe Store"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: "Add Shoe",
            onPressed: () => Navigator.pushNamed(context, "addShoePage"),
          ),
          IconButton(
            icon: const Icon(Icons.dashboard, size: 28, color: Colors.white),
            tooltip: "Admin Dashboard",
            onPressed: () => Navigator.pushNamed(context, "adminDashboardPage"),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => themeProvider.toggleTheme(),
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
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {
                  _searchQuery = value.toLowerCase();
                }),
                decoration: InputDecoration(
                  hintText: 'Search shoes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // 👤 User info + Cart Badge
            if (user != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : null,
                      child: user.photoURL == null
                          ? const Icon(Icons.person, size: 28)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.displayName ?? 'Welcome!',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(user.email ?? '',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                    const Spacer(),
                    Consumer<CartProvider>(
                      builder: (context, cart, _) => badges.Badge(
                        badgeContent: Text(
                          cart.itemCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
                        child: IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CartPage()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 🛍️ Shoe Grid
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

                  final allShoes = snapshot.data!.docs;
                  final filteredShoes = allShoes.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name']?.toString().toLowerCase() ?? '';
                    return name.contains(_searchQuery);
                  }).toList();

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredShoes.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final shoe = filteredShoes[index];
                      final data = shoe.data() as Map<String, dynamic>;

                      final price = data['price'];
                      final priceText = (price is int || price is double)
                          ? "\$${price.toStringAsFixed(2)}"
                          : "\$0.00";
                      final rating = (data['rating'] ?? 4.0).toDouble();

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShoeDetailsPage(shoeId: shoe.id, shoeData: data),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F9FD),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.shade300, blurRadius: 4)
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                data['image'] ?? '',
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                data['name'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475269),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                data['description'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              RatingBarIndicator(
                                rating: rating,
                                itemCount: 5,
                                itemSize: 16,
                                unratedColor: Colors.grey.shade300,
                                itemBuilder: (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    priceText,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 14,
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
                                        price: (data['price'] as num).toDouble(),
                                        quantity: 1,
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
