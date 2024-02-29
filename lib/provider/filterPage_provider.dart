import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_app/database/database_service.dart';

// applied values
final filterProvider = StateProvider<Map<String, String>>((ref) {
  return {
    'course': 'Bachelor of Science in Computer Science',
    'yearLevel': '1st Year',
    'block': 'A',
    'subject': 'Capstone',
    'sched': 'Monday, 9AM - 12PM',
    'gender': 'All'
  };
});

// for dropdown
final selectedCourseProvider =
    StateProvider<String>((ref) => 'Bachelor of Science in Computer Science');
final selectedYearProvider = StateProvider<String>((ref) => '1st Year');
final selectedBlockProvider = StateProvider<String>((ref) => 'A');
final selectedSubjectProvider = StateProvider<String>((ref) => 'Capstone');
final selectedSchedProvider =
    StateProvider<String>((ref) => 'Monday, 9AM - 12PM');
final selectedGenderProvider = StateProvider<String>((ref) => 'All');

// dynamic dropdown selection

final courseSelectionProvider = FutureProvider<List<String>>((ref) async {
  final dbService = DatabaseService();

  List<String> tempList = [];

  return tempList;
});
