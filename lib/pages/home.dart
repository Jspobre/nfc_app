// import 'package:flutter/cupertino.dart';
// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:ndef/utilities.dart';
import 'package:nfc_app/pages/add%20schedule/add_schedule.dart';
import 'package:nfc_app/pages/add%20student/add_student.dart';
import 'package:nfc_app/pages/attendance%20report/attendance_report.dart';
import 'package:nfc_app/widgets/bottom%20sheet%20modal/floating_modal.dart';
import 'package:nfc_app/widgets/bottom%20sheet%20modal/modal_inside_modal.dart';
import 'package:nfc_app/widgets/bottom%20sheet%20modal/scan_modal.dart';
import 'package:nfc_app/widgets/styledButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform, sleep;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:collection/collection.dart'; // Import the collection package for the `unmodifiableSet` function
import 'package:nfc_app/pages/add%20subject/add_subject.dart';
import 'package:nfc_app/pages/add%20schedule/add_schedule.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _platformVersion = '';
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _result, _writeResult, _mifareResult, _readResult;
  ndef.NDEFRecord? _record;
  String tappedStudentInfo = '';
  String? tappedFullName;
  bool _scanning = false;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String _lastScannedData = '';
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

  Future<void> showInitialModal() async {
    showFloatingModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _readResult == "OK"
                ? const SizedBox()
                : const Text(
                    "Ready to Scan",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xff939393),
                    ),
                  ),
            Image.asset(_readResult == "OK"
                ? 'lib/images/image 2.png'
                : 'lib/images/image 4.png'),
            const Text(
              "Approach an NFC Tag",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            _readResult == "OK"
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

    await startScanning(); // Start continuous scanning
  }

  Future<void> startScanning() async {
    while (true) {
      try {
        NFCTag tag = await FlutterNfcKit.poll();
        setState(() {
          _tag = tag;
        });
        await FlutterNfcKit.setIosAlertMessage("Working on it...");
        _mifareResult = null;

        if (tag.standard == "ISO 14443-4 (Type B)") {
          String result1 = await FlutterNfcKit.transceive("00B0950000");
          String result2 =
              await FlutterNfcKit.transceive("00A4040009A00000000386980701");
          setState(() {
            _result = '1: $result1\n2: $result2\n';
          });
        } else if (tag.type == NFCTagType.iso18092) {
          String result1 = await FlutterNfcKit.transceive("060080080100");
          setState(() {
            _result = '1: $result1\n';
          });
        } else if (tag.ndefAvailable ?? false) {
          var ndefRecords = await FlutterNfcKit.readNDEFRecords();
          var textContent = '';

          for (int i = 0; i < ndefRecords.length; i++) {
            if (ndefRecords[i] is ndef.TextRecord) {
              // Extract and concatenate text content from TextRecord
              String? recordText = (ndefRecords[i] as ndef.TextRecord).text;
              textContent += recordText ??
                  ''; // Use the null-aware operator to handle null values
            }
          }
          showDetailsContainer(tag, textContent);
          setState(() {
            _result = ' $textContent';
          });
        } else if (tag.type == NFCTagType.webusb) {
          var r = await FlutterNfcKit.transceive("00A4040006D27600012401");
          print(r);
        }
      } catch (e) {
        setState(() {
          _result = 'error: $e';
        });
      }

      if (!kIsWeb) ;
      await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
    }
  }

  void showDetailsContainer(NFCTag tag, String scannedData) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'nfc'); //this is found in android/app/src/main/res/drawable. Can change to other images
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (tag == null || scannedData.isEmpty) {
      // Don't insert data if the NFC tag is empty
      return;
    } else {
      // Check if the same data already exists in the database
      bool dataExists = await checkIfDataExists(scannedData);

      // if (dataExists) {
      //   print('Data already exists in the database: $scannedData');
      //   return; // Skip inserting duplicate data
      // }

      // Check if the current scanned data is the same as the last scanned data
      if (_lastScannedData == scannedData) {
        print('Skipping consecutive duplicate data: $scannedData');
        return;
      }

      _databaseReference.push().set({
        'timestamp': ServerValue.timestamp,
        'tag_data': scannedData,
      }).then((_) {
        print('Data inserted successfully');
      }).catchError((error) {
        print('Error inserting data: $error');
      });

      // Update the last scanned data
      _lastScannedData = scannedData;

      // Split the scannedData to extract full name and student ID
      List<String> dataParts = scannedData.split(' - ');
      String fullName = dataParts[0]; // display only the full name

      // Generate a unique ID based on the hash code of the scannedData to prevent overwrite of the previous notification
      int notificationId = scannedData.hashCode;

      // Configure the notification details
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        '1',
        'My App Notifications',
        channelDescription: 'Notifications for My App',
        importance: Importance.max,
        priority: Priority.max,
        fullScreenIntent: true,
        ticker: 'NFC APP',
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        // Use the dynamically generated ID
        notificationId,
        'ATTENDANCE',
        'Student name:\n$fullName',
        platformChannelSpecifics,
        payload: 'item x',
      );
    }
  }

  Future<bool> checkIfDataExists(String scannedData) async {
    DatabaseEvent event = await _databaseReference.once();

    if (event.snapshot.value != null) {
      // Explicitly cast the value to Map<dynamic, dynamic>
      Map<dynamic, dynamic> entries =
          (event.snapshot.value as Map<dynamic, dynamic>);
      return entries.values.any((entry) => entry['tag_data'] == scannedData);
    }

    return false; // No data in the database, so no duplicate
  }

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
                  value: 'addsubject',
                  child: Text(
                    'Add Subject',
                    style: TextStyle(fontFamily: "Roboto"),
                  ),
                ),
              );
              items.add(
                const PopupMenuItem<String>(
                  value: 'addschedule',
                  child: Text(
                    'Add Schedule',
                    style: TextStyle(fontFamily: "Roboto"),
                  ),
                ),
              );
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
                case 'addsubject':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return AddSubject();
                    }),
                  );
                  break;
                case 'addschedule':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return AddSchedule();
                    }),
                  );
                  break;
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
                  // showBarModalBottomSheet(
                  //   expand: true,
                  //   context: context,
                  //   backgroundColor: Colors.transparent,
                  //   builder: (context) => ModalInsideModal(),
                  //   // CupertinoPageScaffold(
                  //   //   child: Center(child: Text("test"))
                  //   // ),
                  // );
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
                    onClick: () async {
                      await showInitialModal();
                    },
                    noShadow: true,
                    btnWidth: double.infinity,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StyledButton(
                    btnText: "Write",
                    onClick: () async {
                      setState(() {
                        _writeResult = null;
                      });

                      showBarModalBottomSheet(
                        expand: false,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            FutureBuilder<List<DocumentSnapshot>>(
                          future: fetchDataFromFirestore(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CupertinoPageScaffold(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text("No data available");
                            } else {
                              List<DocumentSnapshot> documents = snapshot.data!;
                              return ModalInsideModal(
                                studentsList: documents,
                                selectStudent:
                                    (DocumentSnapshot studentData) async {
                                  await FlutterNfcKit.finish();
                                  setState(() {
                                    tappedStudentInfo =
                                        "${studentData['full_name']} - ${studentData.id}";
                                  });

                                  showFloatingModalBottomSheet(
                                    dismissable: false,
                                    context: context,
                                    builder: (context) => ScanModal(),
                                  );

                                  NFCTag tag = await FlutterNfcKit.poll();
                                  if (tag != null) {
                                    List<ndef.NDEFRecord> existingRecords =
                                        await FlutterNfcKit.readNDEFRecords();

                                    ndef.TextRecord ndefRecord =
                                        ndef.TextRecord(
                                      text: tappedStudentInfo,
                                      language: 'en',
                                    );

                                    await FlutterNfcKit.writeNDEFRecords(
                                        [ndefRecord]);

                                    await FirebaseFirestore.instance
                                        .collection('students')
                                        .doc(studentData.id)
                                        .update({'nfc_written': true});

                                    setState(() {
                                      tappedStudentInfo = '';
                                      documents.remove(studentData);
                                    });

                                    setState(() {
                                      _writeResult = 'OK';
                                    });
                                  } else {
                                    setState(() {
                                      _writeResult =
                                          'Error: No NFC tag detected.';
                                    });
                                  }

                                  if (_writeResult == "OK") {
                                    Navigator.popUntil(
                                      context,
                                      ModalRoute.withName(
                                          '/'), // Pop until the home screen
                                    );

                                    showFloatingModalBottomSheet(
                                      dismissable: true,
                                      context: context,
                                      builder: (context) => SizedBox(
                                        height: 400,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Image.asset(
                                                'lib/images/image 2.png'),
                                            Text(
                                              "Successfully wrote on the NFC Tag with student data",
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    showFloatingModalBottomSheet(
                                      dismissable: true,
                                      context: context,
                                      builder: (context) => SizedBox(
                                        height: 400,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Image.asset(
                                                'lib/images/image 2.png'),
                                            const Text(
                                              "Failed to write on the NFC Tag, Please try again",
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
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

  String? extractDocumentIdFromContent(String content) {
    // Trim leading and trailing whitespace from the extracted content
    String trimmedContent = content.trim();

    List<String> contentParts = trimmedContent.split(' - ');
    return contentParts.length == 2 ? contentParts[1] : null;
  }

  Future<void> writeEmptyRawRecordToNFC(BuildContext context) async {
    //! SHOW MODAL
    showFloatingModalBottomSheet(
      context: context,
      builder: (context) => ScanModal(),
    );

    try {
      NFCTag tag = await FlutterNfcKit.poll();
      setState(() {
        _tag = tag;
      });

      if (tag.ndefAvailable ?? false) {
        var ndefRecords = await FlutterNfcKit.readNDEFRecords();
        var textContent = '';

        for (int i = 0; i < ndefRecords.length; i++) {
          if (ndefRecords[i] is ndef.TextRecord) {
            String? recordText = (ndefRecords[i] as ndef.TextRecord).text;
            textContent += recordText ?? '';
          }
        }

        String? documentId = extractDocumentIdFromContent(textContent);

        if (documentId != null) {
          print('Document ID: $documentId');

          // Reset the tag by writing an empty record
          await FlutterNfcKit.writeNDEFRecords([
            ndef.NDEFRecord(
              tnf: ndef.TypeNameFormat.values[0], // 0 for empty record
              type: ''.toBytes(),
              id: ''.toBytes(),
              payload: ''.toBytes(),
            ),
          ]);

          print('Empty tag written successfully.');

          // Update Firestore document
          await FirebaseFirestore.instance
              .collection('students')
              .doc(documentId)
              .update({'nfc_written': false});

          setState(() {
            _writeResult = 'OK';
          });

          print('Firestore update successful.');
        } else {
          setState(() {
            _writeResult = 'Error: ID not found in NFC tag data';
          });
          print('Error: ID not found in NFC tag data.');
        }
      } else {
        setState(() {
          _writeResult = 'Error: NDEF not available on the tag';
        });
        print('Error: NDEF not available on the tag.');
      }
    } catch (e) {
      print("Error resetting tag: $e");
    }
    if (_writeResult == "OK") {
      Navigator.pop(context);
      showFloatingModalBottomSheet(
        dismissable: true,
        context: context,
        builder: (context) => SizedBox(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('lib/images/image 2.png'),
              const Text(
                "Successfully reset the NFC Tag",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      showFloatingModalBottomSheet(
        dismissable: true,
        context: context,
        builder: (context) => SizedBox(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('lib/images/image 2.png'),
              const Text(
                "Failed to reset the NFC Tag, Please try again",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> writeTag() async {}
}
