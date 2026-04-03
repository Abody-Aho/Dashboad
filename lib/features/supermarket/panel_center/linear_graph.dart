import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../panel_center/panel_center_controller.dart'; // مسار الكنترولر للسوبر

class BarChartSample2 extends StatefulWidget {
  const BarChartSample2({super.key});

  @override
  State<BarChartSample2> createState() => _BarChartSample2State();
}

class _BarChartSample2State extends State<BarChartSample2> {
  final Color leftBarColor = Colors.red;
  final Color rightBarColor = Colors.green;
  final Color avgColor = Colors.orange;
  final double barWidth = 7;

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    // جلب الكنترولر الخاص بالسوبر
    final controller = Get.find<PanelCenterController>();

    return Obx(() {
      final data = controller.chartData;

      if (data.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final groupsRaw = List.generate(data.length > 7 ? 7 : data.length, (index) {
        final day = data[index];
        return {
          "orders": (day['orders'] ?? 0).toDouble(),
          "sales": (day['sales'] ?? 0).toDouble(),
        };
      });

      // 🌟 الميزة المقتبسة من الأدمن: فصل الـ Scale لكل عمود لتناسق الرسمة
      double maxOrders = 0;
      double maxSales = 0;
      for (var e in groupsRaw) {
        if (e['orders']! > maxOrders) maxOrders = e['orders']!;
        if (e['sales']! > maxSales) maxSales = e['sales']!;
      }

      double scaleOrders = maxOrders > 0 ? maxOrders / 20 : 1;
      double scaleSales = maxSales > 0 ? maxSales / 20 : 1;

      List<BarChartGroupData> chartGroups = List.generate(groupsRaw.length, (index) {
        final day = groupsRaw[index];
        bool isTouched = index == touchedGroupIndex;

        // تطبيق الـ Scale المنفصل
        double ordersY = day['orders']! / scaleOrders;
        double salesY = day['sales']! / scaleSales;

        if (isTouched) {
          double avg = (ordersY + salesY) / 2;
          return makeGroupData(index, avg, avg, isTouched: true);
        }

        return makeGroupData(index, ordersY, salesY, isTouched: false);
      });

      return Padding(
        padding: const EdgeInsets.all(Constants.kPadding / 2),
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            color: Colors.green[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      makeTransactionsIcon(),
                      const SizedBox(width: 8),
                      const Text(
                        'Weekly Activity',
                        style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        maxY: 20,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final isOrders = rodIndex == 0;
                              final val = isOrders
                                  ? groupsRaw[groupIndex]['orders']
                                  : groupsRaw[groupIndex]['sales'];

                              final title = isOrders ? "Orders: " : "Sales: ";

                              return BarTooltipItem(
                                "$title$val",
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                          touchCallback: (FlTouchEvent event, response) {
                            if (response == null || response.spot == null) {
                              setState(() => touchedGroupIndex = -1);
                              return;
                            }
                            setState(() {
                              if (!event.isInterestedForInteractions) {
                                touchedGroupIndex = -1;
                              } else {
                                touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                              }
                            });
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 42,
                            ),
                          ),
                          // 🌟 مقتبس من الأدمن: إخفاء الأرقام الجانبية لأن الـ Scales مختلفة
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        barGroups: chartGroups,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, {required bool isTouched}) {
    return BarChartGroupData(
      x: x,
      barsSpace: 4,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: isTouched ? avgColor : leftBarColor,
          width: barWidth,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y2,
          color: isTouched ? avgColor : rightBarColor,
          width: barWidth,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (value.toInt() >= titles.length || value.toInt() < 0) return Container();
    return SideTitleWidget(
      meta: meta,
      space: 12,
      child: Text(titles[value.toInt()], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget makeTransactionsIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconBar(10, const Color(0xFFB9F6CA)),
        const SizedBox(width: 3.5),
        _iconBar(28, const Color(0xFF43A047)),
        const SizedBox(width: 3.5),
        _iconBar(42, const Color(0xFF1B5E20)),
      ],
    );
  }

  Widget _iconBar(double height, Color color) => Container(width: 4.5, height: height, color: color);
}