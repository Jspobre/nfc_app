import 'package:flutter/material.dart';
import 'package:nfc_app/pages/attendance%20report/analytics_page.dart';
import 'package:nfc_app/pages/attendance%20report/attendance_section.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white10,
          title: Text(
            "Attendance",
            style: TextStyle(fontFamily: "Roboto", fontSize: 18),
          ),
          centerTitle: true,
          // TAB BAR
          bottom: TabBar(
            labelColor: Color(0xff16A637),
            indicatorColor: Color(0xff16A637),
            tabs: [
              Tab(
                icon: Icon(Icons.wysiwyg),
                text: "Reports",
                iconMargin: EdgeInsets.only(bottom: 2),
                height: 54,
              ),
              Tab(
                icon: Icon(Icons.analytics_outlined),
                text: "Analytics",
                iconMargin: EdgeInsets.only(bottom: 2),
                height: 54,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AttendanceSection(),
            AnalyticsPage(),
          ],
        ),
      ),
    );
  }
}
