import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/major.dart';
import 'major_form_screen.dart';

class MajorListScreen extends StatefulWidget {
  const MajorListScreen({super.key});

  @override
  State<MajorListScreen> createState() => _MajorListScreenState();
}

class _MajorListScreenState extends State<MajorListScreen> {
  List<Major> _majors = [];

  @override
  void initState() {
    super.initState();
    _loadMajors();
  }

  Future<void> _loadMajors() async {
    final data = await DatabaseHelper.instance.getAllMajors();
    setState(() => _majors = data);
  }

  Future<void> _deleteMajor(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Major'),
        content: const Text('Are you sure you want to delete this major?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseHelper.instance.deleteMajor(id);
      _loadMajors();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _majors.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _majors.length,
              itemBuilder: (ctx, i) {
                final m = _majors[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.book, color: Colors.white),
                    ),
                    title: Text(m.nameMajor, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('ID: ${m.idMajor}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => MajorFormScreen(major: m)));
                            _loadMajors();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMajor(m.idMajor!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const MajorFormScreen()));
          _loadMajors();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
