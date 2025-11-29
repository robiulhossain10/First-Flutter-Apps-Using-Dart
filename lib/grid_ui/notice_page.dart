import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Notice model
class Notice {
  String title;
  String description;
  String date; // e.g. "2025-11-29"

  Notice({required this.title, required this.description, required this.date});

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'date': date,
  };

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    title: json['title'],
    description: json['description'],
    date: json['date'],
  );
}

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<Notice> _notices = [];

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  // Load notices from SharedPreferences
  Future<void> _loadNotices() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('notices') ?? [];
    setState(() {
      _notices = data.map((e) => Notice.fromJson(json.decode(e))).toList();
    });
  }

  // Save notices to SharedPreferences
  Future<void> _saveNotices() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _notices.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('notices', data);
  }

  // Show Add / Update Notice form
  void _showNoticeForm({int? index}) {
    if (index != null) {
      final n = _notices[index];
      _titleController.text = n.title;
      _descController.text = n.description;
      _dateController.text = n.date;
    } else {
      _titleController.clear();
      _descController.clear();
      _dateController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? 'Add Notice' : 'Update Notice'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) => v!.isEmpty ? 'Enter title' : null,
                ),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (v) => v!.isEmpty ? 'Enter description' : null,
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date (YYYY-MM-DD)',
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter date' : null,
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
                final notice = Notice(
                  title: _titleController.text.trim(),
                  description: _descController.text.trim(),
                  date: _dateController.text.trim(),
                );

                setState(() {
                  if (index == null) {
                    _notices.add(notice);
                  } else {
                    _notices[index] = notice;
                  }
                });

                _saveNotices();
                Navigator.pop(context);
              }
            },
            child: Text(index == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete notice
  void _deleteNotice(int index) {
    setState(() {
      _notices.removeAt(index);
    });
    _saveNotices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notice Board")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showNoticeForm(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _notices.isEmpty
            ? const Center(child: Text('No notices added yet'))
            : ListView.builder(
                itemCount: _notices.length,
                itemBuilder: (context, index) {
                  final notice = _notices[index];
                  return Card(
                    child: ListTile(
                      title: Text(notice.title),
                      subtitle: Text(
                        'Date: ${notice.date}\n${notice.description}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showNoticeForm(index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNotice(index),
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
