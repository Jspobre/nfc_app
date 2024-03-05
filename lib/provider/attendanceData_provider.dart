import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_app/database/database_service.dart';
import 'package:nfc_app/model/fetch_data.dart';

final attendanceDataProvider = FutureProvider<List<AttendanceRaw>>((ref) async {
  final dbService = DatabaseService();

  final attendanceRawData = await dbService.fetchAttendanceData();

  List<AttendanceRaw> tempList = attendanceRawData
      .map((e) => AttendanceRaw(
          studentNum: e['student_num'] as String,
          scheduleId: e['schedule_id'] as int,
          datetime: DateTime.fromMicrosecondsSinceEpoch(e['datetime'] as int),
          // datetime: DateTime.now(),
          status: e['status'] as String,
          fullName: e['full_name'],
          gender: e['gender'] as String,
          course: e['course'] as String,
          block: e['block'] as String,
          yearLevel: e['year_level'] as String,
          subjectId: e['subject_id'] as int,
          day: e['day'] as String,
          startTime: e['start_time'] as String,
          endTime: e['end_time'] as String))
      .toList();

  return tempList;
});

final studentListProvider = FutureProvider<List<IndivStudent>>((ref) async {
  final dbService = DatabaseService();

  final studentList = await dbService.fetchStudentsList();

  List<IndivStudent> tempList = studentList
      .map((e) => IndivStudent(
          studentNum: e['student_num'] as String,
          fullName: e['full_name'] as String,
          gender: e['gender'] as String,
          course: e['course'] as String,
          block: e['block'] as String,
          yearLevel: e['year_level'] as String,
          subjectId: e['subject_id'] as int))
      .toList();

  return tempList;
});
