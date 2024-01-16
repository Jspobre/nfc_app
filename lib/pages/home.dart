import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:nfc_app/pages/add%20student/add_student.dart';
import 'package:nfc_app/pages/attendance%20report/attendance_report.dart';
import 'package:nfc_app/widgets/bottom%20sheet%20modal/floating_modal.dart';
import 'package:nfc_app/widgets/styledButton.dart';

import 'package:ndef/utilities.dart';

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

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
      _availability = availability;
    });
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
                    'View attendance',
                    style: TextStyle(fontFamily: "Roboto"),
                  ),
                ),
              );
              // POPUP MENU ITEMS - RESET NFC TAG
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

  Future<void> writeEmptyRawRecordToNFC(BuildContext context) async {
    // SHOW MODAL
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
                    })
          ],
        ),
      ),
    );

    // SCAN AND WRITE
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
