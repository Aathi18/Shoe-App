import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_app/pages/HomePage.dart';
import 'package:shoe_app/pages/CartPage.dart';
import 'package:shoe_app/pages/OrdersPage.dart';
import 'package:shoe_app/pages/UserProfilePage.dart';
import 'package:shoe_app/providers/cart_provider.dart';
import 'package:badges/badges.dart' as badges;

class MainBottomNavPage extends StatefulWidget {
  const MainBottomNavPage({super.key});

  @override
  State<MainBottomNavPage> createState() => _MainBottomNavPageState();
}

class _MainBottomNavPageState extends State<MainBottomNavPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
    OrdersPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return Scaffold(
          body: _pages[_selectedIndex],

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.deepPurple, // 🌈 Change color here
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: badges.Badge(
                  showBadge: cart.itemCount > 0,
                  badgeContent: Text(
                    cart.itemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.red,
                  ),
                  child: const Icon(Icons.shopping_cart),
                ),
                label: "Cart",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: "Orders",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
