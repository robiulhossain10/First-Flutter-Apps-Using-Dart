import 'package:flutter/material.dart';

class MyAboutPage extends StatelessWidget {
  const MyAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'About Page',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      );
  }
}