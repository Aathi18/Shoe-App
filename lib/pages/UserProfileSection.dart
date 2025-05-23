import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text("Not signed in."),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ✅ Profile Picture
        CircleAvatar(
          radius: 40,
          backgroundImage:
          user.photoURL != null ? NetworkImage(user.photoURL!) : null,
          child: user.photoURL == null
              ? const Icon(Icons.person, size: 40)
              : null,
        ),
        const SizedBox(height: 12),

        // ✅ Welcome Text
        Text(
          "Welcome, ${user.displayName ?? 'User'}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        // ✅ Email
        Text(
          user.email ?? '',
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
