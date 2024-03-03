import 'package:sqflite/sqflite.dart';

class NfcDB {
  // FOR CREATING TABLE DURING INITIALIZATION
  final subjectsTable = 'subjects';
  final schedulesTable = 'schedules';
  final studentsTable = 'students';
  final studentSubjectsTable = 'student_subjects';
  final attendanceTable = 'attendance';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $subjectsTable (
      subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
      subject_name TEXT,
      course_name TEXT
    );""");

    await database.execute("""CREATE TABLE IF NOT EXISTS $schedulesTable (
      schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
      subject_id INTEGER,
      day TEXT,
      start_time TEXT,
      end_time TEXT,
      FOREIGN KEY (subject_id) REFERENCES $subjectsTable (subject_id)
    );""");

    await database.execute("""CREATE TABLE IF NOT EXISTS $studentsTable (
      student_num TEXT PRIMARY KEY,
      full_name TEXT,
      gender TEXT,
      course TEXT,
      block TEXT,
      year_level TEXT
    );""");

    await database.execute("""CREATE TABLE IF NOT EXISTS $studentSubjectsTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      student_num TEXT,
      subject_id INTEGER,
      FOREIGN KEY (student_num) REFERENCES $studentsTable (student_num),
      FOREIGN KEY (subject_id) REFERENCES $subjectsTable (subject_id)
    );""");

    await database.execute("""CREATE TABLE IF NOT EXISTS $attendanceTable (
      attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
      student_num TEXT,
      schedule_id INTEGER,
      datetime INTEGER,
      status TEXT,
      FOREIGN KEY (student_num) REFERENCES $studentsTable (student_num),
      FOREIGN KEY (schedule_id) REFERENCES $schedulesTable (schedule_id)
    );""");
  }
}
