import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nfc_app/database/database_service.dart'; // Import your database service here

class ReadModal extends StatelessWidget {
  final bool reverse;
  final void Function(String subjectName, String courseName, String day,
      String startTime, String endTime) selectSchedule;

  const ReadModal({
    Key? key,
    this.reverse = false,
    required this.selectSchedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Container(),
          middle: Text('Modal Page'),
        ),
        child: SafeArea(
          bottom: false,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseService().fetchSchedulesWithSubjects(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No data available"));
              } else {
                List<Map<String, dynamic>> schedules = snapshot.data!;
                return ListView(
                  reverse: reverse,
                  shrinkWrap: true,
                  controller: ModalScrollController.of(context),
                  physics: ClampingScrollPhysics(),
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: schedules.map((schedule) {
                      final int? scheduleId = schedule['subject_id'];
                      final int? subjectId = schedule['subject_id'];
                      final String day = schedule['day'];
                      final String startTime = schedule['start_time'];
                      final String endTime = schedule['end_time'];

                      // Fetch subject details based on subject_id
                      final String subjectName =
                          schedule['subject_name'] ?? 'Unknown';
                      final String courseName =
                          schedule['course_name'] ?? 'Unknown';

                      // Function to get course abbreviation
                      String getCourseAbbreviation(String course) {
                        switch (course) {
                          case "Bachelor of Science in Information Technology":
                            return "BSIT";
                          case "Bachelor of Science in Computer Science":
                            return "BSCS";
                          case "Bachelor of Science in Information System":
                            return "BSIS";
                          case "Bachelor of Science in Electronics Engineering":
                            return "BSECE";
                          case "Bachelor of Science in Computer Engineering":
                            return "BSCpE";
                          case "Bachelor of Elementary Education":
                            return "BEEd";
                          case "Bachelor of Secondary Education major in Math":
                            return "BSEd-Math";
                          case "Bachelor of Secondary Education major in English":
                            return "BSEd-English";
                          case "Bachelor of Technology and Livelihood Education major in ICT":
                            return "BTL-ICT";
                          case "Bachelor of Technology and Livelihood Education major in HE":
                            return "BTL-HE";
                          case "Bachelor of Science in Automotive Technology":
                            return "BSAT";
                          case "Bachelor of Science in Electronics Technology":
                            return "BSEET";
                          case "Bachelor of Science in Entrepreneurship":
                            return "BSEntrep";
                          case "Bachelor of Science in Nursing":
                            return "BSN";
                          default:
                            return "Unknown abbreviation";
                        }
                      }

                      // Get course abbreviation
                      final String courseAbbreviation =
                          getCourseAbbreviation(courseName);

                      return ListTile(
                        title: Text(
                          '$subjectName - $courseAbbreviation - ${day ?? 'Unknown'}: ${startTime ?? 'Unknown'} - ${endTime ?? 'Unknown'}',
                        ),
                        onTap: () {
                          // You can handle onTap event here
                          // For now, passing empty strings
                          selectSchedule(subjectName, courseAbbreviation, day,
                              startTime, endTime);
                        },
                      );
                    }).toList(),
                  ).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
