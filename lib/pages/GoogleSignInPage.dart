import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  GoogleSignInAccount? _user;

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? user = await googleSignIn.signIn();

      if (user != null) {
        print("✅ Name: ${user.displayName}");
        print("✅ Email: ${user.email}");
        print("✅ Photo: ${user.photoUrl}");

        setState(() {
          _user = user;
        });
      } else {
        print("❌ Sign-in canceled");
      }
    } catch (e) {
      print("🔥 Sign-in failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-in error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Sign-In Demo"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: _user == null
            ? ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Sign in with Google"),
          onPressed: _signInWithGoogle,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
              _user?.photoUrl != null ? NetworkImage(_user!.photoUrl!) : null,
              child: _user?.photoUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(height: 12),
            Text(
              "Welcome, ${_user!.displayName ?? 'User'}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(_user!.email),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Sign Out"),
              onPressed: () async {
                await GoogleSignIn().signOut();
                setState(() => _user = null);
              },
            ),
          ],
        ),
      ),
    );
  }
}
