import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_app/provider/attendanceData_provider.dart';
import 'package:nfc_app/provider/filterPage_provider.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class FilterPage extends ConsumerWidget {
  FilterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // states for each dropdown
    String selectedCourse = ref.watch(selectedCourseProvider);
    String selectedYear = ref.watch(selectedYearProvider);
    String selectedBlock = ref.watch(selectedBlockProvider);
    int selectedSubject = ref.watch(selectedSubjectProvider);
    int selectedSched = ref.watch(selectedSchedProvider);
    String selectedGender = ref.watch(selectedGenderProvider);

    // fetch dynamic course
    final courseOptionsFuture = ref.watch(courseSelectionProvider);
    print("course options:");
    print(courseOptionsFuture);

    final List<String> courseOptions = courseOptionsFuture.when(
      data: (data) {
        print(data);
        return data;
      },
      error: (error, stackTrace) => [],
      loading: () => [],
    );

// fetch dynamic subject based on selected course
    final subjectOptionsFuture = ref.watch(subjectOptionsProvider);

    final List<Map<String, dynamic>> subjectOptions = subjectOptionsFuture.when(
      data: (data) {
        return data;
      },
      loading: () => [], // Return empty list while loading
      error: (error, stackTrace) => [], // Return empty list in case of error
    );

// fetch dynamic sched based on selected subject
    final schedOptionsFuture = ref.watch(schedOptionsProvider);

    final List<Map<String, dynamic>> schedOptions = schedOptionsFuture.when(
      data: (data) {
        return data;
      },
      loading: () => [], // Return empty list while loading
      error: (error, stackTrace) => [], // Return empty list in case of error
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close), // Close icon
          onPressed: () {
            Navigator.pop(context);
            ref.read(selectedCourseProvider.notifier).state = '';
            ref.read(selectedSubjectProvider.notifier).state = 0;
            ref.read(selectedSchedProvider.notifier).state = 0;
          },
        ),
        title: Text(
          'Filters',
          style: TextStyle(fontFamily: "Roboto", fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ! COURSE SELECTER
                Text(
                  "Course:".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Dropdown
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCourse, // Current selected value
                    onChanged: (String? newValue) {
                      ref.read(selectedCourseProvider.notifier).state =
                          newValue ?? '';
                      ref.read(selectedSubjectProvider.notifier).state = 0;
                      ref.read(selectedSchedProvider.notifier).state = 0;
                    },
                    items: [
                      DropdownMenuItem<String>(
                        enabled: false,
                        value: '',
                        child: Text(
                          'Select Course',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                      for (final course in courseOptions)
                        DropdownMenuItem<String>(
                          value: course,
                          child: Text(
                            course,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //! YEAR LEVEL SELECTOR
                Text(
                  "Year Level".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Dropdown
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedYear, // Current selected value
                    onChanged: (String? newValue) {
                      ref.read(selectedYearProvider.notifier).state =
                          newValue ?? "1st Year";
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: "1st Year",
                        child: Text(
                          "1st Year",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "2nd Year",
                        child: Text(
                          "2nd Year",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "3rd Year",
                        child: Text(
                          "3rd Year",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "4th Year",
                        child: Text(
                          "4th Year",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //! BLOCK SELECTOR
                Text(
                  "Block:".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Dropdown
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedBlock, // Current selected value
                    onChanged: (String? newValue) {
                      ref.read(selectedBlockProvider.notifier).state =
                          newValue ?? 'A';
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
                const SizedBox(
                  height: 20,
                ),
                //! SUBJECT SELECTOR
                Text(
                  "Subject:".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Dropdown
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: selectedSubject, // Current selected value
                    onChanged: (int? newValue) {
                      ref.read(selectedSubjectProvider.notifier).state =
                          newValue ?? 0;
                      ref.read(selectedSchedProvider.notifier).state = 0;
                    },
                    items: [
                      DropdownMenuItem<int>(
                        enabled: false,
                        value: 0,
                        child: Text(
                          'Select subject',
                          style: const TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      for (final option in subjectOptions)
                        DropdownMenuItem<int>(
                          value: option['subject_id'] as int,
                          child: Text(
                            option['subject_name'] as String,
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                    // items: subjectOptions.map((subject) {
                    //   return DropdownMenuItem<int>(
                    //     value: subject['subject_id'] as int,
                    //     child: Text(
                    //       subject['subject_name'] as String,
                    //       style: const TextStyle(
                    //         fontFamily: "Roboto",
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //   );
                    // }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //! SCHED SELECTOR
                Text(
                  "SCHEDULE:".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Dropdown
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: selectedSched, // Current selected value
                    onChanged: (int? newValue) {
                      ref.read(selectedSchedProvider.notifier).state =
                          newValue ?? 1;
                    },
                    items: [
                      DropdownMenuItem<int>(
                        enabled: false,
                        value: 0,
                        child: Text(
                          "Select Sched",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      for (final options in schedOptions)
                        DropdownMenuItem<int>(
                          value: options['schedule_id'],
                          child: Text(
                            '${options['day']}, ${options['start_time']} - ${options['end_time']}',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //! Gender SELECTOR
                Text(
                  "Gender:".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Dropdown
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedGender, // Current selected value
                    onChanged: (String? newValue) {
                      ref.read(selectedGenderProvider.notifier).state =
                          newValue ?? '';
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: "All",
                        child: Text(
                          "All",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "Male",
                        child: Text(
                          "Male",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "Female",
                        child: Text(
                          "Female",
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
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            // color: Color(0xFFF3F3F3),
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.10), // Color of the shadow
                spreadRadius: 2, // Spread radius
                blurRadius: 3, // Blur radius
                offset: Offset(0, 0), // Offset of the shadow
              ),
            ]),
        height: 75,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: StyledButton(
                  noShadow: true,
                  btnText: "Apply",
                  onClick: () {
                    // set the state for the selected filters
                    ref.read(filterProvider.notifier).state = {
                      'course': selectedCourse,
                      'yearLevel': selectedYear,
                      'block': selectedBlock,
                      'subject': selectedSubject,
                      'sched': selectedSched,
                      'gender': selectedGender,
                    };

                    // reset dynamic dropdowns to prevent error
                    ref.read(selectedCourseProvider.notifier).state = '';
                    ref.read(selectedSubjectProvider.notifier).state = 0;
                    ref.read(selectedSchedProvider.notifier).state = 0;

                    // ignore: unused_result
                    ref.refresh(attendanceDataProvider);
                    // ignore: unused_result
                    ref.refresh(studentListProvider);

                    // close page after applying
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
