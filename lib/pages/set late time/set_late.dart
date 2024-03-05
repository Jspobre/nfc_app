import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_app/database/database_service.dart';
import 'package:nfc_app/widgets/styledButton.dart';
import 'package:nfc_app/widgets/styledTextFormField.dart';
import 'package:nfc_app/widgets/textfield%20container/textfieldContainer.dart';
import 'package:sqflite/sqflite.dart';

class SetLateFormPage extends StatefulWidget {
  const SetLateFormPage({super.key});

  @override
  State<SetLateFormPage> createState() => _SetLateFormPageState();
}

class _SetLateFormPageState extends State<SetLateFormPage> {
  final minutesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Set Late Time",
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
                      "Automated Attendance Monitoring and Tracking System using NFC Tags",
                      style: TextStyle(fontFamily: "Roboto"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextFieldContainer(
                label: "Time Limit Before Late",
                example: "Enter in number of minutes (10, 15, 30)",
                inputWidget: StyledTextFormField(
                  controller: minutesController,
                  hintText: "Mins",
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 20), // Adjust spacing as needed
              StyledButton(
                btnText: 'Save',
                onClick: () async {
                  if (minutesController.text.isNotEmpty) {
                    final dbService = DatabaseService();

                    dbService.insertLateTimeLimit(
                        int.parse(minutesController.text.trim()));
                    Fluttertoast.showToast(
                      msg: 'Time Limit was set successfully!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );

                    setState(() {
                      minutesController.clear();
                    });

                    var result = await dbService
                        .fetchLateTimeLimit(); // Wait for the future to complete

                    print(result);
                  }
                },
              ),
              SizedBox(height: 20), // Add additional spacing at the end
            ],
          ),
        ),
      ),
    );
  }
}
