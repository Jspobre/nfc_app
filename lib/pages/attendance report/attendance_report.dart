import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/api/attendance_pdf.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  int dayValue = 0; //0 for today
  int monthValue = 0; //0 for this month
  String selectedCourse = "Bachelor of Science in Computer Science";
  String selectedYear = "1st Year";
  String selectedBlock = "A";

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = DateTime.now().add(Duration(days: dayValue));
    DateTime selectedMonth = DateTime(
        selectedDay.year, selectedDay.month + monthValue, selectedDay.day);
    // Format the current date into "MONTH DAY, YEAR" format
    String formattedDate = DateFormat('MMMM dd, yyyy').format(selectedMonth);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white10,
        title: const Text(
          "Attendance Report",
          style: TextStyle(fontFamily: "Roboto", fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // COURSE SELECTER
                      Row(
                        children: [
                          Text(
                            "Course:".toUpperCase(),
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Dropdown
                          SizedBox(
                            width: 65,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCourse, // Current selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCourse = newValue ??
                                      ''; // Update the selected value
                                });
                              },
                              items: const [
                                DropdownMenuItem<String>(
                                  value:
                                      "Bachelor of Science in Computer Science",
                                  child: Text(
                                    "BSCS",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value:
                                      "Bachelor of Science in Information System",
                                  child: Text(
                                    "BSIS",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value:
                                      "Bachelor of Science in Information Technology",
                                  child: Text(
                                    "BSIT",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value:
                                      "Bachelor of Science in Information Technology major in Animation",
                                  child: Text(
                                    "BSIT - Animation",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // YEAR LEVEL SELECTOR
                      Row(
                        children: [
                          Text(
                            "Year Level".toUpperCase(),
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Dropdown
                          SizedBox(
                            width: 35,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedYear, // Current selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedYear = newValue ??
                                      ''; // Update the selected value
                                });
                              },
                              items: const [
                                DropdownMenuItem<String>(
                                  value: "1st Year",
                                  child: Text(
                                    "1",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "2nd Year",
                                  child: Text(
                                    "2",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "3rd Year",
                                  child: Text(
                                    "3",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "4th Year",
                                  child: Text(
                                    "4",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // BLOCK SELECTOR
                      Row(
                        children: [
                          Text(
                            "Block:".toUpperCase(),
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Dropdown
                          SizedBox(
                            width: 35,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedBlock, // Current selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedBlock = newValue ??
                                      ''; // Update the selected value
                                });
                              },
                              items: const [
                                DropdownMenuItem<String>(
                                  value: "A",
                                  child: Text(
                                    "A",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "B",
                                  child: Text(
                                    "B",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "C",
                                  child: Text(
                                    "C",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "D",
                                  child: Text(
                                    "D",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // DATE SELECTOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            monthValue--;
                          });
                          // updateSelectedDate(dayValue, monthValue);
                          print(dayValue);
                          print(monthValue);
                        },
                        icon: const Icon(Icons.keyboard_double_arrow_left),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            dayValue--;
                          });
                          // updateSelectedDate(dayValue, monthValue);
                          print(dayValue);
                          print(monthValue);
                        },
                        icon: const Icon(Icons.chevron_left),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            dayValue++;
                          });
                          // updateSelectedDate(dayValue, monthValue);
                          print(dayValue);
                          print(monthValue);
                        },
                        icon: const Icon(Icons.chevron_right),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            monthValue++;
                          });
                          // updateSelectedDate(dayValue, monthValue);
                          print(dayValue);
                          print(monthValue);
                        },
                        icon: const Icon(Icons.keyboard_double_arrow_right),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // TABLE DISPLAY
                  // title
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         "Name",
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         "Time Arrived",
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // Display data here
                  Table(
                      border: TableBorder
                          .all(), // Allows to add a border decoration around your table
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Text(
                              'Name',
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Text(
                              'Time Arrived',
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Text(
                              'Test',
                              style: TextStyle(fontFamily: "Roboto"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Text(
                              '9:00AM',
                              style: TextStyle(fontFamily: "Roboto"),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Text(
                              'Dummy',
                              style: TextStyle(fontFamily: "Roboto"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Text(
                              '10:00AM',
                              style: TextStyle(fontFamily: "Roboto"),
                            ),
                          ),
                        ]),
                      ]),

                  // EXPORT BUTTON
                  StyledButton(
                      btnText: "Export",
                      onClick: () async {
                        try {
                          await AttendancePdf.generate();
                        } catch (e) {
                          print(e);
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
