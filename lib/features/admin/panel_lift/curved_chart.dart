import 'package:dashbord2/features/admin/panel_lift/panel_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// admin
class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {

  final controller = Get.find<PanelController>();

  List<Color> gradientColors = [
    const Color(0xFF4CAF50),
    const Color(0xFF81C784),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: AspectRatio(
          aspectRatio: 1.7,
          child: Obx(() => LineChart(avgData())),
        ),
      ),
    );
  }


  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    final months = [
      'JAN','FEB','MAR','APR','MAY','JUN',
      'JUL','AUG','SEP','OCT','NOV','DEC'
    ];

    int index = value.toInt() - 1;

    if (index < 0 || index >= months.length) {
      return const SizedBox();
    }

    if (value % 2 != 0) return const SizedBox();

    return SideTitleWidget(
      meta: meta,
      child: Text(months[index], style: style),
    );
  }


  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );

    if (value == 0) return const SizedBox();

    if (value % 1 != 0) return const SizedBox();

    String text;

    if (value >= 1000) {
      text = "${(value / 1000).toStringAsFixed(1)}K";
    } else {
      text = value.toInt().toString();
    }

    return Text(text, style: style);
  }

  LineChartData avgData() {

    double maxYValue = controller.chartData.isEmpty
        ? 10
        : controller.chartData
        .map((e) => e['total_sold'] as double)
        .reduce((a, b) => a > b ? a : b);

// حماية إضافية
    if (maxYValue <= 0) {
      maxYValue = 10;
    }
    double interval = maxYValue / 4;

    if (interval <= 0 || interval.isNaN || interval.isInfinite) {
      interval = 1;
    }

    double leftInterval = (maxYValue / 4);

    if (leftInterval <= 0 || leftInterval.isNaN || leftInterval.isInfinite) {
      leftInterval = 1;
    }

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: true),

      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: interval,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.green.withValues(alpha: 0.15),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: leftInterval.ceilToDouble(),
            getTitlesWidget: leftTitleWidgets,
          ),
        ),

        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),

      borderData: FlBorderData(
        show: false,
      ),

      minX: 1,
      maxX: 12,

      minY: 0,
      maxY: maxYValue + (maxYValue * 0.3),

      lineBarsData: [
        LineChartBarData(
          spots: controller.chartData
              .where((e) => (e['total_sold'] as double) > 0)
              .map((e) => FlSpot(
            e['month'] as double,
            e['total_sold'] as double,
          ))
              .toList(),

          isCurved: true,

          gradient: LinearGradient(
            colors: gradientColors,
          ),

          barWidth: 4,

          isStrokeCapRound: true,

          dotData: const FlDotData(
            show: true,
          ),

          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.15))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}