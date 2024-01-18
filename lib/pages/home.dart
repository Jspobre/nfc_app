import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:ndef/utilities.dart';
import 'package:nfc_app/pages/add%20student/add_student.dart';
import 'package:nfc_app/pages/attendance%20report/attendance_report.dart';
import 'package:nfc_app/widgets/bottom%20sheet%20modal/floating_modal.dart';
import 'package:nfc_app/widgets/styledButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform, sleep;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

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

      // Pretend that we are working
      if (!kIsWeb) ;
      await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
    }
  }

  void showDetailsContainer(NFCTag tag, String scannedData) {
    // Push scanned data to Firebase
// Push scanned data to Firebase
    _databaseReference.push().set({
      'timestamp': ServerValue.timestamp,
      'tag_data': scannedData,
    }).then((_) {
      print('Data inserted successfully');
    }).catchError((error) {
      print('Error inserting data: $error');
    });

    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(top: 50, left: 12, right: 12),
            height: 300,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(),
                    Image.asset('lib/images/image 2.png'),
                    const Text(
                      "NFC Tag Details",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    // Display the NFC details
                    tag != null
                        ? Text('Transceive Result:\n$_result')
                        : const Text('Empty NFC Tag'),

                    StyledButton(
                      noShadow: true,
                      textColor: Colors.black,
                      btnColor: const Color(0xffCECECE),
                      btnText: "Cancel",
                      onClick: () async {
                        await FlutterNfcKit.finish();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
                    onClick: () async {
                      await showInitialModal();
                      // setState(() {
                      //   _readResult == 'OK';
                      // });

                      // try {
                      //   NFCTag tag = await FlutterNfcKit.poll();
                      //   setState(() {
                      //     _tag = tag;
                      //   });
                      //   await FlutterNfcKit.setIosAlertMessage(
                      //       "Working on it...");
                      //   _mifareResult = null;

                      //   if (tag.standard == "ISO 14443-4 (Type B)") {
                      //     String result1 =
                      //         await FlutterNfcKit.transceive("00B0950000");
                      //     String result2 = await FlutterNfcKit.transceive(
                      //         "00A4040009A00000000386980701");
                      //     setState(() {
                      //       _result = '1: $result1\n2: $result2\n';
                      //     });
                      //   } else if (tag.type == NFCTagType.iso18092) {
                      //     String result1 =
                      //         await FlutterNfcKit.transceive("060080080100");
                      //     setState(() {
                      //       _result = '1: $result1\n';
                      //     });
                      //   } else if (tag.ndefAvailable ?? false) {
                      //     var ndefRecords =
                      //         await FlutterNfcKit.readNDEFRecords();
                      //     var textContent = '';

                      //     for (int i = 0; i < ndefRecords.length; i++) {
                      //       if (ndefRecords[i] is ndef.TextRecord) {
                      //         // Extract and concatenate text content from TextRecord
                      //         String? recordText =
                      //             (ndefRecords[i] as ndef.TextRecord).text;
                      //         textContent += recordText ??
                      //             ''; // Use the null-aware operator to handle null values
                      //       }
                      //     }

                      //     setState(() {
                      //       _result = ' $textContent';
                      //     });
                      //   } else if (tag.type == NFCTagType.webusb) {
                      //     var r = await FlutterNfcKit.transceive(
                      //         "00A4040006D27600012401");
                      //     print(r);
                      //   }
                      // } catch (e) {
                      //   setState(() {
                      //     _result = 'error: $e';
                      //   });
                      // }

                      // // Pretend that we are working
                      // if (!kIsWeb) sleep(new Duration(seconds: 1));
                      // await FlutterNfcKit.finish(iosAlertMessage: "Finished!");

                      // Display the NFC details in a modal

                      // showGeneralDialog(
                      //   context: context,
                      //   barrierColor: Colors.black.withOpacity(0.5),
                      //   barrierDismissible: false,
                      //   barrierLabel: '',
                      //   transitionDuration: Duration(milliseconds: 400),
                      //   pageBuilder: (context, animation1, animation2) {
                      //     return Align(
                      //       alignment: Alignment.center,
                      //       child: Container(
                      //         margin:
                      //             EdgeInsets.only(top: 50, left: 12, right: 12),
                      //         height: 300, // Adjust the height as needed
                      //         child: Card(
                      //           elevation: 8,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(12),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(16.0),
                      //             child: Column(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceAround,
                      //               children: [
                      //                 const SizedBox(),
                      //                 Image.asset('lib/images/image 2.png'),
                      //                 const Text(
                      //                   "NFC Tag Details",
                      //                   style: TextStyle(
                      //                     fontSize: 17,
                      //                   ),
                      //                 ),
                      //                 // Display the NFC details
                      //                 _tag != null
                      //                     ? Text(
                      //                         '\nTransceive Result:\n$_result')
                      //                     : const Text('No tag scanned yet.'),
                      //                 StyledButton(
                      //                   noShadow: true,
                      //                   textColor: Colors.black,
                      //                   btnColor: const Color(0xffCECECE),
                      //                   btnText: "Cancel",
                      //                   onClick: () async {
                      //                     await FlutterNfcKit.finish();
                      //                     Navigator.pop(context);
                      //                   },
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
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
                      BuildContext originalContext =
                          context; // Store the original context

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
                              return Container(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  height: 400,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      for (DocumentSnapshot document
                                          in documents)
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              tappedStudentInfo =
                                                  "${document['student_num']} - ${document['full_name']}";
                                            });

                                            // Get the NFC tag and read existing NDEF records
                                            NFCTag tag =
                                                await FlutterNfcKit.poll();
                                            if (tag != null) {
                                              List<ndef.NDEFRecord>
                                                  existingRecords =
                                                  await FlutterNfcKit
                                                      .readNDEFRecords();

                                              // Check if there are any existing records on the NFC tag
                                              // if (existingRecords.isNotEmpty) {
                                              //   // Show a message or handle accordingly (e.g., don't proceed)
                                              //   setState(() {
                                              //     _writeResult =
                                              //         'Error: NFC tag already contains a record.';
                                              //   });
                                              //   return;
                                              // }

                                              // Create NDEF record with student details
                                              ndef.TextRecord ndefRecord =
                                                  ndef.TextRecord(
                                                text: tappedStudentInfo,
                                                language: 'en',
                                              );

                                              // Write the NDEF record to the NFC tag
                                              await FlutterNfcKit
                                                  .writeNDEFRecords(
                                                      [ndefRecord]);

                                              // Update Firestore document to indicate that the information has been written
                                              await FirebaseFirestore.instance
                                                  .collection('students')
                                                  .doc(document.id)
                                                  .update(
                                                      {'nfc_written': true});

                                              // Remove the document from the list in the modal
                                              setState(() {
                                                tappedStudentInfo =
                                                    ''; // Clear the student info
                                                documents.remove(document);
                                              });

                                              // Show a success message using SnackBar
                                              ScaffoldMessenger.of(
                                                      originalContext)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'NFC tag successfully written with student details!',
                                                  ),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                _writeResult =
                                                    'Error: No NFC tag detected.';
                                              });
                                            }

                                            // Close the modal (if it's open)
                                            if (Navigator.canPop(context)) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: document['nfc_written'] == true
                                              ? Container() // Don't display the container if nfc_written is true
                                              : Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
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
    //! SHOW MODAL
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

    resetTag().then(
      (value) {
        Navigator.pop(context);

        if (_writeResult == "OK") {
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
        }
      },
    );
  }

  Future<void> resetTag() async {
    //! SCAN AND WRITE
    try {
      NFCTag tag = await FlutterNfcKit.poll();
      setState(() {
        _tag = tag;
      });
      if (tag.type == NFCTagType.mifare_ultralight ||
          tag.type == NFCTagType.mifare_classic ||
          tag.type == NFCTagType.iso15693) {
        await FlutterNfcKit.writeNDEFRecords([
          ndef.NDEFRecord(
              tnf: ndef.TypeNameFormat.values[0], // 0 for empty record
              type: ''.toBytes(),
              id: ''.toBytes(),
              payload: ''.toBytes())
        ]);

        setState(() {
          _writeResult = 'OK';
        });
      } else {
        setState(() {
          _writeResult = 'error: NDEF not supported: ${tag.type}';
        });
      }
    } catch (e) {
      print("Error resetting tag: $e");
    } finally {
      await FlutterNfcKit.finish();
    }
  }
}
