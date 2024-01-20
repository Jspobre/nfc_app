import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceData {
  final String docId;
  final String fullName;
  final String course;
  final String yrLevel;
  final String block;
  final int timestamp;

  AttendanceData(
      {required this.docId,
      required this.fullName,
      required this.course,
      required this.yrLevel,
      required this.block,
      required this.timestamp});
}
