import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_app/database/database_service.dart';
import 'package:nfc_app/widgets/styledButton.dart';
import 'package:nfc_app/widgets/styledTextFormField.dart';
import 'package:nfc_app/widgets/textfield%20container/textfieldContainer.dart';
import 'package:nfc_app/database/nfc_db.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final TextEditingController _subjectController = TextEditingController();

  void _submitSubject() async {
    // Retrieve the subject name from the text field
    String subjectName = _subjectController.text.trim();

    // Print the subject name to verify
    print('Subject name: $subjectName');

    // Perform validation if needed

    // Insert the subject into the database
    await DatabaseService()
        .insertSubject(subjectName, 'Bachelor of Science in Computer Science');

    // Show a toast or message to indicate successful submission
    Fluttertoast.showToast(
      msg: 'Subject: $subjectName added!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Clear the text field after submission
    _subjectController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Subject",
          style: TextStyle(fontFamily: "Roboto", fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'lib/images/nfc2.png', // Replace with your image path
                width: 150, // Adjust width as needed
                height: 150, // Adjust height as needed
              ),
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
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Subject form",
                      style: TextStyle(fontFamily: "Roboto", fontSize: 24),
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
              ),
              SizedBox(height: 10), // Adjust spacing as needed
              TextFieldContainer(
                label: 'Subject Name',
                inputWidget: StyledTextFormField(
                  controller: _subjectController,
                  hintText: 'Enter subject name',
                ),
              ),
              SizedBox(height: 20),
              StyledButton(
                btnText: 'Add Subject',
                onClick: _submitSubject,
              ),
              SizedBox(height: 20), // Add additional spacing at the end
            ],
          ),
        ),
      ),
    );
  }
}
