import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/student.dart';
import '../models/major.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;
  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  String _gender = 'Male';
  int? _selectedMajorId;
  List<Major> _majors = [];
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.student != null;
    if (_isEdit) {
      final s = widget.student!;
      _nameCtrl.text = s.name;
      _emailCtrl.text = s.email;
      _addressCtrl.text = s.address;
      _phoneCtrl.text = s.phone;
      _dateCtrl.text = s.date;
      _gender = s.gender;
      _selectedMajorId = s.idMajor;
    }
    _loadMajors();
  }

  Future<void> _loadMajors() async {
    final majors = await DatabaseHelper.instance.getAllMajors();
    setState(() {
      _majors = majors;
      if (_selectedMajorId == null && majors.isNotEmpty) {
        _selectedMajorId = majors.first.idMajor;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dateCtrl.text = picked.toIso8601String().substring(0, 10);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMajorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a major')));
      return;
    }

    final student = Student(
      id: widget.student?.id,
      name: _nameCtrl.text.trim(),
      date: _dateCtrl.text.trim(),
      gender: _gender,
      email: _emailCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      idMajor: _selectedMajorId!,
    );

    if (_isEdit) {
      await DatabaseHelper.instance.updateStudent(student);
    } else {
      await DatabaseHelper.instance.insertStudent(student);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Student' : 'Add Student')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField('Full Name', _nameCtrl, Icons.person),
              const SizedBox(height: 12),
              _buildField('Email', _emailCtrl, Icons.email, keyboard: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildField('Phone', _phoneCtrl, Icons.phone, keyboard: TextInputType.phone),
              const SizedBox(height: 12),
              _buildField('Address', _addressCtrl, Icons.location_on),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: _pickDate,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder(), prefixIcon: Icon(Icons.wc)),
                items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _gender = v!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedMajorId,
                decoration: const InputDecoration(labelText: 'Major', border: OutlineInputBorder(), prefixIcon: Icon(Icons.book)),
                items: _majors.map((m) => DropdownMenuItem(value: m.idMajor, child: Text(m.nameMajor))).toList(),
                onChanged: (v) => setState(() => _selectedMajorId = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(_isEdit ? 'Update Student' : 'Add Student'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildField(String label, TextEditingController ctrl, IconData icon, {TextInputType? keyboard}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder()),
      validator: (v) => v!.trim().isEmpty ? 'Required' : null,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }
}
