import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/api/attendance_pdf.dart';
import 'package:nfc_app/model/attendance_data.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  int dayValue = 0; //0 for today
  int monthValue = 0; //0 for this month
  DateTime? datePickerSelected;
  String selectedCourse = "Bachelor of Science in Computer Science";
  String selectedYear = "1st Year";
  String selectedBlock = "A";
  List<Map<String, dynamic>> studentData = [];

  @override
  void initState() {
    super.initState();
    fetchAllStudent();
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay =
        (datePickerSelected ?? DateTime.now()).add(Duration(days: dayValue));
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
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
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
                                DropdownMenuItem<String>(
                                  value:
                                      "Bachelor of Science in Electronics Engineering",
                                  child: Text(
                                    "BSEE",
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
                                      "Bachelor of Science in Computer Engineering",
                                  child: Text(
                                    "BSCoE",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "Bachelor of Elementary Education",
                                  child: Text(
                                    "BEEd",
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
                                      "Bachelor of Secondary Education major in Math",
                                  child: Text(
                                    "BSEd - Math",
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
                                      "Bachelor of Secondary Education major in English",
                                  child: Text(
                                    "BSEd - English",
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
                                      "Bachelor of Technology and Livelihood Education major in ICT",
                                  child: Text(
                                    "BTLED - ICT",
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
                                      "Bachelor of Technology and Livelihood Education major in HE",
                                  child: Text(
                                    "BTLED - HE",
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
                                      "Bachelor of Science in Automotive Technology",
                                  child: Text(
                                    "BSAT",
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
                                      "Bachelor of Science in Electronics Technology",
                                  child: Text(
                                    "BSET",
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
                                      "Bachelor of Science in Entrepreneurship",
                                  child: Text(
                                    "BSEntrep",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "Bachelor of Science in Nursing",
                                  child: Text(
                                    "BSN",
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
                            "Yr Level".toUpperCase(),
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "2nd Year",
                                  child: Text(
                                    "2",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "3rd Year",
                                  child: Text(
                                    "3",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "4th Year",
                                  child: Text(
                                    "4",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
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
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "B",
                                  child: Text(
                                    "B",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "C",
                                  child: Text(
                                    "C",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "D",
                                  child: Text(
                                    "D",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
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
                        },
                        icon: const Icon(Icons.chevron_left),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? dateTime = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xff16A637), // <-- SEE HERE
                                    onPrimary:
                                        Color(0xff252525), // <-- SEE HERE
                                    onSurface:
                                        Color(0xff252525), // <-- SEE HERE
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(
                                          0xff252525), // button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (dateTime != null) {
                            setState(
                              () {
                                datePickerSelected = dateTime;
                                dayValue = 0;
                                monthValue = 0;
                              },
                            );
                          }
                        },
                        child: Text(
                          formattedDate,
                          style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            dayValue++;
                          });
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
                  // Display data here
                  StreamBuilder(
                      stream: FirebaseDatabase.instance.ref().onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            !snapshot.hasError &&
                            snapshot.data!.snapshot.value != null) {
                          // Data is available
                          var data = snapshot.data!.snapshot.value;

                          List<AttendanceData> attendanceData = [];
                          List<String> uniqueFullNames = [];

                          if (data is Map && data.isNotEmpty) {
                            attendanceData = data.entries
                                .where((e) {
                                  //! filter attendance data first
                                  List<String> tag_data = e.value['tag_data']
                                      .toString()
                                      .split(' - ');
                                  int timestamp = e.value['timestamp'];

                                  int indivStudentIndex =
                                      studentData.indexWhere(
                                          (s) => s['full_name'] == tag_data[0]);

                                  // Filter based on selectedCourse, selectedYear,  selectedBlock, and selectedMonth
                                  bool courseFilter = selectedCourse == "All" ||
                                      selectedCourse ==
                                          studentData[indivStudentIndex]
                                              ['course'];

                                  bool yearFilter = selectedYear == "All" ||
                                      selectedYear ==
                                          studentData[indivStudentIndex]
                                              ['year_level'];

                                  bool blockFilter = selectedBlock == "All" ||
                                      selectedBlock ==
                                          studentData[indivStudentIndex]
                                              ['block'];

                                  DateTime attendanceDateTime =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          timestamp);

                                  bool dateFilter = selectedMonth.year ==
                                          attendanceDateTime.year &&
                                      selectedMonth.month ==
                                          attendanceDateTime.month &&
                                      selectedMonth.day ==
                                          attendanceDateTime.day;

                                  return courseFilter &&
                                      yearFilter &&
                                      blockFilter &&
                                      dateFilter;
                                })
                                .map((e) {
                                  //! get the data to be displayed
                                  List<String> tag_data = e.value['tag_data']
                                      .toString()
                                      .split(' - ');
                                  int timestamp = e.value['timestamp'];

                                  int indivStudentIndex =
                                      studentData.indexWhere(
                                          (s) => s['full_name'] == tag_data[0]);

                                  print(indivStudentIndex);

                                  String fullName =
                                      studentData[indivStudentIndex]
                                          ['full_name'];

                                  if (!uniqueFullNames.contains(fullName)) {
                                    //! filter out duplicates and get first occurence
                                    uniqueFullNames.add(fullName);
                                    return AttendanceData(
                                        docId: tag_data[1],
                                        fullName: fullName,
                                        course: studentData[indivStudentIndex]
                                            ['course'],
                                        yrLevel: studentData[indivStudentIndex]
                                            ['year_level'],
                                        block: studentData[indivStudentIndex]
                                            ['block'],
                                        timestamp: timestamp);
                                  } else {
                                    return null; // ? Duplicate, skip this entry
                                  }
                                })
                                .whereType<
                                    AttendanceData>() //! remove the null values
                                .toList();
                          }

                          return Column(
                            children: [
                              Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(),
                                    1: FixedColumnWidth(120.0),
                                  },
                                  border: TableBorder
                                      .all(), // Allows to add a border decoration around your table
                                  children: [
                                    const TableRow(children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        child: Text(
                                          'Name',
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        child: Text(
                                          'Time Arrived',
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ]),
                                    if (attendanceData
                                        .isEmpty) //! Display the empty data
                                      const TableRow(children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                          child: Text(
                                            "No data yet",
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                          child: Text(
                                            "No data yet",
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ]),
                                    for (final data
                                        in attendanceData) //! Display the filtered data
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                          child: Text(
                                            data.fullName,
                                            style: const TextStyle(
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                          child: Text(
                                            formatTime(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    data.timestamp)),
                                            style: const TextStyle(
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ])
                                  ]),

                              //! EXPORT BUTTON
                              const SizedBox(
                                height: 10,
                              ),
                              StyledButton(
                                  noShadow: true,
                                  btnIcon: Icon(Icons.picture_as_pdf),
                                  btnText: "Export to Pdf",
                                  onClick: () async {
                                    try {
                                      await AttendancePdf.generate(
                                          attendanceData,
                                          formattedDate); //! Pass the data
                                    } catch (e) {
                                      print("error generating pdf: $e");
                                    }
                                  })
                            ],
                          );
                        } else if (snapshot.hasError) {
                          // Handle error
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.data?.snapshot.value == null) {
                          return Table(
                              border: TableBorder
                                  .all(), // Allows to add a border decoration around your table
                              children: const [
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    child: Text(
                                      'No Data Yet',
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    child: Text(
                                      'No Data Yet',
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ]),
                              ]);
                        } else {
                          // Data is still loading
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future fetchAllStudent() async {
    try {
      // Replace "your_collection" with the name of your Firestore collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('students').get();

      // Loop through the documents in the collection
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          // Access the data of each document
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          setState(() {
            studentData.add(data);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  String formatTime(DateTime dateTime) {
    final formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
  }
}
