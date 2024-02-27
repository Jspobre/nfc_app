import 'package:flutter/material.dart';
import 'package:nfc_app/pages/attendance%20report/filter_page.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class AnalyticsPage extends StatefulWidget {
  AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      final DateTimeRange? dateTimeRange =
                          await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(3000),
                      );

                      if (dateTimeRange != null) {
                        setState(() {
                          selectedDates = dateTimeRange;
                        });
                      }
                    },
                    icon: Icon(Icons.date_range),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  StyledButton(
                    btnText: "Filters",
                    onClick: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => FilterPage(),
                        ),
                      );
                    },
                    btnColor: Colors.white,
                    btnIcon: Icon(Icons.tune),
                    iconOnRight: true,
                    noShadow: true,
                    borderRadius: BorderRadius.circular(50),
                    textSize: 16,
                    textColor: Colors.black,
                    isBorder: true,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    btnHeight: 40,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FixedColumnWidth(70),
                    2: FixedColumnWidth(70),
                    // 3: FixedColumnWidth(120.0),
                    3: FixedColumnWidth(50),
                  },
                  border: TableBorder
                      .all(), // Allows to add a border decoration around your table
                  children: [
                    const TableRow(children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text(
                          'Name',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Text(
                          'Presents',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Text(
                          'Absents',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Text(
                          'Lates',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Text(
                          'full name',
                          style: const TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Text(
                          '0',
                          style: const TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Text(
                          '0',
                          style: const TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Text(
                          '0',
                          style: const TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ])
                  ]),

              //! EXPORT BUTTON
              const SizedBox(
                height: 10,
              ),
              StyledButton(
                  noShadow: true,
                  btnIcon: Icon(Icons.picture_as_pdf),
                  iconOnRight: true,
                  btnText: "Export to Pdf",
                  onClick: () async {})
            ],
          ),
        ),
      ),
    ));
  }
}
