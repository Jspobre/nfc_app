import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/api/attendance_pdf.dart';
import 'package:nfc_app/database/database_service.dart';
import 'package:nfc_app/model/fetch_data.dart';
import 'package:nfc_app/pages/attendance%20report/filter_page.dart';
import 'package:nfc_app/provider/attendanceData_provider.dart';
import 'package:nfc_app/provider/date_provider.dart';
import 'package:nfc_app/provider/filterPage_provider.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class AttendanceSection extends ConsumerWidget {
  const AttendanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilters = ref.watch(filterProvider);
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer(
              builder: ((context, ref, child) {
                final attendanceList = ref.watch(attendanceDataProvider);
                final studentList = ref.watch(studentListProvider);
                int dayValue = ref.watch(dayValueProvider);
                int monthValue = ref.watch(monthValueProvider);
                DateTime? datePickerSelected =
                    ref.watch(datePickerSelectedProvider);
                DateTime selectedDay = (datePickerSelected ?? DateTime.now())
                    .add(Duration(days: dayValue));
                DateTime selectedMonth = DateTime(selectedDay.year,
                    selectedDay.month + monthValue, selectedDay.day);
                // Format the current date into "MONTH DAY, YEAR" format
                String formattedDate =
                    DateFormat('MMMM dd, yyyy').format(selectedMonth);

                print(formattedDate);

                // Filter the attendance data with the selected month
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
                      print('data datetime:');
                      print(element.datetime);
                      print('selected month');
                      print(selectedMonth);
                      return element.datetime.day == selectedMonth.day &&
                          element.datetime.year == selectedMonth.year &&
                          element.datetime.month == selectedMonth.month;
                    }).toList();
                  },
                  error: (error, stackTrace) => [],
                  loading: () => [],
                );

                List<IndivStudent> absentStudents = studentList.when(
                  data: (data) {
                    return data.where((element) {
                      return selectedFilters['course'] == element.course &&
                          selectedFilters['block'] == element.block &&
                          selectedFilters['yearLevel'] == element.yearLevel &&
                          selectedFilters['subject'] == element.subjectId &&
                          (selectedFilters['gender'] == element.gender ||
                              selectedFilters['gender'] == 'All');
                    }).where((element) {
                      return !filteredAttendance.any((attendance) =>
                          attendance.fullName == element.fullName);
                    }).toList();
                  },
                  error: (error, stackTrace) => [],
                  loading: () => [],
                );

                // Merge filteredAttendance and absentStudents lists
                List<dynamic> mergedList = List.from(filteredAttendance)
                  ..addAll(absentStudents);

                print("present students:");
                print(filteredAttendance);
                print("absent students:");
                print(absentStudents);
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ! EXPORT BTN
                        // StyledButton(
                        //   btnText: "Export",
                        //   onClick: () {},
                        //   padding:
                        //       EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        //   btnHeight: 40,
                        //   textSize: 16,
                        //   btnIcon: Icon(Icons.picture_as_pdf_outlined),
                        //   iconOnRight: true,
                        // ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await AttendancePdf.generate(
                                  mergedList, formattedDate); //! Pass the data
                            } catch (e) {
                              print("error generating pdf: $e");
                            }
                          },
                          icon: Icon(
                            Icons.picture_as_pdf_outlined,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // ! FILTER BTN
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
                    // DATE SELECTOR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            // setState(() {
                            ref.read(monthValueProvider.notifier).state--;
                            // monthValue--;
                            // });
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_left),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () {
                            // setState(() {
                            // dayValue--;
                            ref.read(dayValueProvider.notifier).state--;
                            // });
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
                                      primary:
                                          Color(0xff16A637), // <-- SEE HERE
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
                              // setState(
                              //   () {
                              ref
                                  .read(datePickerSelectedProvider.notifier)
                                  .state = dateTime;
                              // datePickerSelected = dateTime;
                              ref.read(dayValueProvider.notifier).state = 0;
                              // dayValue = 0;
                              // monthValue = 0;
                              ref.read(monthValueProvider.notifier).state = 0;
                              //   },
                              // );
                            }
                          },
                          child: Text(
                            formattedDate,
                            style:
                                TextStyle(fontFamily: "Roboto", fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // setState(() {
                            dayValue++;
                            ref.read(dayValueProvider.notifier).state++;
                            // });
                          },
                          icon: const Icon(Icons.chevron_right),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () {
                            // setState(() {
                            monthValue++;
                            ref.read(monthValueProvider.notifier).state++;
                            // });
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_right),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),

                    // const SizedBox(
                    //   height: 10,
                    // ),

                    // TABLE DISPLAY

                    Table(
                        columnWidths: const {
                          0: FixedColumnWidth(40),
                          1: FlexColumnWidth(),
                          2: FixedColumnWidth(65.0),
                          3: FixedColumnWidth(100.0),
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
                                      horizontal: 16, vertical: 4),
                                  child: Text(
                                    '${mergedList.length}',
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
                                    'Status',
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
                                    'Time Arrived',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ]),
                          if ((selectedFilters['course'] as String).isEmpty &&
                              (selectedFilters['subject'] as int) == 0 &&
                              (selectedFilters['sched'] as int) == 0)
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  child: Text(
                                    '0',
                                    style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  child: Text(
                                    'Select Filter First',
                                    style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  child: Text(
                                    '',
                                    style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  child: Text(
                                    '',
                                    style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          for (final item in mergedList)
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Text(
                                  '${mergedList.indexOf(item) + 1}',
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Text(
                                  item is AttendanceRaw
                                      ? item.fullName
                                      : (item as IndivStudent).fullName,
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: Text(
                                  item is AttendanceRaw
                                      ? item.status
                                      : 'Absent',
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: Text(
                                  item is AttendanceRaw
                                      ? formatTime(item.datetime)
                                      : '',
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ]),
                        ]),
                    StyledButton(
                        noShadow: true,
                        btnIcon: Icon(Icons.picture_as_pdf),
                        iconOnRight: true,
                        btnText: "insert test data",
                        onClick: () async {
                          print('test insert');
                          final dbService = DatabaseService();

                          final subjectId = await dbService.insertSubject(
                              'test sub',
                              "Bachelor of Science in Information Technology");
                          final schedId = await dbService.insertSched(
                              subjectId, "Wed", "9AM", '12PM');
                          await dbService.insertStudent(
                              '17',
                              'COFFEE BREAK',
                              'Male',
                              'Bachelor of Science in Information Technology',
                              "A",
                              1);

                          await dbService
                              .assignSubject('17', subjectId)
                              .then((value) {
                            print('sheesh');
                          });

                          print(subjectId);
                          print(schedId);
                          await dbService
                              .insertAttendance(
                                  '17',
                                  schedId,
                                  DateTime.now().microsecondsSinceEpoch,
                                  'Present')
                              .then((value) {
                            print('success');
                          });
                          // ignore: unused_result
                          ref.refresh(studentListProvider);
                          // ignore: unused_result
                          ref.refresh(attendanceDataProvider);
                        }),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    final formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
  }
}
