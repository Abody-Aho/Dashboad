import 'package:dashbord2/features/admin/panel_lift/panel_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  final controller = Get.find<PanelController>(); // ✅

  final List<Color> sectionColors = const [
    Color(0xFF42A5F5),
    Color(0xFFAB47BC),
    Color(0xFFFFA726),
    Color(0xFFEF5350),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      color: Colors.green[50],
      child: Obx(() => Row(
        children: <Widget>[
          const SizedBox(height: 18),

          // 🔥 الشارت
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.3,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),

                  // 🟦 Legend (ديناميك)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      controller.topProducts.length,
                          (i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Indicator(
                          color: sectionColors[i % sectionColors.length],
                          text: controller.topProducts[i]['name'],
                          isSquare: true,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  // ============================
  // 🔥 Pie Sections (ديناميك)
  // ============================
  List<PieChartSectionData> showingSections() {
    if (controller.topProducts.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 1,
          title: 'No Data',
        )
      ];
    }

    double total = controller.topProducts
        .map((e) => e['sold'] as double)
        .reduce((a, b) => a + b);

    return List.generate(controller.topProducts.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 14;
      final double radius = isTouched ? 65 : 55;

      double percent =
          (controller.topProducts[i]['sold'] / total) * 100;

      return PieChartSectionData(
        color: sectionColors[i % sectionColors.length],
        value: controller.topProducts[i]['sold'],
        title: "${percent.toStringAsFixed(1)}%",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}

// ============================
// 🟦 Indicator Widget
// ============================
class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}