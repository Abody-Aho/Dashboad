import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownButton extends StatelessWidget {
  final dynamic controller; // أي Controller فيه بيانات الجدول
  const CustomDropdownButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.shade50, // خلفية فاتحة خفيفة
          borderRadius: BorderRadius.circular(12), // حواف مستديرة
          border: Border.all(color: Colors.green.shade700, width: 1.5), // إطار أخضر
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedValue.value,
            icon:  Icon(Icons.keyboard_arrow_down, color: Colors.green),
            items: controller.options
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList()
                .cast<DropdownMenuItem<String>>(),
            onChanged: (value) {
              if (value != null) {
                controller.changeValue(value);
              }
            },
          ),
        ),
      );
    });
  }
}
