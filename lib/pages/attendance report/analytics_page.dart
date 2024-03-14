import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/api/attendance_pdf.dart';
import 'package:nfc_app/model/fetch_data.dart';
import 'package:nfc_app/pages/attendance%20report/filter_page.dart';
import 'package:nfc_app/provider/attendanceData_provider.dart';
import 'package:nfc_app/provider/date_provider.dart';
import 'package:nfc_app/provider/filterPage_provider.dart';
import 'package:nfc_app/provider/schedDetail_provider.dart';
import 'package:nfc_app/provider/sort_provider.dart';
import 'package:nfc_app/provider/subjectName_provider.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class AnalyticsPage extends ConsumerWidget {
  AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // selected filters watch
    final selectedFilters = ref.watch(filterProvider);
    // sort bool - sort alphabetically or by time arrived
    final sortName = ref.watch(sortNameProvider);

    // course name to abbreviation converter
    String courseAbbreviation = (selectedFilters['course'] as String) ==
            "Bachelor of Science in Computer Science"
        ? "BSCS"
        : (selectedFilters['course'] as String) ==
                "Bachelor of Science in Information System"
            ? "BSIS"
            : (selectedFilters['course'] as String) ==
                    "Bachelor of Science in Information Technology"
                ? "BSIT"
                : (selectedFilters['course'] as String) ==
                        "Bachelor of Science in Information Technology major in Animation"
                    ? "BSIT Animation"
                    : (selectedFilters['course'] as String) ==
                            "Bachelor of Science in Electronics Engineering"
                        ? "BSEE"
                        : (selectedFilters['course'] as String) ==
                                "Bachelor of Science in Computer Engineering"
                            ? "BSCpE"
                            : (selectedFilters['course'] as String) ==
                                    "Bachelor of Elementary Education"
                                ? "BEEd"
                                : (selectedFilters['course'] as String) ==
                                        "Bachelor of Secondary Education major in Math"
                                    ? "BSEd Math"
                                    : (selectedFilters['course'] as String) ==
                                            "Bachelor of Secondary Education major in English"
                                        ? "BSEd English"
                                        : (selectedFilters['course'] as String) ==
                                                "Bachelor of Technology and Livelihood Education major in ICT"
                                            ? "BTLE ICT"
                                            : (selectedFilters['course']
                                                        as String) ==
                                                    "Bachelor of Technology and Livelihood Education major in HE"
                                                ? "BTLE HE"
                                                : (selectedFilters['course']
                                                            as String) ==
                                                        "Bachelor of Science in Automotive Technology"
                                                    ? "BSAT"
                                                    : (selectedFilters['course']
                                                                as String) ==
                                                            "Bachelor of Science in Electronics Technology"
                                                        ? "BSET"
                                                        : (selectedFilters['course']
                                                                    as String) ==
                                                                "Bachelor of Science in Entrepreneurship"
                                                            ? "BSEnt"
                                                            : (selectedFilters[
                                                                            'course']
                                                                        as String) ==
                                                                    "Bachelor of Science in Nursing"
                                                                ? "BSN"
                                                                : "Unknown";

    // extract selected subject's name
    final subjectNameFuture = ref.watch(subjectNameProvider);
    String subjectName = subjectNameFuture.when(
      data: (data) {
        return data;
      },
      error: (error, stackTrace) {
        print("error subject name:");
        print(error);
        print(stackTrace);
        return 'Error';
      },
      loading: () => 'Loading',
    );

    // extract selected sched's detail
    final schedDetailFuture = ref.watch(schedDetailProvider);
    String schedDetail = schedDetailFuture.when(
      data: (data) {
        return data;
      },
      error: (error, stackTrace) {
        print("error subject name:");
        print(error);
        print(stackTrace);
        return 'Error';
      },
      loading: () => 'Loading',
    );

    String schedDay = schedDetail.split(',')[0];
    print(schedDay);

    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer(
              builder: ((context, ref, child) {
                // fetch all attendance & student
                final attendanceList = ref.watch(attendanceDataProvider);
                final studentList = ref.watch(studentListProvider);
                // selected Date Range value
                final selectedDates = ref.watch(selectedDateRangeProvider);

                // Filter the attendance data with the filters & selected date
                // this results to students who are present and late at the selected sched
                List<AttendanceRaw> filteredAttendance = attendanceList.when(
                  data: (data) {
                    return data.where((element) {
                      print(element.fullName);
                      return selectedFilters['course'] == element.course &&
                          selectedFilters['block'] == element.block &&
                          selectedFilters['yearLevel'] == element.yearLevel &&
                          selectedFilters['subject'] == element.subjectId &&
                          selectedFilters['sched'] == element.scheduleId &&
                          (selectedFilters['gender'] == element.gender ||
                              selectedFilters['gender'] == 'All');
                    }).where((element) {
                      print(element.datetime);
                      return element.datetime.isAfter(selectedDates.start
                              .subtract(Duration(days: 1))) &&
                          element.datetime.isBefore(
                              selectedDates.end.add(Duration(days: 1)));
                    }).toList();
                  },
                  error: (error, stackTrace) => [],
                  loading: () => [],
                );

                print("filtered students in analytics:");
                print(filteredAttendance);

                // Extract the list of all the students enrolled in the subject
                List<IndivStudent> classList = studentList.when(
                    data: (data) {
                      return data
                          .where(
                            (element) =>
                                selectedFilters['course'] == element.course &&
                                selectedFilters['block'] == element.block &&
                                selectedFilters['yearLevel'] ==
                                    element.yearLevel &&
                                selectedFilters['subject'] ==
                                    element.subjectId &&
                                (selectedFilters['gender'] == element.gender ||
                                    selectedFilters['gender'] == 'All'),
                          )
                          .toList();
                    },
                    error: (error, stackTrace) => [],
                    loading: () => []);

                print("class list in analytics");
                print(classList);

                // remove datetime that does not match the sched day (most likely attendance mistakes by prof)
                List<AttendanceRaw> accurateFilteredAttendance =
                    filteredAttendance
                        .where((element) =>
                            getDayName(element.datetime) == schedDay)
                        .toList();

                // Sort entries by datetime
                List<AttendanceRaw> sortedList =
                    List.from(accurateFilteredAttendance)
                      ..sort((a, b) => a.datetime.compareTo(b.datetime));

                print("sortedList logic");
                print(sortedList);

                // Group entries with the same DateTime
                Map<DateTime, List<AttendanceRaw>> groupedEntries = {};
                sortedList.forEach((entry) {
                  if (!groupedEntries.containsKey(DateTime(entry.datetime.year,
                      entry.datetime.month, entry.datetime.day))) {
                    groupedEntries[DateTime(entry.datetime.year,
                        entry.datetime.month, entry.datetime.day)] = [];
                  }
                  groupedEntries[DateTime(entry.datetime.year,
                          entry.datetime.month, entry.datetime.day)]!
                      .add(entry);
                });
                print("grouped entries without absent students");
                print(groupedEntries);

                // Loop through each keys and add the absent students in the list of attendance
                groupedEntries.forEach((key, value) {
                  // get day
                  String dayName = value.first.day;

                  List<String> uniqueFullNames = [];
                  // remove first the duplicate entries of attendance (mistakes)
                  List<AttendanceRaw> accurateAttendanceList =
                      groupedEntries[key]!
                          .map((e) {
                            if (!uniqueFullNames.contains(e.fullName)) {
                              uniqueFullNames.add(e.fullName);
                              return e;
                            } else {
                              return null;
                            }
                          })
                          .whereType<AttendanceRaw>()
                          .toList();

                  groupedEntries[key] = accurateAttendanceList;

                  // get the remaining students who were absent
                  List<IndivStudent> absentStudents =
                      classList.where((element) {
                    return !value.any((attendance) =>
                        attendance.fullName == element.fullName);
                  }).toList();

                  // loop through the absent student
                  absentStudents.forEach((element) {
                    // push the absent student to the list of presents for that date, thus, completing the list of students
                    groupedEntries[key]!.add(AttendanceRaw(
                        studentNum: element.studentNum,
                        scheduleId: selectedFilters['sched'],
                        datetime: key,
                        status: 'Absent',
                        fullName: element.fullName,
                        gender: element.gender,
                        course: element.course,
                        block: element.block,
                        yearLevel: element.yearLevel,
                        subjectId: selectedFilters['subject'],
                        day: dayName,
                        startTime: schedDetail.split(', ')[1].split(' - ')[0],
                        endTime: schedDetail.split(', ')[1].split(' - ')[1]));
                  });
                });

                // Convert Map back to List
                List<AttendanceRaw> completeAttendance = [];
                groupedEntries.forEach((key, value) {
                  value.forEach((element) {
                    completeAttendance.add(element);
                  });
                });

                // After getting all the students who are present/late/absent in the sched within the time range, its time to merge name & values
                Map<String, Map<String, dynamic>> mergedData = {};

                for (final entry in completeAttendance) {
                  String key = entry.fullName;

                  if (!mergedData.containsKey(key)) {
                    mergedData[key] = {
                      "studentNum": entry.studentNum,
                      "fullName": entry.fullName,
                      "course": entry.course,
                      "yearLevel": entry.yearLevel,
                      "block": entry.block,
                      "presents":
                          entry.status.toLowerCase() == 'present' ? 1 : 0,
                      "lates": entry.status.toLowerCase() == 'late' ? 1 : 0,
                      "absents": entry.status.toLowerCase() == 'absent' ? 1 : 0,
                    };
                  } else {
                    if (entry.status.toLowerCase() == 'present') {
                      mergedData[key]!["presents"] += 1;
                    } else if (entry.status.toLowerCase() == 'late') {
                      mergedData[key]!["lates"] += 1;
                    } else {
                      mergedData[key]!["absents"] += 1;
                    }
                  }
                }

                List<Map<String, dynamic>> result = mergedData.values.toList();

                // sort alphabetically if selected
                if (sortName) {
                  result.sort((a, b) {
                    return (a['fullName'] as String)
                        .compareTo((b['fullName'] as String));
                  });
                }

                return Column(
                  children: [
                    // ! SELECTED FILTER
                    Text(
                      (selectedFilters['course'] as String).isNotEmpty &&
                              (selectedFilters['subject'] as int) != 0 &&
                              (selectedFilters['sched'] as int) != 0
                          ? '${courseAbbreviation} ${(selectedFilters['yearLevel'] as String)[0]}${selectedFilters['block']} - ${subjectName}'
                          : 'NO SCHEDULE SELECTED',
                      style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                    ),
                    Text(
                      (selectedFilters['course'] as String).isNotEmpty &&
                              (selectedFilters['subject'] as int) != 0 &&
                              (selectedFilters['sched'] as int) != 0
                          ? '$schedDetail'
                          : '',
                      style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ! EXPORT BUTTON
                        IconButton(
                          onPressed: () async {
                            try {
                              await AttendancePdf.generate(
                                  result,
                                  selectedDates.start.month ==
                                              selectedDates.end.month &&
                                          selectedDates.start.day ==
                                              selectedDates.end.day &&
                                          selectedDates.start.year ==
                                              selectedDates.end.year
                                      ? '${DateFormat('MMMM dd, yyyy').format(selectedDates.start)}'
                                      : '${DateFormat('MMMM dd, yyyy').format(selectedDates.start)} - ${DateFormat('MMMM dd, yyyy').format(selectedDates.end)}',
                                  true,
                                  (selectedFilters[
                                                  'course'] as String)
                                              .isNotEmpty &&
                                          (selectedFilters['subject'] as int) !=
                                              0 &&
                                          (selectedFilters['sched'] as int) != 0
                                      ? '${courseAbbreviation} ${(selectedFilters['yearLevel'] as String)[0]}${selectedFilters['block']} - ${subjectName}'
                                      : 'NO SCHEDULE SELECTED',
                                  (selectedFilters[
                                                  'course'] as String)
                                              .isNotEmpty &&
                                          (selectedFilters['subject'] as int) !=
                                              0 &&
                                          (selectedFilters['sched'] as int) != 0
                                      ? '$schedDetail'
                                      : ''); //! Pass the data
                            } catch (e) {
                              print("error generating pdf: $e");
                            }
                          },
                          icon: Icon(Icons.picture_as_pdf_outlined),
                        ),
                        // ! DATE RANGE PICKER
                        IconButton(
                          onPressed: () async {
                            final DateTimeRange? dateTimeRange =
                                await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            );

                            if (dateTimeRange != null) {
                              // setState(() {
                              //   selectedDates = dateTimeRange;
                              // });
                              ref
                                  .read(selectedDateRangeProvider.notifier)
                                  .state = dateTimeRange;
                            }
                          },
                          icon: Icon(Icons.date_range),
                        ),
                        // ! SORT BUTTON
                        IconButton(
                          color: sortName ? Color(0xff16A637) : Colors.black87,
                          onPressed: () {
                            ref.read(sortNameProvider.notifier).state =
                                !sortName;
                            // ignore: unused_result
                            ref.refresh(attendanceDataProvider);
                            // ignore: unused_result
                            ref.refresh(studentListProvider);
                          },
                          icon: Icon(Icons.sort_by_alpha_rounded),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // ! FILTERS
                        StyledButton(
                          btnText: "Filters",
                          onClick: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => FilterPage(),
                              ),
                            );
                          },
                          btnColor: Colors.white,
                          btnIcon: Icon(Icons.tune),
                          iconOnRight: true,
                          noShadow: true,
                          borderRadius: BorderRadius.circular(50),
                          textSize: 16,
                          textColor: Colors.black,
                          isBorder: true,
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          btnHeight: 40,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final DateTimeRange? dateTimeRange =
                            await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000),
                        );

                        if (dateTimeRange != null) {
                          ref.read(selectedDateRangeProvider.notifier).state =
                              dateTimeRange;
                        }
                      },
                      child: Center(
                        child: Text(selectedDates.start.month ==
                                    selectedDates.end.month &&
                                selectedDates.start.day ==
                                    selectedDates.end.day &&
                                selectedDates.start.year ==
                                    selectedDates.end.year
                            ? '${DateFormat('MMMM dd, yyyy').format(selectedDates.start)}'
                            : '${DateFormat('MMMM dd, yyyy').format(selectedDates.start)} - ${DateFormat('MMMM dd, yyyy').format(selectedDates.end)}'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FixedColumnWidth(50),
                          1: FlexColumnWidth(),
                          2: FixedColumnWidth(65),
                          3: FixedColumnWidth(60),
                          // 3: FixedColumnWidth(120.0),
                          4: FixedColumnWidth(55),
                        },
                        border: TableBorder
                            .all(), // Allows to add a border decoration around your table
                        children: [
                          TableRow(
                              decoration: BoxDecoration(
                                color: Color(0xFFCDCDCD), // Set the color here
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    'No.',
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
                                    'Name',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  child: Text(
                                    'Present (Total)',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  child: Text(
                                    'Absent (Total)',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 4),
                                  child: Text(
                                    'Late (Total)',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ]),
                          // display the results
                          for (final student in result)
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  '${result.indexOf(student) + 1}',
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  student['fullName'],
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Text(
                                  student['presents'].toString(),
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Text(
                                  student['absents'].toString(),
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Text(
                                  student['lates'].toString(),
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ])
                        ]),

                    // //! EXPORT BUTTON
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // StyledButton(
                    //     noShadow: true,
                    //     btnIcon: Icon(Icons.picture_as_pdf),
                    //     iconOnRight: true,
                    //     btnText: "Export to Pdf",
                    //     onClick: () async {})
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  String getDayName(DateTime date) {
    return DateFormat('EEEE')
        .format(date); // Returns full day name (e.g., Monday)
  }
}
