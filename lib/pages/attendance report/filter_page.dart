import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_app/provider/filterPage_provider.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class FilterPage extends ConsumerWidget {
  FilterPage({super.key});

  final List<String> courses = [
    'Bachelor of Science in Computer Science',
    'Bachelor of Science in Information System',
    'Bachelor of Science in Information Technology',
    'Bachelor of Science in Information Technology major in Animation',
    'Bachelor of Science in Electronics Engineering',
    'Bachelor of Science in Computer Engineering',
    'Bachelor of Elementary Education',
    'Bachelor of Secondary Education major in Math',
    'Bachelor of Secondary Education major in English',
    'Bachelor of Technology and Livelihood Education major in ICT',
    'Bachelor of Technology and Livelihood Education major in HE',
    'Bachelor of Science in Automotive Technology',
    'Bachelor of Science in Electronics Technology',
    'Bachelor of Science in Entrepreneurship',
    'Bachelor of Science in Nursing',
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedCourse = ref.watch(selectedCourseProvider);
    String selectedYear = ref.watch(selectedYearProvider);
    String selectedBlock = ref.watch(selectedBlockProvider);
    String selectedSubject = ref.watch(selectedSubjectProvider);
    String selectedSched = ref.watch(selectedSchedProvider);
    String selectedGender = ref.watch(selectedGenderProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close), // Close icon
          onPressed: () {
            Navigator.pop(context);
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
                    },
                    items: [
                      for (final course in courses)
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
                          newValue ?? '';
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
                          newValue ?? '';
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
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSubject, // Current selected value
                    onChanged: (String? newValue) {
                      ref.read(selectedSubjectProvider.notifier).state =
                          newValue ?? '';
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: "Capstone",
                        child: Text(
                          "Capstone",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "Sheesh",
                        child: Text(
                          "Sheesh",
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
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSched, // Current selected value
                    onChanged: (String? newValue) {
                      ref.read(selectedSchedProvider.notifier).state =
                          newValue ?? '';
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: "Monday, 9AM - 12PM",
                        child: Text(
                          "Monday, 9AM - 12PM",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "Monday, 1PM - 3PM",
                        child: Text(
                          "Monday, 1PM - 3PM",
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
                    print("before");
                    print(ref.watch(filterProvider));
                    ref.read(filterProvider.notifier).state = {
                      'course': selectedCourse,
                      'yearLevel': selectedYear,
                      'block': selectedBlock,
                      'subject': selectedSubject,
                      'sched': selectedSched,
                      'gender': selectedGender,
                    };
                    print("after");
                    print(ref.watch(filterProvider));
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
