import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:nfc_app/pages/add%20student/add_student.dart';
import 'package:nfc_app/pages/attendance%20report/attendance_report.dart';
import 'package:nfc_app/widgets/bottom%20sheet%20modal/floating_modal.dart';
import 'package:nfc_app/widgets/styledButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _platformVersion = '';
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _result, _writeResult, _mifareResult;
  ndef.NDEFRecord? _record;
  String tappedStudentInfo = '';
  String? tappedFullName;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    if (!mounted) return;

    setState(() {
      _availability = availability;
    });
  }

  Future<List<DocumentSnapshot>> fetchDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('students').get();

      List<DocumentSnapshot> documents = querySnapshot.docs;
      return documents;
    } catch (e) {
      print("Error fetching data from Firestore: $e");
      return [];
    }
  }

// Function to write NFC data

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

              items.add(
                const PopupMenuItem<String>(
                  value: 'addstudent',
                  child: Text(
                    'Add student details',
                    style: TextStyle(fontFamily: "Roboto"),
                  ),
                ),
              );
              items.add(
                const PopupMenuItem<String>(
                  value: 'attendance',
                  child: Text(
                    'View attendance',
                    style: TextStyle(fontFamily: "Roboto"),
                  ),
                ),
              );
              items.add(
                const PopupMenuItem<String>(
                  value: 'reset',
                  child: Text(
                    "Reset tag",
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
                  setState(() {
                    _writeResult = null;
                  });
                  writeEmptyRawRecordToNFC(context);
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
              Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Welcome to NFC: Tag Reader",
                    style: TextStyle(fontFamily: "Roboto", fontSize: 20),
                  ),
                  if (tappedStudentInfo.isNotEmpty)
                    Text(
                      tappedStudentInfo,
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 18,
                        color: Colors.black,
                      ),
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
                      showFloatingModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            FutureBuilder<List<DocumentSnapshot>>(
                          future: fetchDataFromFirestore(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text("No data available");
                            } else {
                              List<DocumentSnapshot> documents = snapshot.data!;
                              return SizedBox(
                                height: 400,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    for (DocumentSnapshot document in documents)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            tappedStudentInfo =
                                                "Tapped Student Number: ${document['student_num']}, Full Name: ${document['full_name']}";
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[
                                                200], // Adjust the color as needed
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Student Number: ${document['student_num']}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Full Name: ${document['full_name']}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ElevatedButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                    noShadow: true,
                    btnWidth: double.infinity,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> writeEmptyRawRecordToNFC(BuildContext context) async {
    showFloatingModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _writeResult == "OK"
                ? const SizedBox()
                : const Text(
                    "Ready to Scan",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xff939393),
                    ),
                  ),
            Image.asset(_writeResult == "OK"
                ? 'lib/images/image 2.png'
                : 'lib/images/image 4.png'),
            const Text(
              "Approach an NFC Tag",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            _writeResult == "OK"
                ? const SizedBox()
                : StyledButton(
                    noShadow: true,
                    textColor: Colors.black,
                    btnColor: const Color(0xffCECECE),
                    btnText: "Cancel",
                    onClick: () async {
                      await FlutterNfcKit.finish();
                      Navigator.pop(context);
                    }),
          ],
        ),
      ),
    );
  }
}
