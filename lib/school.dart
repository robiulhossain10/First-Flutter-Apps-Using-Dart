import 'package:flutter/material.dart';

class MySchoolPage extends StatelessWidget {
  const MySchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'School Page',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      );
  }
}