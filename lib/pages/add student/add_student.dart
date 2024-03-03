import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_app/database/database_service.dart';
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

  String? selectedGender;
  String? selectedCourse;
  String? selectedYearLevel;
  String? selectedBlock;

  final String errorText = "Required";
  bool showErrorTextIrreg = false;
  bool showErrorTextCourse = false;
  bool showErrorTextYearLevel = false;
  bool showErrorTextBlock = false;
  bool isLoading = false;

  final _registrationFormKey = GlobalKey<FormState>();
  // used for validation

  // Function for inserting student
  void _insertStudent() async {
    final String studentNumber = studentNumController.text;
    final String studentName = studentNameController.text;
    final String gender = selectedGender ?? '';
    final String courseName = selectedCourse ?? '';
    final String yearLevel = selectedYearLevel ?? '';
    final String block = selectedBlock ?? '';

    try {
      // Insert the subject into the database
      await DatabaseService().insertStudent(
        studentNumber,
        studentName,
        gender,
        courseName,
        block,
        yearLevel,
      );

      // Display success message
      Fluttertoast.showToast(
        msg: 'Student: $studentName added!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      // Print variables if successfully inserted
      print('Student Number: $studentNumber');
      print('Student Name: $studentName');
      print('Gender: $gender');
      print('Course Name: $courseName');
      print('Year Level: $yearLevel');
      print('Block: $block');
    } catch (error) {
      // Handle errors
      print('Error inserting student: $error');

      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inserting student: $error'),
        ),
      );
    }
  }

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
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      // HEADER
                      Column(
                        children: [
                          Image.asset(
                            'lib/images/nfc2.png',
                            width: 150,
                            height: 150,
                          ),
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
                                  style: TextStyle(
                                      fontFamily: "Roboto", fontSize: 24),
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
                                label: "Gender",
                                inputWidget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Male',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: 'Male',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value!;
                                          showErrorTextIrreg = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Female',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: 'Female',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value!;
                                          showErrorTextIrreg = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    showErrorTextIrreg == true
                                        ? Text(
                                            errorText,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 192, 0, 0),
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
                                    SizedBox(
                                      // height: 65,
                                      // width: 65,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: selectedCourse,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedCourse = newValue ?? '';
                                          });
                                        },
                                        items: [
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value:
                                                "Bachelor of Elementary Education",
                                            child: Text(
                                              "BEEd",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
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
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value:
                                                "Bachelor of Science in Nursing",
                                            child: Text(
                                              "BSN",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          // Add your new courses here
                                        ],
                                      ),
                                    ),
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
                                      title: const Text(
                                        '1st Year',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: '1st Year',
                                      groupValue: selectedYearLevel,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedYearLevel = value!;
                                          showErrorTextYearLevel = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        '2nd Year',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: '2nd Year',
                                      groupValue: selectedYearLevel,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedYearLevel = value!;
                                          showErrorTextYearLevel = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        '3rd Year',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: '3rd Year',
                                      groupValue: selectedYearLevel,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedYearLevel = value!;
                                          showErrorTextYearLevel = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        '4th Year',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: '4th Year',
                                      groupValue: selectedYearLevel,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedYearLevel = value!;
                                          showErrorTextYearLevel = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    showErrorTextYearLevel == true
                                        ? Text(
                                            errorText,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 192, 0, 0),
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
                                      title: const Text(
                                        'A',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: 'A',
                                      groupValue: selectedBlock,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBlock = value!;
                                          showErrorTextBlock = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'B',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: 'B',
                                      groupValue: selectedBlock,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBlock = value!;
                                          showErrorTextBlock = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'C',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: 'C',
                                      groupValue: selectedBlock,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBlock = value!;
                                          showErrorTextBlock = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'D',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: 'D',
                                      groupValue: selectedBlock,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBlock = value!;
                                          showErrorTextBlock = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    showErrorTextBlock == true
                                        ? Text(
                                            errorText,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 192, 0, 0),
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
                              StyledButton(
                                  btnText: "Submit",
                                  onClick: () {
                                    _insertStudent();
                                  })
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff16A637),
                ),
              )
          ],
        ),
      ),
    );
  }
}
