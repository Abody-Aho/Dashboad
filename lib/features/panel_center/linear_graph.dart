import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class BarChartSample2 extends StatefulWidget {
    const BarChartSample2({super.key});

  final Color leftBarColor =  Colors.red;
  final Color rightBarColor = Colors.green;
  final Color avgColor = Colors.orange; // أزرق متوسط عند اللمس

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    rawBarGroups = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Constants.kPadding / 2,
        right: Constants.kPadding / 2,
        top: Constants.kPadding,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          color: Colors.green[50],
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    makeTransactionsIcon(),
                    const Text(
                      ' Monthly Profit',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      r'  $345,462',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Of',
                      style: TextStyle(
                        color: Colors.red[200],
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Sales',
                      style: TextStyle(
                        color: Constants.accent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'And',
                      style: TextStyle(
                        color: Colors.red[200],
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Orders',
                      style: TextStyle(
                        color: Constants.accent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: 20,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBorder: BorderSide(
                            color: const Color(0xFF1565C0).withValues(alpha: 0.4),
                          ),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              rod.toY.toStringAsFixed(1),
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent event, response) {
                          if (response == null || response.spot == null) {
                            setState(() {
                              touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);
                            });
                            return;
                          }

                          touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                          setState(() {
                            if (!event.isInterestedForInteractions) {
                              touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);
                              return;
                            }
                            showingBarGroups = List.of(rawBarGroups);
                            if (touchedGroupIndex != -1) {
                              var sum = 0.0;
                              for (final rod
                              in showingBarGroups[touchedGroupIndex]
                                  .barRods) {
                                sum += rod.toY;
                              }
                              final avg =
                                  sum / showingBarGroups[touchedGroupIndex]
                                      .barRods
                                      .length;

                              showingBarGroups[touchedGroupIndex] =
                                  showingBarGroups[touchedGroupIndex].copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .map((rod) {
                                      return rod.copyWith(
                                        toY: avg,
                                        color: widget.avgColor,
                                      );
                                    }).toList(),
                                  );
                            }
                          });
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 5,
                            getTitlesWidget: leftTitles,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: showingBarGroups,
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 5) {
      text = '5K';
    } else if (value == 10) {
      text = '10K';
    } else if (value == 15) {
      text = '15K';
    } else if (value == 20) {
      text = '20K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );

    return SideTitleWidget(meta: meta, space: 12, child: text);
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(width: width, height: 10, color: const Color(0xFFB9F6CA)), // أخضر ليموني فاتح
        const SizedBox(width: space),
        Container(width: width, height: 28, color: const Color(0xFF43A047)), // أخضر زمردي
        const SizedBox(width: space),
        Container(width: width, height: 42, color: const Color(0xFF1B5E20)), // أخضر داكن فاخر
        const SizedBox(width: space),
        Container(width: width, height: 28, color: const Color(0xFF43A047)), // نفس الزمردي للانسجام
        const SizedBox(width: space),
        Container(width: width, height: 10, color: const Color(0xFFB9F6CA)), // الليموني مرة أخرى
      ],
    );
  }

}
