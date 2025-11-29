import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Course model
class Course {
  String name;
  String code;
  String instructor;
  String duration;

  Course({
    required this.name,
    required this.code,
    required this.instructor,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'instructor': instructor,
    'duration': duration,
  };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    name: json['name'],
    code: json['code'],
    instructor: json['instructor'],
    duration: json['duration'],
  );
}

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  // Load courses from SharedPreferences
  Future<void> _loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('courses') ?? [];
    setState(() {
      _courses = data.map((e) => Course.fromJson(json.decode(e))).toList();
    });
  }

  // Save courses to SharedPreferences
  Future<void> _saveCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _courses.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('courses', data);
  }

  // Show Add / Update Course form
  void _showCourseForm({int? index}) {
    if (index != null) {
      final c = _courses[index];
      _nameController.text = c.name;
      _codeController.text = c.code;
      _instructorController.text = c.instructor;
      _durationController.text = c.duration;
    } else {
      _nameController.clear();
      _codeController.clear();
      _instructorController.clear();
      _durationController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? 'Add Course' : 'Update Course'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                  validator: (v) => v!.isEmpty ? 'Enter course name' : null,
                ),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Course Code'),
                  validator: (v) => v!.isEmpty ? 'Enter course code' : null,
                ),
                TextFormField(
                  controller: _instructorController,
                  decoration: const InputDecoration(labelText: 'Instructor'),
                  validator: (v) => v!.isEmpty ? 'Enter instructor' : null,
                ),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Duration'),
                  validator: (v) => v!.isEmpty ? 'Enter duration' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final course = Course(
                  name: _nameController.text.trim(),
                  code: _codeController.text.trim(),
                  instructor: _instructorController.text.trim(),
                  duration: _durationController.text.trim(),
                );

                setState(() {
                  if (index == null) {
                    _courses.add(course);
                  } else {
                    _courses[index] = course;
                  }
                });

                _saveCourses();
                Navigator.pop(context);
              }
            },
            child: Text(index == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete course
  void _deleteCourse(int index) {
    setState(() {
      _courses.removeAt(index);
    });
    _saveCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showCourseForm(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _courses.isEmpty
            ? const Center(child: Text('No courses added yet'))
            : ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return Card(
                    child: ListTile(
                      title: Text('${course.name} (${course.code})'),
                      subtitle: Text(
                        'Instructor: ${course.instructor}\nDuration: ${course.duration}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showCourseForm(index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCourse(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
