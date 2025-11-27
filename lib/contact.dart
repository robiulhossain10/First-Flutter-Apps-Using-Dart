import 'package:flutter/material.dart';

class MyContactPage extends StatelessWidget {
  const MyContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Contact Page',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      );
  }
}