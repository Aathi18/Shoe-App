import 'package:flutter/material.dart';

class Itempage extends StatelessWidget {
  const Itempage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(15))
          ],
        ),
      )),
    );
  }
}
