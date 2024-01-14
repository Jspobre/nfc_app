import 'package:flutter/material.dart';
import 'package:nfc_app/widgets/styledButton.dart';
import 'package:nfc_app/widgets/styledTextFormField.dart';
import 'package:nfc_app/widgets/textfield%20container/textfieldContainer.dart';

class AddStudent extends StatefulWidget {
  AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final studentNumController = TextEditingController();

  final studentNameController = TextEditingController();

  String? isIrregular;
  String? selectedCourse;
  String? selectedYearLevel;
  String? selectedBlock;

  final String errorText = "Required";
  bool showErrorTextIrreg = false;
  bool showErrorTextCourse = false;
  bool showErrorTextYearLevel = false;
  bool showErrorTextBlock = false;

  final _registrationFormKey = GlobalKey<FormState>();
  // used for validation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white10,
        title: const Text(
          "Add Student Details",
          style: TextStyle(fontFamily: "Roboto", fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  // HEADER
                  Column(
                    children: [
                      // top green
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
                                bottomRight: Radius.circular(4))),
                        child: const Column(
                          children: [
                            Text(
                              "Attendance",
                              style:
                                  TextStyle(fontFamily: "Roboto", fontSize: 24),
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
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // FORM
                  Form(
                      key: _registrationFormKey,
                      child: Column(
                        children: [
                          TextFieldContainer(
                            label: "BU Student Number",
                            inputWidget: StyledTextFormField(
                                controller: studentNumController,
                                hintText: "Your student number"),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFieldContainer(
                            label: "Student Name",
                            example:
                                "Last Name, First Name, MI. Extension Name (e.g JR, II)",
                            inputWidget: StyledTextFormField(
                                controller: studentNameController,
                                hintText: "Your name"),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFieldContainer(
                            label: "Irregular Student",
                            inputWidget: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile<String>(
                                  title: const Text('Yes'),
                                  value: 'Yes',
                                  groupValue: isIrregular,
                                  onChanged: (value) {
                                    setState(() {
                                      isIrregular = value!;
                                      showErrorTextIrreg = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('No'),
                                  value: 'No',
                                  groupValue: isIrregular,
                                  onChanged: (value) {
                                    setState(() {
                                      isIrregular = value!;
                                      showErrorTextIrreg = false;
                                    });
                                  },
                                ),
                                showErrorTextIrreg == true
                                    ? Text(
                                        errorText,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 192, 0, 0),
                                            fontSize: 12),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFieldContainer(
                            label: "Course",
                            inputWidget: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile<String>(
                                  title: const Text(
                                      'Bachelor of Science in Computer Science'),
                                  value:
                                      'Bachelor of Science in Computer Science',
                                  groupValue: selectedCourse,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCourse = value!;
                                      showErrorTextCourse = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text(
                                      'Bachelor of Science in Information System'),
                                  value:
                                      'Bachelor of Science in Information System',
                                  groupValue: selectedCourse,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCourse = value!;
                                      showErrorTextCourse = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text(
                                      'Bachelor of Science in Information Technology'),
                                  value:
                                      'Bachelor of Science in Information Technology',
                                  groupValue: selectedCourse,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCourse = value!;
                                      showErrorTextCourse = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text(
                                      'Bachelor of Science in Information Technology major in Animation'),
                                  value:
                                      'Bachelor of Science in Information Technology major in Animation',
                                  groupValue: selectedCourse,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCourse = value!;
                                      showErrorTextCourse = false;
                                    });
                                  },
                                ),
                                showErrorTextCourse == true
                                    ? Text(
                                        errorText,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 192, 0, 0),
                                            fontSize: 12),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFieldContainer(
                            label: "Year Level",
                            inputWidget: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile<String>(
                                  title: const Text('1st Year'),
                                  value: '1st Year',
                                  groupValue: selectedYearLevel,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedYearLevel = value!;
                                      showErrorTextYearLevel = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('2nd Year'),
                                  value: '2nd Year',
                                  groupValue: selectedYearLevel,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedYearLevel = value!;
                                      showErrorTextYearLevel = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('3rd Year'),
                                  value: '3rd Year',
                                  groupValue: selectedYearLevel,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedYearLevel = value!;
                                      showErrorTextYearLevel = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('4th Year'),
                                  value: '4th Year',
                                  groupValue: selectedYearLevel,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedYearLevel = value!;
                                      showErrorTextYearLevel = false;
                                    });
                                  },
                                ),
                                showErrorTextYearLevel == true
                                    ? Text(
                                        errorText,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 192, 0, 0),
                                            fontSize: 12),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFieldContainer(
                            label: "Block",
                            inputWidget: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile<String>(
                                  title: const Text('A'),
                                  value: 'A',
                                  groupValue: selectedBlock,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBlock = value!;
                                      showErrorTextBlock = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('B'),
                                  value: 'B',
                                  groupValue: selectedBlock,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBlock = value!;
                                      showErrorTextBlock = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('C'),
                                  value: 'C',
                                  groupValue: selectedBlock,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBlock = value!;
                                      showErrorTextBlock = false;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('D'),
                                  value: 'D',
                                  groupValue: selectedBlock,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBlock = value!;
                                      showErrorTextBlock = false;
                                    });
                                  },
                                ),
                                showErrorTextBlock == true
                                    ? Text(
                                        errorText,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 192, 0, 0),
                                            fontSize: 12),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          // Submit btn
                          StyledButton(btnText: "SUBMIT", onClick: handleSubmit)
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleSubmit() {
    if (!_registrationFormKey.currentState!.validate() ||
        isIrregular == null ||
        selectedBlock == null ||
        selectedCourse == null ||
        selectedYearLevel == null) {
      if (isIrregular == null) {
        setState(() {
          showErrorTextIrreg = true;
        });
      }
      if (selectedBlock == null) {
        setState(() {
          showErrorTextBlock = true;
        });
      }
      if (selectedCourse == null) {
        setState(() {
          showErrorTextCourse = true;
        });
      }
      if (selectedYearLevel == null) {
        setState(() {
          showErrorTextYearLevel = true;
        });
      }
      return;
    } else {
      print(studentNumController.text);
    }
  }
}
