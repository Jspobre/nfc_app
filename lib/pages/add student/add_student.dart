import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool isLoading = false;

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
                                label: "Irregular Student",
                                inputWidget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Yes',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: 'Yes',
                                      groupValue: isIrregular,
                                      onChanged: (value) {
                                        setState(() {
                                          isIrregular = value!;
                                          showErrorTextIrreg = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'No',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value: 'No',
                                      groupValue: isIrregular,
                                      onChanged: (value) {
                                        setState(() {
                                          isIrregular = value!;
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
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Bachelor of Science in Computer Science',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value:
                                          'Bachelor of Science in Computer Science',
                                      groupValue: selectedCourse,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCourse = value!;
                                          showErrorTextCourse = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Bachelor of Science in Information System',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value:
                                          'Bachelor of Science in Information System',
                                      groupValue: selectedCourse,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCourse = value!;
                                          showErrorTextCourse = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Bachelor of Science in Information Technology',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value:
                                          'Bachelor of Science in Information Technology',
                                      groupValue: selectedCourse,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCourse = value!;
                                          showErrorTextCourse = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Bachelor of Science in Information Technology major in Animation',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      value:
                                          'Bachelor of Science in Information Technology major in Animation',
                                      groupValue: selectedCourse,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCourse = value!;
                                          showErrorTextCourse = false;
                                        });
                                      },
                                      activeColor: Color(0xff16A637),
                                    ),
                                    showErrorTextCourse == true
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
                                    handleSubmit(context);
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

  Future<void> handleSubmit(BuildContext context) async {
    // IF FORM IS EMPTY OR SKIPPED
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
      setState(() {
        isLoading = true;
      });
      // IF FORM IS NOT EMPTY
      try {
        final studentNum = studentNumController.text;
        final studentName = studentNameController.text;
        final isIrregStatus = isIrregular;
        final courseName = selectedCourse;
        final yearLevel = selectedYearLevel;
        final block = selectedBlock;

        // CHECK FIRST IF STUDENT EXIST
        final existingStudent = await FirebaseFirestore.instance
            .collection('students')
            .where('student_num', isEqualTo: studentNum)
            .get();

        if (existingStudent.docs.isNotEmpty) {
          // Student already exists, show an error or take necessary action
          Fluttertoast.showToast(
            msg: "A student with this Student Number already exists!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 214, 214, 214),
            textColor: Colors.black,
            fontSize: 16.0,
          );
          setState(() {
            isLoading = false;
          });
          return;
        }

        // INSERT STUDENT

        FirebaseFirestore.instance.collection('students').add({
          'student_num': studentNum,
          'full_name': studentName,
          'is_irregular': isIrregStatus,
          'course': courseName,
          'year_level': yearLevel,
          'block': block
        }).then((_) {
          setState(() {
            studentNumController.clear();
            studentNameController.clear();
            isIrregular = null;
            selectedCourse = null;
            selectedYearLevel = null;
            selectedBlock = null;
            isLoading = false;
          });

          Fluttertoast.showToast(
              msg: "Student Added!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(255, 214, 214, 214),
              textColor: Colors.black,
              fontSize: 16.0);
          print("Student added");
        }).catchError((e) {
          print('Failed to add student: $e');
          setState(() {
            isLoading = false;
          });
        });
      } catch (e) {
        print('error inserting data: $e');
      }
    }
  }
}
