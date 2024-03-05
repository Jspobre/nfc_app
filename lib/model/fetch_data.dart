class AttendanceRaw {
  final String studentNum;
  final int scheduleId;
  final DateTime datetime;
  final String status;
  final String fullName;
  final String gender;
  final String course;
  final String block;
  final String yearLevel;
  final int subjectId;
  final String day;
  final String startTime;
  final String endTime;

  AttendanceRaw(
      {required this.studentNum,
      required this.scheduleId,
      required this.datetime,
      required this.status,
      required this.fullName,
      required this.gender,
      required this.course,
      required this.block,
      required this.yearLevel,
      required this.subjectId,
      required this.day,
      required this.startTime,
      required this.endTime});
}

class IndivStudent {
  final String studentNum;
  final String fullName;
  final String gender;
  final String course;
  final String block;
  final String yearLevel;
  final int subjectId;

  IndivStudent({
    required this.studentNum,
    required this.fullName,
    required this.gender,
    required this.course,
    required this.block,
    required this.yearLevel,
    required this.subjectId,
  });
}
