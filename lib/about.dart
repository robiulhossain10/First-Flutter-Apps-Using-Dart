import 'package:flutter/material.dart';

class MyAboutPage extends StatelessWidget {
  const MyAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final iconBgColor = Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About School"),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/imageC1.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(0),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Welcome to Our School Management System",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Our School Management System is designed to help manage students, teachers, courses, fees, and other school activities efficiently. "
                "It provides a modern, easy-to-use interface for both administrators and users, ensuring smooth operation and better communication.",
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: subTextColor,
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
                  _featureCard(
                    Icons.people,
                    "Manage Students",
                    cardColor,
                    iconBgColor,
                    textColor,
                  ),
                  _featureCard(
                    Icons.book,
                    "Manage Courses",
                    cardColor,
                    iconBgColor,
                    textColor,
                  ),
                  _featureCard(
                    Icons.payment,
                    "Fee Management",
                    cardColor,
                    iconBgColor,
                    textColor,
                  ),
                  _featureCard(
                    Icons.schedule,
                    "Routine & Schedule",
                    cardColor,
                    iconBgColor,
                    textColor,
                  ),
                  _featureCard(
                    Icons.notifications,
                    "Notice Board",
                    cardColor,
                    iconBgColor,
                    textColor,
                  ),
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
  Widget _featureCard(
    IconData icon,
    String title,
    Color? cardColor,
    Color iconBgColor,
    Color textColor,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBgColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: textColor),
        onTap: () {
          // handle feature tap here
        },
      ),
    );
  }
}
