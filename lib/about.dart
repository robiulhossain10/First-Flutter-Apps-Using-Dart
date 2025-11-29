import 'package:flutter/material.dart';

class MyAboutPage extends StatelessWidget {
  const MyAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About School"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                    "assets/imageC1.jpg",
                  ), // add your image in assets
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(0),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Welcome to Our School Management System",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Our School Management System is designed to help manage students, teachers, courses, fees, and other school activities efficiently. "
                "It provides a modern, easy-to-use interface for both administrators and users, ensuring smooth operation and better communication.",
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 24),

            // Features Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _featureCard(Icons.people, "Manage Students"),
                  _featureCard(Icons.book, "Manage Courses"),
                  _featureCard(Icons.payment, "Fee Management"),
                  _featureCard(Icons.schedule, "Routine & Schedule"),
                  _featureCard(Icons.notifications, "Notice Board"),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Feature Card Widget
  Widget _featureCard(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // You can handle feature tap here
        },
      ),
    );
  }
}
