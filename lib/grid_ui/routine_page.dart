import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Routine model
class Routine {
  String day;
  String period;
  String subject;
  String teacher;
  String room;

  Routine({
    required this.day,
    required this.period,
    required this.subject,
    required this.teacher,
    required this.room,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'period': period,
    'subject': subject,
    'teacher': teacher,
    'room': room,
  };

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    day: json['day'],
    period: json['period'],
    subject: json['subject'],
    teacher: json['teacher'],
    room: json['room'],
  );
}

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  List<Routine> _routines = [];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  // Load routines from SharedPreferences
  Future<void> _loadRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('routines') ?? [];
    setState(() {
      _routines = data.map((e) => Routine.fromJson(json.decode(e))).toList();
    });
  }

  // Save routines to SharedPreferences
  Future<void> _saveRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _routines.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('routines', data);
  }

  // Show Add / Update Routine form
  void _showRoutineForm({int? index}) {
    if (index != null) {
      final r = _routines[index];
      _dayController.text = r.day;
      _periodController.text = r.period;
      _subjectController.text = r.subject;
      _teacherController.text = r.teacher;
      _roomController.text = r.room;
    } else {
      _dayController.clear();
      _periodController.clear();
      _subjectController.clear();
      _teacherController.clear();
      _roomController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? 'Add Routine' : 'Update Routine'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _dayController,
                  decoration: const InputDecoration(labelText: 'Day'),
                  validator: (v) => v!.isEmpty ? 'Enter day' : null,
                ),
                TextFormField(
                  controller: _periodController,
                  decoration: const InputDecoration(labelText: 'Period'),
                  validator: (v) => v!.isEmpty ? 'Enter period' : null,
                ),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  validator: (v) => v!.isEmpty ? 'Enter subject' : null,
                ),
                TextFormField(
                  controller: _teacherController,
                  decoration: const InputDecoration(labelText: 'Teacher'),
                  validator: (v) => v!.isEmpty ? 'Enter teacher' : null,
                ),
                TextFormField(
                  controller: _roomController,
                  decoration: const InputDecoration(labelText: 'Room'),
                  validator: (v) => v!.isEmpty ? 'Enter room' : null,
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
                final routine = Routine(
                  day: _dayController.text.trim(),
                  period: _periodController.text.trim(),
                  subject: _subjectController.text.trim(),
                  teacher: _teacherController.text.trim(),
                  room: _roomController.text.trim(),
                );

                setState(() {
                  if (index == null) {
                    _routines.add(routine);
                  } else {
                    _routines[index] = routine;
                  }
                });

                _saveRoutines();
                Navigator.pop(context);
              }
            },
            child: Text(index == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete routine
  void _deleteRoutine(int index) {
    setState(() {
      _routines.removeAt(index);
    });
    _saveRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Routine")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showRoutineForm(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _routines.isEmpty
            ? const Center(child: Text('No routines added yet'))
            : ListView.builder(
                itemCount: _routines.length,
                itemBuilder: (context, index) {
                  final routine = _routines[index];
                  return Card(
                    child: ListTile(
                      title: Text('${routine.day} - ${routine.period}'),
                      subtitle: Text(
                        'Subject: ${routine.subject}\nTeacher: ${routine.teacher}\nRoom: ${routine.room}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showRoutineForm(index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteRoutine(index),
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
