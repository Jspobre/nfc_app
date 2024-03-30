import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_app/database/database_service.dart';
import 'package:nfc_app/widgets/styledButton.dart';
import 'package:nfc_app/widgets/textfield%20container/textfieldContainer.dart';

class EnrollStudent extends StatefulWidget {
  const EnrollStudent({super.key});

  @override
  State<EnrollStudent> createState() => _EnrollStudentState();
}

class _EnrollStudentState extends State<EnrollStudent> {
  List<Map<String, dynamic>> subjects = [];
  List<Map<String, dynamic>> students = [];
Set<String> selectedStudents = Set<String>(); // Define selectedStudents
  int? selectedCourse;
  String? selectedStudent;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
    fetchStudentList();
  }

  void fetchSubjects() async {
    DatabaseService databaseService = DatabaseService();
    List<Map<String, dynamic>> fetchedSubjects =
        await databaseService.fetchSubjectsWithCourses();
    setState(() {
      subjects = fetchedSubjects;
    });
  }

  void fetchStudentList() async {
    DatabaseService databaseService = DatabaseService();
    List<Map<String, dynamic>> fetchedStudents =
        await databaseService.fetchStudentLists();
    setState(() {
      students = fetchedStudents;
    });
  }

Future<void> enrollStudent() async {
  DatabaseService databaseService = DatabaseService();
  final subjectId = selectedCourse ?? 0;
  final studentNumber = selectedStudent ?? '';

  try {
    await databaseService.assignSubject(studentNumber, subjectId);

    print("Student number: $studentNumber");
    print("Subject ID: $subjectId");
    // Show toast message

    Fluttertoast.showToast(
      msg: 'Student successfully enrolled!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Clear selected values
    setState(() {
      selectedCourse = null;
      selectedStudent = null;
      selectedStudents.clear(); // Clear selected students
    });
  } catch (error) {
    print("Error enrolling student: $error");
    Fluttertoast.showToast(
      msg: 'Error enrolling student: $error',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enroll Student",
          style: TextStyle(fontFamily: "Roboto", fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'lib/images/nfc2.png', // Replace with your image path
                width: 150, // Adjust width as needed
                height: 150, // Adjust height as needed
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xff16A637),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                width: double.infinity,
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Enroll student form",
                      style: TextStyle(fontFamily: "Roboto", fontSize: 24),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "NFC - Enabled Class Attendance Monitoring with Data Analytics",
                      style: TextStyle(fontFamily: "Roboto"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextFieldContainer(
                label: "Course and Academic Program",
                inputWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subjects.isEmpty
                        ? CircularProgressIndicator()
                        : subjects.isNotEmpty
                            ? SizedBox(
                                child: DropdownButton<int>(
                                isExpanded: true,
                                value: selectedCourse,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedCourse = newValue;
                                  });
                                },
                                items: subjects
                                    .where((subject) =>
                                        subject['course_name'] != null)
                                    .map((subject) {
                                  final courseName = subject['course_name'] ??
                                      'Unknown Course';
                                  return DropdownMenuItem<int>(
                                    value: subject['subject_id'] as int,
                                    child: Text(
                                      '${subject['subject_name']} - $courseName - ${subject['subject_id']}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ))
                            : Text(
                                'No subjects available',
                                style: TextStyle(color: Colors.red),
                              ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
                          TextFieldContainer(
                label: "Student lists",
                inputWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subjects.isEmpty
                        ? CircularProgressIndicator()
                        : subjects.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: students
                                    .where((student) => student['student_num'] != null)
                                    .map((student) {
                                  final studentName = student['full_name'] ?? 'Unknown Course';
                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: selectedStudents.contains(student['student_num']),
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            if (newValue!) {
                                              selectedStudents.add(student['student_num']);
                                            } else {
                                              selectedStudents.remove(student['student_num']);
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        '${student['student_num']} - ${student['full_name']}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              )
                            : Text(
                                'No subjects available',
                                style: TextStyle(color: Colors.red),
                              ),
                              ],
                            ),
                          ),
                    SizedBox(height: 20), // Adjust spacing as needed
                    StyledButton(
                      btnText: 'Enroll',
                      onClick: () {
                        enrollStudent();
                    },
              ),
              SizedBox(height: 20), // Add additional spacing at the end
            ],
          ),
        ),
      ),
    );
  }
}
