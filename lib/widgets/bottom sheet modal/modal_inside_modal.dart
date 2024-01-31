import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nfc_app/widgets/bottom%20sheet%20modal/floating_modal.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class ModalInsideModal extends StatelessWidget {
  final bool reverse;
  final List<DocumentSnapshot> studentsList;
  final void Function(DocumentSnapshot studentData) selectStudent;

  const ModalInsideModal(
      {Key? key,
      this.reverse = false,
      required this.studentsList,
      required this.selectStudent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          leading: Container(), middle: Text('Modal Page')),
      child: SafeArea(
        bottom: false,
        child: ListView(
          reverse: reverse,
          shrinkWrap: true,
          controller: ModalScrollController.of(context),
          physics: ClampingScrollPhysics(),
          children: ListTile.divideTiles(
            context: context,
            tiles: studentsList.map((student) {
              Map<String, dynamic> studentData =
                  student.data() as Map<String, dynamic>;

              final String yrLevel = studentData['year_level'];
              final String course = studentData['course'];
              var nfcWritten = studentData.toString().contains('nfc_written')
                  ? student.get('nfc_written')
                  : false;

              // Check if nfc_written is null or false
              if (nfcWritten == null || nfcWritten == false) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(studentData['full_name']),
                      Text(
                          '${course == "Bachelor of Science in Information Technology" ? "BSIT" : course == "Bachelor of Science in Computer Science" ? "BSCS" : course == "Bachelor of Science in Information System" ? "BSIS" : course == "Bachelor of Science in Electronics Engineering" ? "BSECE" : course == "Bachelor of Science in Computer Engineering" ? "BSCpE" : course == "Bachelor of Elementary Education" ? "BEEd" : course == "Bachelor of Secondary Education major in Math" ? "BSEd-Math" : course == "Bachelor of Secondary Education major in English" ? "BSEd-English" : course == "Bachelor of Technology and Livelihood Education major in ICT" ? "BTL-ICT" : course == "Bachelor of Technology and Livelihood Education major in HE" ? "BTL-HE" : course == "Bachelor of Science in Automotive Technology" ? "BSAT" : course == "Bachelor of Science in Electronics Technology" ? "BSEET" : course == "Bachelor of Science in Entrepreneurship" ? "BSEntrep" : course == "Bachelor of Science in Nursing" ? "BSN" : "Unknown abbreviation"} ${yrLevel == '4th Year' ? "4" : (yrLevel == "3rd Year" ? "3" : (yrLevel == "2nd Year" ? "2" : "1"))}${studentData['block']}')
                    ],
                  ),
                  onTap: () {
                    selectStudent(student);
                  },
                );
              } else {
                // Return an empty container or any other widget when nfc_written is true
                return Container();
              }
            }),
          ).toList(),
        ),
      ),
    ));
  }
}
