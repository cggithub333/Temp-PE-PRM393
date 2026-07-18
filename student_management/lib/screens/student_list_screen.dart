import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/student.dart';
import '../models/major.dart';
import 'student_form_screen.dart';
import 'map_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final data = await DatabaseHelper.instance.getAllStudentsWithMajor();
    setState(() => _students = data);
  }

  Future<void> _deleteStudent(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseHelper.instance.deleteStudent(id);
      _loadStudents();
    }
  }

  void _showStudentDetails(Map<String, dynamic> s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Student Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow(Icons.badge, 'Name', s['name']),
              _detailRow(Icons.book, 'Major', s['nameMajor'] ?? 'N/A'),
              _detailRow(Icons.email, 'Email', s['email']),
              _detailRow(Icons.phone, 'Phone', s['Phone']),
              _detailRow(Icons.wc, 'Gender', s['gender']),
              _detailRow(Icons.calendar_today, 'DOB', s['date']),
              _detailRow(Icons.location_on, 'Address', s['Address']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _students.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _students.length,
              itemBuilder: (ctx, i) {
                final s = _students[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(s['name'][0], style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Major: ${s['nameMajor'] ?? 'N/A'}'),
                    onTap: () => _showStudentDetails(s),
                    trailing: PopupMenuButton(
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'details', child: Row(children: [Icon(Icons.info, size: 18), SizedBox(width: 8), Text('Details')])),
                        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')])),
                        const PopupMenuItem(value: 'map', child: Row(children: [Icon(Icons.map, size: 18), SizedBox(width: 8), Text('View on Map')])),
                        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
                      ],
                      onSelected: (value) async {
                        if (value == 'details') {
                          _showStudentDetails(s);
                        } else if (value == 'edit') {
                          final student = Student.fromMap(s);
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => StudentFormScreen(student: student)));
                          _loadStudents();
                        } else if (value == 'map') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen(address: s['Address'])));
                        } else if (value == 'delete') {
                          await _deleteStudent(s['ID']);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentFormScreen()));
          _loadStudents();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
