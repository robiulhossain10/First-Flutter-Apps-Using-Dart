import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Result model
class Result {
  String studentName;
  String roll;
  String studentClass;
  String subject;
  double marks;
  String grade;

  Result({
    required this.studentName,
    required this.roll,
    required this.studentClass,
    required this.subject,
    required this.marks,
    required this.grade,
  });

  Map<String, dynamic> toJson() => {
    'studentName': studentName,
    'roll': roll,
    'studentClass': studentClass,
    'subject': subject,
    'marks': marks,
    'grade': grade,
  };

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    studentName: json['studentName'],
    roll: json['roll'],
    studentClass: json['studentClass'],
    subject: json['subject'],
    marks: (json['marks'] as num).toDouble(),
    grade: json['grade'],
  );
}

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  List<Result> _results = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  // Load results from SharedPreferences
  Future<void> _loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('results') ?? [];
    setState(() {
      _results = data.map((e) => Result.fromJson(json.decode(e))).toList();
    });
  }

  // Save results to SharedPreferences
  Future<void> _saveResults() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _results.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('results', data);
  }

  // Show Add / Update Result form
  void _showResultForm({int? index}) {
    if (index != null) {
      final r = _results[index];
      _nameController.text = r.studentName;
      _rollController.text = r.roll;
      _classController.text = r.studentClass;
      _subjectController.text = r.subject;
      _marksController.text = r.marks.toString();
      _gradeController.text = r.grade;
    } else {
      _nameController.clear();
      _rollController.clear();
      _classController.clear();
      _subjectController.clear();
      _marksController.clear();
      _gradeController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? 'Add Result' : 'Update Result'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Student Name'),
                  validator: (v) => v!.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  controller: _rollController,
                  decoration: const InputDecoration(labelText: 'Roll Number'),
                  validator: (v) => v!.isEmpty ? 'Enter roll' : null,
                ),
                TextFormField(
                  controller: _classController,
                  decoration: const InputDecoration(labelText: 'Class'),
                  validator: (v) => v!.isEmpty ? 'Enter class' : null,
                ),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  validator: (v) => v!.isEmpty ? 'Enter subject' : null,
                ),
                TextFormField(
                  controller: _marksController,
                  decoration: const InputDecoration(labelText: 'Marks'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Enter marks' : null,
                ),
                TextFormField(
                  controller: _gradeController,
                  decoration: const InputDecoration(labelText: 'Grade'),
                  validator: (v) => v!.isEmpty ? 'Enter grade' : null,
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
                final result = Result(
                  studentName: _nameController.text.trim(),
                  roll: _rollController.text.trim(),
                  studentClass: _classController.text.trim(),
                  subject: _subjectController.text.trim(),
                  marks: double.tryParse(_marksController.text) ?? 0,
                  grade: _gradeController.text.trim(),
                );

                setState(() {
                  if (index == null) {
                    _results.add(result);
                  } else {
                    _results[index] = result;
                  }
                });

                _saveResults();
                Navigator.pop(context);
              }
            },
            child: Text(index == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete result
  void _deleteResult(int index) {
    setState(() {
      _results.removeAt(index);
    });
    _saveResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showResultForm(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _results.isEmpty
            ? const Center(child: Text('No results added yet'))
            : ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
                  return Card(
                    child: ListTile(
                      title: Text('${result.studentName} (${result.roll})'),
                      subtitle: Text(
                        'Class: ${result.studentClass}\nSubject: ${result.subject}\nMarks: ${result.marks}\nGrade: ${result.grade}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showResultForm(index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteResult(index),
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
