import 'package:nfc_app/database/nfc_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'nfc.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  //function to delete a specific row in the subjects table using id
  Future<void> deleteSubject(int id) async {
    // Get a reference to the database
    Database db = await database;

    // Delete the subject with the specified id
    await db.delete(
      'subjects',
      where: 'subject_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> create(Database database, int version) async =>
      await NfcDB().createTable(database);

  // Function to fetch subject names and course names
  Future<List<Map<String, dynamic>>> fetchSubjectsWithCourses() async {
    final Database db = await database;
    return await db.query('subjects');
  }

  Future<List<Map<String, dynamic>>> fetchStudentLists() async {
    final Database db = await database;
    return await db.query('students');
  }

  // Insert subject and course name
  Future<int> insertSubject(String subjectName, String? courseName) async {
    // Get a reference to the database
    final db = await database;

    // Insert the subject into the subjects table
    return await db.insert(
      'subjects',
      {'subject_name': subjectName, 'course_name': courseName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Insert sched
  Future<int> insertSched(
      int subjectId, String day, String startTime, String endTime) async {
    // Get a reference to the database
    final db = await database;

    // Insert the subject into the subjects table
    return await db.insert(
      'schedules',
      {
        'subject_id': subjectId,
        'day': day,
        'start_time': startTime,
        'end_time': endTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Function to fetch all of the schedules
  Future<List<Map<String, dynamic>>> fetchAllSchedules() async {
    final db = await database;
    return await db.query('schedules');
  }

// Insert student
  Future<void> insertStudent(String studentNum, String fullName, String gender,
      String course, String block, String yearLevel) async {
    // Get a reference to the database
    final db = await database;

    // Insert the subject into the subjects table
    await db.insert(
      'students',
      {
        'student_num': studentNum,
        'full_name': fullName,
        'gender': gender,
        'course': course,
        'block': block,
        'year_level': yearLevel,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Assign Subject
  Future<void> assignSubject(String studentNum, int subjectId) async {
    // Get a reference to the database
    final db = await database;

    // Insert the subject into the subjects table
    await db.insert(
      'student_subjects',
      {
        'student_num': studentNum,
        'subject_id': subjectId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// insert Attendance
  Future<void> insertAttendance(
      String studentNum, int scheduleId, int datetime, String status) async {
    // Get a reference to the database
    final db = await database;

    // Insert the subject into the subjects table
    await db.insert(
      'attendance',
      {
        'student_num': studentNum,
        'schedule_id': scheduleId,
        'datetime': datetime,
        'status': status
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ! FOR REPORTS & ANALYTICS
  // Fetch all attendance data
  Future<List<Map<String, dynamic>>> fetchAttendanceData(scheduleId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT attendance.*, students.*, schedules.*, subjects.subject_name
    FROM attendance
    INNER JOIN students ON attendance.student_num = students.student_num
    INNER JOIN schedules ON attendance.schedule_id = schedules.schedule_id
    INNER JOIN subjects ON schedules.subject_id = subjects.subject_id
    WHERE attendance.schedule_id = ${scheduleId}
  ''');
  }

  // Fetch all student enrolled in the selected subject
  Future<List<Map<String, dynamic>>> fetchStudentsList(
      subjectId, yearLevel, block, course, gender) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT student_subjects.student_num, student_subjects.subject_id, students.*
    FROM student_subjects
    INNER JOIN students ON student_subjects.student_num = students.student_num
    INNER JOIN subjects ON student_subjects.subject_id = subjects.subject_id
    WHERE student_subjects.subject_id = ? 
    AND students.year_level = ? 
    AND students.block = ? 
    AND students.course = ? 
    AND students.gender = ?''', [subjectId, yearLevel, block, course, gender]);
  }

  // Fetch course dropdown options
  Future<List<String>> fetchCourseOptions() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT DISTINCT course_name
    FROM subjects
''');
    List<String> tempList =
        result.map((e) => e['course_name'] as String).toList();

    return tempList;
  }

  // Fetch subject dropdown options
  Future<List<Map<String, dynamic>>> fetchSubjectOptions(courseName) async {
    final db = await database;
    return await db.rawQuery('''
          SELECT subject_id, subject_name
          FROM subjects
          WHERE course_name = ?
''', [courseName]);
  }

  /// Fetch schedule dropdown options
  Future<List<Map<String, dynamic>>> fetchSchedOptions(subjectId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT *
      FROM schedules
      WHERE subject_id = ?
  ''', [subjectId]);
  }
}
