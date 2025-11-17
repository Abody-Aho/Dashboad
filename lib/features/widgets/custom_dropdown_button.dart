import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final Rx<T> selectedValue; // القيمة المختارة بشكل عام
  final List<T> options;      // الخيارات
  final void Function(T value)? onChanged; // حدث عند تغيير القيمة
  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final IconData icon;

  const CustomDropdownButton({
    super.key,
    required this.selectedValue,
    required this.options,
    this.onChanged,
    this.height = 35,
    this.backgroundColor = const Color(0xFFE6F2EC),
    this.borderColor = Colors.green,
    this.icon = Icons.keyboard_arrow_down,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: selectedValue.value,
            icon: Icon(icon, color: borderColor),
            items: options
                .map((item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                selectedValue.value = value;
                if (onChanged != null) {
                  onChanged!(value);
                }
              }
            },
          ),
        ),
      );
    });
  }
}
