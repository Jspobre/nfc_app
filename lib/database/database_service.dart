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

  Future<void> create(Database database, int version) async =>
      await NfcDB().createTable(database);

  Future<void> insertSubject(String subjectName) async {
    // Get a reference to the database
    final db = await database;

    // Insert the subject into the subjects table
    await db.insert(
      'subjects',
      {'subject_name': subjectName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
