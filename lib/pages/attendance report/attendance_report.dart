import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_app/pages/attendance%20report/analytics_page.dart';
import 'package:nfc_app/pages/attendance%20report/attendance_section.dart';
import 'package:nfc_app/provider/attendanceData_provider.dart';

class AttendanceReport extends ConsumerWidget {
  const AttendanceReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.refresh(attendanceDataProvider);
    ref.refresh(studentListProvider);
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
