import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  final List<Color> sectionColors = const [
    Color(0xFF42A5F5), // أزرق
    Color(0xFFAB47BC), // بنفسجي
    Color(0xFFFFA726), // برتقالي
    Color(0xFFEF5350), // أحمر
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      color: Colors.green[50],
      child: Row(
        children: <Widget>[
          const SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.3,
              child: Row(
                children: <Widget>[
                  const SizedBox(height: 18),
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
                  // 🟦 المؤشرات الجانبية (Legend)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Indicator(color: Color(0xFF42A5F5), text: 'الأولى', isSquare: true, textColor: Colors.black87),
                      SizedBox(height: 6),
                      Indicator(color: Color(0xFFAB47BC), text: 'الثانية', isSquare: true, textColor: Colors.black87),
                      SizedBox(height: 6),
                      Indicator(color: Color(0xFFFFA726), text: 'الثالثة', isSquare: true, textColor: Colors.black87),
                      SizedBox(height: 6),
                      Indicator(color: Color(0xFFEF5350), text: 'الرابعة', isSquare: true, textColor: Colors.black87),
                      SizedBox(height: 12),
                    ],
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 22.0 : 16.0;
      final double radius = isTouched ? 65.0 : 55.0;
      const shadows = [Shadow(color: Colors.black26, blurRadius: 3)];

      return PieChartSectionData(
        color: sectionColors[i],
        value: [40, 30, 20, 10][i].toDouble(),
        title: '${[40, 30, 20, 10][i]}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white, // أرقام بيضاء واضحة
          shadows: shadows,
        ),
      );
    });
  }
}

// 🟦 ويدجت المؤشر الجانبي
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
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 2),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
