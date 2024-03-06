import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nfc_app/database/database_service.dart'; // Import your database service here

class ModalInsideModal extends StatelessWidget {
  final bool reverse;
  final void Function(String studentNum, String fullName) selectStudent;

  const ModalInsideModal({
    Key? key,
    this.reverse = false,
    required this.selectStudent,
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
            future: DatabaseService().fetchStudentLists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No data available"));
              } else {
                List<Map<String, dynamic>> students = snapshot.data!;
                return ListView(
                  reverse: reverse,
                  shrinkWrap: true,
                  controller: ModalScrollController.of(context),
                  physics: ClampingScrollPhysics(),
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: students.map((student) {
                      final String fullName = student['full_name'];
                      final String course = student['course'];
                      final String studentNum = student['student_num'];
                      final String yearLevel = student['year_level'][0];
                      final String block = student['block'];

                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(fullName),
                            Row(
                              children: [
                                Text(
                                    '${course == "Bachelor of Science in Information Technology" ? "BSIT" : course == "Bachelor of Science in Computer Science" ? "BSCS" : course == "Bachelor of Science in Information System" ? "BSIS" : course == "Bachelor of Science in Electronics Engineering" ? "BSECE" : course == "Bachelor of Science in Computer Engineering" ? "BSCpE" : course == "Bachelor of Elementary Education" ? "BEEd" : course == "Bachelor of Secondary Education major in Math" ? "BSEd-Math" : course == "Bachelor of Secondary Education major in English" ? "BSEd-English" : course == "Bachelor of Technology and Livelihood Education major in ICT" ? "BTL-ICT" : course == "Bachelor of Technology and Livelihood Education major in HE" ? "BTL-HE" : course == "Bachelor of Science in Automotive Technology" ? "BSAT" : course == "Bachelor of Science in Electronics Technology" ? "BSEET" : course == "Bachelor of Science in Entrepreneurship" ? "BSEntrep" : course == "Bachelor of Science in Nursing" ? "BSN" : "Unknown abbreviation"}'),
                                SizedBox(width: 5),
                                Text(yearLevel),
                                Text(block)
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          // Pass both studentNum and fullName to the next page
                          selectStudent(fullName, studentNum);
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
