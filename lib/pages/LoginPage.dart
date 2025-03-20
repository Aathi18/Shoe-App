import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical:20 ),
                    child: Image.asset("images/login.png"),
                )
              ],
            )),
      ),
    );
  }
}
