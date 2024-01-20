import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

class AttendancePdf {
  static Future<void> generate() async {
    print("Test");
    final pdf = Document();

    print(pdf);
    final buLogo = MemoryImage(
      (await rootBundle.load('lib/images/logo_1.png')).buffer.asUint8List(),
    );
    print(buLogo);

    pdf.addPage(MultiPage(
        pageTheme: _buildTheme(
          PdfPageFormat.legal,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: (Context context) => _buildHeader(context, buLogo),
        footer: _buildFooter,
        build: (context) => <Widget>[
              TableHelper.fromTextArray(
                context: context,
                data: const <List<String>>[
                  <String>['No.', 'NAMES', 'SIGNATURE'],
                  <String>['1', 'Moralde, Jonathan, H.', ' 1'],
                  <String>['1', 'Moralde, Jonathan, H.', ' 1'],
                  <String>['1', 'Moralde, Jonathan, H.', ' 1'],
                  <String>['1', 'Moralde, Jonathan, H.', ' 1'],
                ],
              )
            ]));

    AttendancePdf.saveDocument(name: "attendance_pdf.pdf", pdf: pdf);
  }

  static Widget _buildHeader(Context context, MemoryImage buLogo) {
    return Row(children: [
      // LOGO
      Image(buLogo),
      // SCHOOL DETAIL
      Column(children: [
        Text("BICOL UNIVERSITY"),
        Text("POLANGUI CAMPUS"),
        Text("Polangui, Albay"),
        Text("Telefax: (052) 486-1220 (Bayantel)"),
        Row(children: [Text("Email: "), Text("bupc-dean@bicol-u.edu.ph")]),
      ]),

      // ATTENDANCE SHEET
      Column(children: [
        Text("ATTENDANCE SHEET"),
        Container(
          height: 1,
          width: 100,
          decoration: BoxDecoration(
            color: PdfColor(0, 0, 0),
          ),
        ),
        Container(
          height: 1,
          width: 80,
          decoration: BoxDecoration(
            color: PdfColor(0, 0, 0),
          ),
        ),
      ])
    ]);
  }

  static Widget _buildFooter(Context context) {
    return Column(children: []);
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

  // static Widget buildHeader() => Row(children: [PdfLogo()]);

  // static Future<void> saveDocument(
  //     {required String name, required Document pdf}) async {
  //   final bytes = await pdf.save();
  //   // final dir = await getApplicationDocumentsDirectory();
  //   // final file = File('${dir.path}/$name');

  //   // print(bytes);
  //   // print(dir);
  //   // print(file);

  //   // await file.writeAsBytes(bytes);
  //   // await OpenFile.open(file.path);
  //   final appDocDir = await getApplicationDocumentsDirectory();
  //   final appDocPath = appDocDir.path;
  //   final file = File('$appDocPath/$name');
  //   print('Save as file ${file.path} ...');
  //   await file.writeAsBytes(bytes);
  //   await OpenFile.open(file.path);
  // }
  static Future<void> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final storagePermissionStatus = await Permission.storage.request();

    if (storagePermissionStatus == PermissionStatus.granted) {
      final directory = Directory(
          '/storage/emulated/0/Download'); // Update this path as needed
      directory.createSync();

      final file = File('${directory.path}/$name');
      print('Save as file ${file.path} ...');

      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } else {
      // Handle the case where storage permission is not granted
      print('Storage permission not granted.');
    }
  }

  static Future openFile(File file) async {
    final url = file.path;

    print(url);

    await OpenFile.open(url);
  }
}
