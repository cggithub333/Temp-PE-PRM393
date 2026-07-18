import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/major.dart';
import '../models/student.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'student_management.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Major (
        IDMajor INTEGER PRIMARY KEY AUTOINCREMENT,
        nameMajor TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Student (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        gender TEXT NOT NULL,
        email TEXT NOT NULL,
        Address TEXT NOT NULL,
        Phone TEXT NOT NULL,
        idMajor INTEGER,
        FOREIGN KEY (idMajor) REFERENCES Major(IDMajor)
      )
    ''');

    // Seed major data
    await db.insert('Major', {'nameMajor': 'Software Engineering'});
    await db.insert('Major', {'nameMajor': 'Information Technology'});
    await db.insert('Major', {'nameMajor': 'Artificial Intelligence'});
    await db.insert('Major', {'nameMajor': 'Business Administration'});

    // Seed student data (actual student info for demo)
    final students = [
      {'name': 'Nguyen Van An', 'date': '2003-05-12', 'gender': 'Male', 'email': 'anhe181855@fpt.edu.vn', 'Address': '123 Le Loi, Quan 1, Ho Chi Minh City', 'Phone': '0901234567', 'idMajor': 1},
      {'name': 'Tran Thi Bich', 'date': '2003-08-20', 'gender': 'Female', 'email': 'bichhe181856@fpt.edu.vn', 'Address': '45 Nguyen Hue, Quan 1, Ho Chi Minh City', 'Phone': '0912345678', 'idMajor': 1},
      {'name': 'Le Minh Cuong', 'date': '2002-12-01', 'gender': 'Male', 'email': 'cuonghe181857@fpt.edu.vn', 'Address': '67 Tran Hung Dao, Quan 5, Ho Chi Minh City', 'Phone': '0923456789', 'idMajor': 2},
      {'name': 'Pham Thi Dung', 'date': '2003-03-15', 'gender': 'Female', 'email': 'dunghe181858@fpt.edu.vn', 'Address': '89 Vo Van Tan, Quan 3, Ho Chi Minh City', 'Phone': '0934567890', 'idMajor': 3},
      {'name': 'Hoang Van Em', 'date': '2002-07-22', 'gender': 'Male', 'email': 'emhe181859@fpt.edu.vn', 'Address': '101 Nam Ky Khoi Nghia, Quan 3, Ho Chi Minh City', 'Phone': '0945678901', 'idMajor': 2},
    ];
    for (final s in students) {
      await db.insert('Student', s);
    }
  }

  // ---- Major CRUD ----
  Future<List<Major>> getAllMajors() async {
    final db = await database;
    final maps = await db.query('Major');
    return maps.map((m) => Major.fromMap(m)).toList();
  }

  Future<int> insertMajor(Major major) async {
    final db = await database;
    return db.insert('Major', major.toMap()..remove('IDMajor'));
  }

  Future<int> updateMajor(Major major) async {
    final db = await database;
    return db.update('Major', major.toMap(), where: 'IDMajor = ?', whereArgs: [major.idMajor]);
  }

  Future<int> deleteMajor(int id) async {
    final db = await database;
    return db.delete('Major', where: 'IDMajor = ?', whereArgs: [id]);
  }

  // ---- Student CRUD ----
  Future<List<Map<String, dynamic>>> getAllStudentsWithMajor() async {
    final db = await database;
    return db.rawQuery('''
      SELECT s.*, m.nameMajor
      FROM Student s
      LEFT JOIN Major m ON s.idMajor = m.IDMajor
      ORDER BY s.ID ASC
    ''');
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;
    final map = student.toMap()..remove('ID');
    return db.insert('Student', map);
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return db.update('Student', student.toMap(), where: 'ID = ?', whereArgs: [student.id]);
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return db.delete('Student', where: 'ID = ?', whereArgs: [id]);
  }
}
