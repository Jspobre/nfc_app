import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_app/database/database_service.dart';

// applied values
final filterProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'course': '',
    'yearLevel': '1st Year',
    'block': 'A',
    'subject': 0,
    'sched': 0,
    'gender': 'All'
  };
});

// for dropdown
final selectedCourseProvider = StateProvider<String>((ref) => '');
final selectedYearProvider = StateProvider<String>((ref) => "1st Year");
final selectedBlockProvider = StateProvider<String>((ref) => 'A');
final selectedSubjectProvider = StateProvider<int>((ref) => 0);
final selectedSchedProvider = StateProvider<int>((ref) => 0);
final selectedGenderProvider = StateProvider<String>((ref) => 'All');

// dynamic dropdown selection

final courseSelectionProvider = FutureProvider<List<String>>((ref) async {
  final dbService = DatabaseService();

  final tempList = await dbService.fetchDistinctCourseOptions();

  // List<String> result =
  //     tempList.map((e) => e['course_name'] as String).toList();

  return tempList;
});

// dynamic subject selection

final subjectOptionsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final selectedCourse = ref.watch(selectedCourseProvider);
  if (selectedCourse.isEmpty) {
    return []; // Return empty list if selectedCourse is empty
  }
  final db = await DatabaseService().database;
  final subjects = await db.rawQuery('''
    SELECT subject_id, subject_name
    FROM subjects
    WHERE course_name = ?
  ''', [selectedCourse]);
  return subjects;
});

// dynamic sched selection
final schedOptionsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final selectedSubject = ref.watch(selectedSubjectProvider);
  if (selectedSubject == 0) {
    return []; // Return empty list if selectedCourse is empty
  }
  final db = await DatabaseService().database;
  final subjects = await db.rawQuery('''
    SELECT schedule_id, day, start_time, end_time
    FROM schedules
    WHERE subject_id = ?
  ''', [selectedSubject]);
  return subjects;
});
