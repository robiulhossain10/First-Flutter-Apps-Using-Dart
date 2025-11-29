import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Student model
class Student {
  String name;
  String roll;
  String studentClass;
  String email;
  String phone;

  Student({
    required this.name,
    required this.roll,
    required this.studentClass,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'roll': roll,
    'studentClass': studentClass,
    'email': email,
    'phone': phone,
  };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    name: json['name'],
    roll: json['roll'],
    studentClass: json['studentClass'],
    email: json['email'],
    phone: json['phone'],
  );
}

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  // Load students from SharedPreferences
  Future<void> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('students') ?? [];
    setState(() {
      _students = data.map((e) => Student.fromJson(json.decode(e))).toList();
    });
  }

  // Save students to SharedPreferences
  Future<void> _saveStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _students.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('students', data);
  }

  // Show Add / Update Student form
  void _showStudentForm({int? index}) {
    if (index != null) {
      final s = _students[index];
      _nameController.text = s.name;
      _rollController.text = s.roll;
      _classController.text = s.studentClass;
      _emailController.text = s.email;
      _phoneController.text = s.phone;
    } else {
      _nameController.clear();
      _rollController.clear();
      _classController.clear();
      _emailController.clear();
      _phoneController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? 'Add Student' : 'Update Student'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => v!.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  controller: _rollController,
                  decoration: const InputDecoration(labelText: 'Roll Number'),
                  validator: (v) => v!.isEmpty ? 'Enter roll number' : null,
                ),
                TextFormField(
                  controller: _classController,
                  decoration: const InputDecoration(labelText: 'Class'),
                  validator: (v) => v!.isEmpty ? 'Enter class' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => v!.isEmpty ? 'Enter email' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (v) => v!.isEmpty ? 'Enter phone' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final student = Student(
                  name: _nameController.text.trim(),
                  roll: _rollController.text.trim(),
                  studentClass: _classController.text.trim(),
                  email: _emailController.text.trim(),
                  phone: _phoneController.text.trim(),
                );

                setState(() {
                  if (index == null) {
                    _students.add(student);
                  } else {
                    _students[index] = student;
                  }
                });

                _saveStudents();
                Navigator.pop(context);
              }
            },
            child: Text(index == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete student
  void _deleteStudent(int index) {
    setState(() {
      _students.removeAt(index);
    });
    _saveStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Management")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showStudentForm(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _students.isEmpty
            ? const Center(child: Text('No students added yet'))
            : ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  return Card(
                    child: ListTile(
                      title: Text('${student.name} (${student.roll})'),
                      subtitle: Text(
                        'Class: ${student.studentClass}\nEmail: ${student.email}\nPhone: ${student.phone}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showStudentForm(index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteStudent(index),
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
