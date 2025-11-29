import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/grid_ui/add_student_page.dart';
import 'package:my_app/grid_ui/course_page.dart';
import 'package:my_app/grid_ui/fees_page.dart';
import 'package:my_app/grid_ui/notice_page.dart';
import 'package:my_app/grid_ui/results_page.dart';
import 'package:my_app/grid_ui/routine_page.dart';
import 'package:my_app/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> images = [
    "assets/imageC1.jpg",
    "assets/imageC2.jpg",
    "assets/imageC3.jpg",
  ];

  // Grid button data
  final List<Map<String, dynamic>> _gridItems = [
    {"icon": Icons.people, "title": "Students", "color": Colors.deepPurple},
    {"icon": Icons.book, "title": "Courses", "color": Colors.orange},
    {"icon": Icons.payment, "title": "Fees", "color": Colors.green},
    {"icon": Icons.bar_chart, "title": "Results", "color": Colors.redAccent},
    {"icon": Icons.schedule, "title": "Routine", "color": Colors.purple},
    {"icon": Icons.notifications, "title": "Notice", "color": Colors.blue},
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Auto-slide every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("School Management System"),
        backgroundColor: Colors.blueAccent,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                ),
              ),
              accountName: Text(
                "School Management",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text("info@school.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/file.jpg"),
                // child: Icon(Icons.school, size: 36, color: Colors.blueAccent),
              ),
            ),

            // Dashboard
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context); // drawer বন্ধ হবে
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
            ),

            // Students
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Students'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddStudentPage()),
                );
              },
            ),

            // Courses
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Courses'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CoursePage()),
                );
              },
            ),

            // Fees
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Fees'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FeesPage()),
                );
              },
            ),

            // Settings
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              // onTap: () {
              //   Navigator.pop(context);
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (_) => const settin()),
              //   );
              // },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------- Carousel ----------
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ---------- Dot Indicator ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  margin: const EdgeInsets.all(4),
                  width: _currentIndex == index ? 12 : 8,
                  height: _currentIndex == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.blueAccent
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: _gridItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final item = _gridItems[index];
                  return GestureDetector(
                    onTap: () {
                      if (item['title'] == "Students") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddStudentPage(),
                          ),
                        );
                      } else if (item['title'] == "Courses") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CoursePage()),
                        );
                      } else if (item['title'] == "Fees") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FeesPage()),
                        );
                      } else if (item['title'] == "Results") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResultsPage(),
                          ),
                        );
                      } else if (item['title'] == "Routine") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RoutinePage(),
                          ),
                        );
                      } else if (item['title'] == "Notice") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NoticePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${item['title']} clicked")),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: item['color'].withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 40, color: item['color']),
                          const SizedBox(height: 12),
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
