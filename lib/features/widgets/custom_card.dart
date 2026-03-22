import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String percent;
  final String subtitle;
  final Color percentColor;
  final IconData percentIcon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    required this.subtitle,
    this.percentColor = Colors.green,
    this.percentIcon = Icons.arrow_upward,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 العنوان
            Text(
              title,
              style: TextStyle(
                fontSize: width < 500 ? 12 : 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 الرقم + النسبة
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: width < 500 ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(percentIcon, color: percentColor, size: 16),
                    Text(
                      percent,
                      style: TextStyle(
                        color: percentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 6),

            // 🔹 الوصف
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}