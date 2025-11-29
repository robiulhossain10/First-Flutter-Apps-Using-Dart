import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Fee model
class Fee {
  String studentName;
  String roll;
  String studentClass;
  double amount;
  bool isPaid;

  Fee({
    required this.studentName,
    required this.roll,
    required this.studentClass,
    required this.amount,
    required this.isPaid,
  });

  Map<String, dynamic> toJson() => {
    'studentName': studentName,
    'roll': roll,
    'studentClass': studentClass,
    'amount': amount,
    'isPaid': isPaid,
  };

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
    studentName: json['studentName'],
    roll: json['roll'],
    studentClass: json['studentClass'],
    amount: (json['amount'] as num).toDouble(),
    isPaid: json['isPaid'],
  );
}

class FeesPage extends StatefulWidget {
  const FeesPage({super.key});

  @override
  State<FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isPaid = false;

  List<Fee> _fees = [];

  @override
  void initState() {
    super.initState();
    _loadFees();
  }

  // Load fees from SharedPreferences
  Future<void> _loadFees() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('fees') ?? [];
    setState(() {
      _fees = data.map((e) => Fee.fromJson(json.decode(e))).toList();
    });
  }

  // Save fees to SharedPreferences
  Future<void> _saveFees() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _fees.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('fees', data);
  }

  // Show Add / Update Fee form
  void _showFeeForm({int? index}) {
    if (index != null) {
      final f = _fees[index];
      _nameController.text = f.studentName;
      _rollController.text = f.roll;
      _classController.text = f.studentClass;
      _amountController.text = f.amount.toString();
      _isPaid = f.isPaid;
    } else {
      _nameController.clear();
      _rollController.clear();
      _classController.clear();
      _amountController.clear();
      _isPaid = false;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? 'Add Fee' : 'Update Fee'),
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
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Fee Amount'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Enter amount' : null,
                ),
                Row(
                  children: [
                    const Text('Paid:'),
                    Checkbox(
                      value: _isPaid,
                      onChanged: (val) {
                        setState(() {
                          _isPaid = val ?? false;
                        });
                      },
                    ),
                  ],
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
                final fee = Fee(
                  studentName: _nameController.text.trim(),
                  roll: _rollController.text.trim(),
                  studentClass: _classController.text.trim(),
                  amount: double.tryParse(_amountController.text) ?? 0,
                  isPaid: _isPaid,
                );

                setState(() {
                  if (index == null) {
                    _fees.add(fee);
                  } else {
                    _fees[index] = fee;
                  }
                });

                _saveFees();
                Navigator.pop(context);
              }
            },
            child: Text(index == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete fee
  void _deleteFee(int index) {
    setState(() {
      _fees.removeAt(index);
    });
    _saveFees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fees Management")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showFeeForm(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _fees.isEmpty
            ? const Center(child: Text('No fees added yet'))
            : ListView.builder(
                itemCount: _fees.length,
                itemBuilder: (context, index) {
                  final fee = _fees[index];
                  return Card(
                    child: ListTile(
                      title: Text('${fee.studentName} (${fee.roll})'),
                      subtitle: Text(
                        'Class: ${fee.studentClass}\nAmount: ${fee.amount}\nPaid: ${fee.isPaid ? "Yes" : "No"}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showFeeForm(index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteFee(index),
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
