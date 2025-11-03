import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductsPieChart extends StatelessWidget {
  final List<PieChartSectionData> sections = [
    PieChartSectionData(value: 35, title: 'الخضار والفواكه\n35%', radius: 60),
    PieChartSectionData(value: 20, title: 'منتجات الألبان\n20%', radius: 50),
    PieChartSectionData(value: 12, title: 'المخبوزات\n12%', radius: 45),
    PieChartSectionData(value: 18, title: 'اللحوم\n18%', radius: 50),
    PieChartSectionData(value: 15, title: 'أخرى\n15%', radius: 40),
  ];

   ProductsPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 24,
        sectionsSpace: 2,
      ),
    );
  }
}
