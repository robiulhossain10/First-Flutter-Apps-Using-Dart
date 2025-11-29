import 'package:flutter/material.dart';

class MyContactPage extends StatelessWidget {
  const MyContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'School Contact Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.school, color: Colors.blue),
                title: const Text('Green Valley High School'),
                subtitle: const Text('School Name'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: const Text('123 Main Street, Dhaka, Bangladesh'),
                subtitle: const Text('Address'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text('+880 1234 567890'),
                subtitle: const Text('Phone'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.orange),
                title: const Text('info@greenvalley.edu.bd'),
                subtitle: const Text('Email'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.web, color: Colors.purple),
                title: const Text('www.greenvalley.edu.bd'),
                subtitle: const Text('Website'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'For any inquiries, feel free to contact us. Our administrative team is available from 8:00 AM to 5:00 PM, Saturday to Thursday.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
