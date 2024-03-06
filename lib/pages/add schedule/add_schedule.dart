import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/widgets/styledButton.dart';
import 'package:nfc_app/widgets/textfield%20container/textfieldContainer.dart';
import 'package:nfc_app/database/database_service.dart';
import 'package:sqflite/sqflite.dart'; // Import your DatabaseService

class AddSchedule extends StatefulWidget {
  const AddSchedule({Key? key}) : super(key: key);

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final TextEditingController _subjectController = TextEditingController();
  String? selectedSubjectName;
  String? selectedCourseName;
  List<Map<String, dynamic>> subjects = [];
  String? selectedCourse;
  String? selectedDay;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  void fetchSubjects() async {
    DatabaseService databaseService = DatabaseService();
    List<Map<String, dynamic>> fetchedSubjects =
        await databaseService.fetchSubjectsWithCourses();
    setState(() {
      subjects = fetchedSubjects;
    });
  }

  void submitSchedule() async {
    // Check if all required fields are filled
    if (selectedCourse != null &&
        selectedDay != null &&
        selectedStartTime != null &&
        selectedEndTime != null) {
      // Format the start time and end time
      String startTime = formatTimeOfDay(selectedStartTime!);
      String endTime = formatTimeOfDay(selectedEndTime!);

      // Insert the schedule into the database
      DatabaseService databaseService = DatabaseService();
      late var result;
      try {
        await databaseService
            .insertSched(
              int.parse(selectedCourse!.split('-').last.trim()),
              selectedDay!,
              startTime,
              endTime,
            )
            .then((value) => result = value);
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
          msg: 'Error inserting schedule: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      // Fetch all schedules from the database
      List<Map<String, dynamic>> schedules =
          await databaseService.fetchAllSchedules();

      // Print the inserted schedules
      schedules.forEach((schedule) {
        print('Schedule ID: ${schedule['schedule_id']}');
        print('Subject ID: ${schedule['subject_id']}');
        print('Day: ${schedule['day']}');
        print('Start Time: ${schedule['start_time']}');
        print('End Time: ${schedule['end_time']}');
        print('---------------');
      });

      if (result == -1) {
        // Show a failed message
        Fluttertoast.showToast(
          msg: 'Schedule already exist!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        // Show a success message

        Fluttertoast.showToast(
          msg: 'Schedule added successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      // Reset the selected values
      setState(() {
        selectedCourse = null;
        selectedDay = null;
        selectedStartTime = null;
        selectedEndTime = null;
      });
    } else {
      // Show an error message if any required field is missing

      Fluttertoast.showToast(
        msg: 'Please fill all fields',
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
          "Add Schedule",
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
                'lib/images/nfc2.png',
                width: 150,
                height: 150,
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
                      "Schedule Form",
                      style: TextStyle(fontFamily: "Roboto", fontSize: 24),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Automated Attendance Monitoring and Tracking System using NFC Tags",
                      style: TextStyle(fontFamily: "Roboto"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextFieldContainer(
                label: "Subject and Course",
                inputWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subjects.isEmpty
                        ? CircularProgressIndicator()
                        : subjects.isNotEmpty
                            ? SizedBox(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedCourse,
                                  onChanged: (String? newValue) {
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
                                    return DropdownMenuItem<String>(
                                      value:
                                          '${subject['subject_name']} - ${subject['course_name']} - ${subject['subject_id']}',
                                      child: Text(
                                        '${subject['subject_name']} - ${subject['course_name']} - ${subject['subject_id']}',
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
                                ),
                              )
                            : Text(
                                'No subjects available',
                                style: TextStyle(color: Colors.red),
                              ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFieldContainer(
                label: "Day",
                inputWidget: DropdownButton<String>(
                  value: selectedDay,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDay = newValue;
                    });
                  },
                  dropdownColor: Colors.white,
                  hint: Text('Select Day'),
                  items: [
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                  ].map((String day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(
                        day,
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _selectStartTime(context);
                          },
                          icon:
                              Icon(Icons.date_range), // Add the date icon here
                          label: Text('Start Time'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color.fromARGB(
                                          255, 228, 226, 226)
                                      .withOpacity(0.5); // Color when pressed
                                } else {
                                  return Colors.white; // Default color
                                }
                              },
                            ),
                          ),
                        ),
                        selectedStartTime != null
                            ? Text(
                                'Start Time: ${formatTimeOfDay(selectedStartTime!)}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _selectEndTime(context);
                          },
                          icon:
                              Icon(Icons.date_range), // Add the date icon here
                          label: Text('End Time'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color.fromARGB(
                                          255, 228, 226, 226)
                                      .withOpacity(0.5); // Color when pressed
                                } else {
                                  return Color.fromARGB(
                                      255, 255, 255, 255); // Default color
                                }
                              },
                            ),
                          ),
                        ),
                        selectedEndTime != null
                            ? Text(
                                'End Time: ${formatTimeOfDay(selectedEndTime!)}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),

              // StyledButton(
              //   btnText: 'Delete First Two Subjects',
              //   onClick: deleteFirstTwoSubjects,
              // ),
              SizedBox(height: 50),
              StyledButton(
                btnText: 'Submit',
                onClick: submitSchedule,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedStartTime = pickedTime;
      });
      String formattedStartTime = formatTimeOfDay(pickedTime);
      // Now you can use formattedStartTime for display or insertion into the database
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedEndTime = pickedTime;
      });
      String formattedEndTime = formatTimeOfDay(pickedTime);
      // Now you can use formattedEndTime for display or insertion into the database
    }
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    // Convert TimeOfDay to DateTime
    final now = DateTime.now();
    final time = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // Format the time using DateFormat
    final formattedTime = TimeOfDay.fromDateTime(time).format(context);

    // Format the time to 12-hour format with AM/PM
    final format = DateFormat.jm(); // 12-hour format with AM/PM
    return format.format(DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute));
  }
}
