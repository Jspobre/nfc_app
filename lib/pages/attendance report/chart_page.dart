import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/widgets/fl%20chart/indicator.dart';

class ChartPage extends StatefulWidget {
  final int totalAttendanceValue;
  final Map<String, dynamic> studentDetail;
  const ChartPage(
      {super.key,
      required this.totalAttendanceValue,
      required this.studentDetail});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentDetail['fullName'] as String),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 0.75,
          child: Column(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                            print(pieTouchResponse.touchedSection);
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 5,
                      centerSpaceRadius: 0,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Indicator(
                    color: Colors.blue,
                    text: 'Present',
                    isSquare: true,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Indicator(
                    color: Colors.yellow,
                    text: 'Absent',
                    isSquare: true,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Indicator(
                    color: Colors.purple,
                    text: 'Late',
                    isSquare: true,
                  ),
                  // SizedBox(
                  //   height: 18,
                  // ),
                ],
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> sections = [];

    final Map<String, int> attendance = {
      'Present': widget.studentDetail['presents'] as int,
      'Absent': widget.studentDetail['absents'] as int,
      'Late': widget.studentDetail['lates'] as int,
    };

    const sectionColors = [Colors.blue, Colors.yellow, Colors.purple];
    final shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    attendance.forEach((key, value) {
      if (value > 0) {
        final percentage = calculatePercentage(
            value.toDouble(), widget.totalAttendanceValue.toDouble());
        final isTouched = touchedIndex == sections.length;
        final radiusPresent = isTouched ? 140.0 : 130.0;
        final radiusAbsent = isTouched ? 130.0 : 100.0;
        final radiusLate = isTouched ? 130.0 : 110.0;

        final section = PieChartSectionData(
          color: key == "Present"
              ? sectionColors[0]
              : key == "Absent"
                  ? sectionColors[1]
                  : sectionColors[2],
          value: percentage,
          title: '${percentage.toInt()}%',
          titleStyle: TextStyle(
            fontSize: isTouched ? 25.0 : 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            shadows: shadows,
          ),
          radius: key == "Present"
              ? radiusPresent
              : key == "Absent"
                  ? radiusAbsent
                  : radiusLate,
        );
        sections.add(section);
      }
    });

    return sections;
  }

  double calculatePercentage(double value, double totalValue) {
    return (value / totalValue) * 100;
  }
}
