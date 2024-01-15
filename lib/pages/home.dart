import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nfc_app/pages/add%20student/add_student.dart';
import 'package:nfc_app/pages/attendance%20report/attendance_report.dart';
import 'package:nfc_app/widgets/bottom%20sheet%20modal/floating_modal.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NFC: Tag Reader",
          style: TextStyle(fontFamily: "Roboto", fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Image.asset('lib/images/image 3.png'),
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> items = [];

              // POPUP MENU ITEMS - ADD STUDENT
              items.add(
                const PopupMenuItem<String>(
                  value: 'addstudent',
                  child: Text(
                    'Add student details',
                    style: TextStyle(fontFamily: "Roboto"),
                  ),
                ),
              );
              // POPUP MENU ITEMS - View Attendance
              items.add(
                const PopupMenuItem<String>(
                  value: 'attendance',
                  child: Text(
                    'View Attendance',
                    style: TextStyle(fontFamily: "Roboto"),
                  ),
                ),
              );
              // POPUP MENU ITEMS - RESET NFC TAG
              items.add(
                const PopupMenuItem<String>(
                  value: 'reset',
                  child: Text(
                    "Reset Tag",
                    style: TextStyle(fontFamily: "Roboto"),
                  ),
                ),
              );

              return items;
            },
            onSelected: (String value) {
              switch (value) {
                case 'addstudent':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return AddStudent();
                    }),
                  );
                  break;
                case 'attendance':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return AttendanceReport();
                    }),
                  );

                  break;
                case 'reset':
                  showFloatingModalBottomSheet(
                    context: context,
                    builder: (context) => SizedBox(
                      height: 400,
                      child: Center(
                        child: ElevatedButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 44),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Welcome to NFC: Tag Reader",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 20),
                ),
              ],
            ),
            Image.asset(
              'lib/images/image 1.png',
            ),
            Column(
              children: [
                StyledButton(
                  btnText: "Read",
                  onClick: () {
                    // exmaple
                    showFloatingModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox(
                        height: 400,
                        child: Center(
                          child: ElevatedButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  noShadow: true,
                  btnWidth: double.infinity,
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledButton(
                  btnText: "Write",
                  onClick: () {
                    // example
                    showFloatingModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox(
                        height: 400,
                        child: Center(
                          child: ElevatedButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  noShadow: true,
                  btnWidth: double.infinity,
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
