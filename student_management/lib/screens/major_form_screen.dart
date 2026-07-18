import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/major.dart';

class MajorFormScreen extends StatefulWidget {
  final Major? major;
  const MajorFormScreen({super.key, this.major});

  @override
  State<MajorFormScreen> createState() => _MajorFormScreenState();
}

class _MajorFormScreenState extends State<MajorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.major != null;
    if (_isEdit) _nameCtrl.text = widget.major!.nameMajor;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final major = Major(
      idMajor: widget.major?.idMajor,
      nameMajor: _nameCtrl.text.trim(),
    );

    if (_isEdit) {
      await DatabaseHelper.instance.updateMajor(major);
    } else {
      await DatabaseHelper.instance.insertMajor(major);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Major' : 'Add Major')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Major Name',
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(_isEdit ? 'Update Major' : 'Add Major'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.orange,
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}
