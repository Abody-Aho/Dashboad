import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OrdersBarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups = List.generate(7, (i) {
    final values = [60.0, 90.0, 120.0, 100.0, 150.0, 170.0, 220.0];
    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: values[i],
          width: 18,
          color: Colors.green[700],
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  });

  OrdersBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 260,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['أحد','اثن','ثلا','ربع','خمس','ست','سبت'];
                final text = Text(
                  labels[value.toInt()],
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                );
                return SideTitleWidget(
                  // هذا يتحكم في تموضع النص داخل المحور
                  fitInside: SideTitleFitInsideData(
                    enabled: true,              // نخليه true حتى يمنع خروج النص خارج حدود الرسم
                    axisPosition: 0,            // الموضع على المحور (0 يعني البداية)
                    parentAxisSize: 40,         // تقريبًا حجم المحور الجانبي
                    distanceFromEdge: 5,        // المسافة بين النص والحافة
                  ),

                  space: 6, // مسافة بين النص والمحور

                  // بيانات meta تمثل معلومات المحور الحالية
                  meta: TitleMeta(
                    min: 0, // أقل قيمة على المحور
                    max: 6, // أعلى قيمة (عدد الأيام - 1)
                    parentAxisSize: 40, // نفس القيمة تقريبا من فوق
                    axisPosition: 0,
                    appliedInterval: 1,
                    sideTitles: const SideTitles(showTitles: true),
                    formattedValue: '', // يملأ لاحقًا بناءً على النص المعروض
                    axisSide: AxisSide.bottom, // المحور السفلي
                    rotationQuarterTurns: 0, // بدون دوران
                  ),

                  child: text, // النص الذي أنشأناه سابقًا
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      ),
    );
  }
}
