import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownButton extends StatelessWidget {
  final dynamic controller; // أي Controller فيه بيانات الجدول
  const CustomDropdownButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(

        child: DropdownButton<String>(
          value: controller.selectedValue.value,
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
      );
    });
  }
}
