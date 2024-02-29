import 'dart:io';
import 'package:flutter/services.dart';
import 'package:nfc_app/model/attendance_data.dart';
import 'package:nfc_app/model/fetch_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';

class AttendancePdf {
  static Future<void> generate(
      List<dynamic> attendanceData, String formattedDate) async {
    final pdf = Document();

    final buLogo = MemoryImage(
      (await rootBundle.load('lib/images/logo_1.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      MultiPage(
          pageTheme: _buildTheme(
            PdfPageFormat.legal, //! PAGE FORMAT
            await PdfGoogleFonts.robotoRegular(),
            await PdfGoogleFonts.robotoBold(),
            await PdfGoogleFonts.robotoItalic(),
          ),
          header: (Context context) =>
              _buildHeader(context, buLogo, formattedDate),
          footer: _buildFooter,
          build: (context) {
            final List<List<String>> tableData = [];

            int lastNumber = 0;

            // Add rows dynamically based on the attendanceData
            for (int i = 0; i < attendanceData.length; i++) {
              final data = attendanceData[i];
              lastNumber = i + 1; // Update lastNumber
              tableData.add([
                lastNumber.toString(),
                data is AttendanceRaw
                    ? data.fullName
                    : (data as IndivStudent).fullName,
                lastNumber.toString()
              ]);
            }

            // Add empty rows if the data length is less than 50
            for (int i = lastNumber + 1; i <= 50; i++) {
              tableData.add([i.toString(), '', i.toString()]);
            }

            return <Widget>[
              TableHelper.fromTextArray(
                context: context,
                cellAlignment: Alignment.center,
                data: const <List<String>>[
                  <String>['No.', 'NAMES', 'SIGNATURE'],
                ],
                columnWidths: {
                  0: FixedColumnWidth(30.0),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(150.0),
                },
              ),
              TableHelper.fromTextArray(
                headerPadding:
                    EdgeInsets.symmetric(vertical: 0.5, horizontal: 5),
                cellPadding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 5),
                context: context,
                cellAlignments: {
                  0: Alignment.center,
                  1: Alignment.centerLeft,
                  2: Alignment.centerRight,
                },
                data: tableData,
                columnWidths: {
                  0: FixedColumnWidth(30.0),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(150.0),
                },
                headerStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
                cellStyle: TextStyle(fontSize: 11),
              ),
            ];
          }),
    );

    AttendancePdf.saveDocument(name: "attendance_pdf.pdf", pdf: pdf);
  }

  static Widget _buildHeader(
      Context context, MemoryImage buLogo, String formattedDate) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            // LOGO
            Image(buLogo, width: 70, height: 70),
            SizedBox(width: 10),
            // SCHOOL DETAIL
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("BICOL UNIVERSITY",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              Text("POLANGUI CAMPUS",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              Text("Polangui, Albay",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              Text("Telefax: (052) 486-1220 (Bayantel)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              Row(children: [
                Text(
                  "Email: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                Text(
                  "bupc-dean@bicol-u.edu.ph",
                  style: TextStyle(fontSize: 11),
                )
              ]),
            ]),
          ]),

          // ATTENDANCE SHEET
          Column(children: [
            Text(
              "ATTENDANCE SHEET",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            SizedBox(height: 5),
            Text(
              formattedDate,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            SizedBox(height: 3),
            Container(
              height: 1,
              width: 150,
              decoration: BoxDecoration(
                color: PdfColor(0, 0, 0),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 1,
              width: 120,
              decoration: BoxDecoration(
                color: PdfColor(0, 0, 0),
              ),
            ),
          ])
        ]),
        // DIVIDER / UNDERLINE
        Divider(
          thickness: 3,
          // height: 1,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  static Widget _buildFooter(Context context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end, // Align content at the bottom
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("BU-F-PC-15",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        Text("Effective Date: November 4, 2019",
            style: TextStyle(fontSize: 11)),
        Text("Revision: 0", style: TextStyle(fontSize: 11))
      ],
    );
  }

  static PageTheme _buildTheme(
      PdfPageFormat pageFormat, Font base, Font bold, Font italic) {
    return PageTheme(
      pageFormat: pageFormat,
      theme: ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }

  static Future<void> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final appDocDir = await getExternalStorageDirectory();
    final appDocPath = appDocDir!.path;
    final file = File('$appDocPath/$name');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }
}
