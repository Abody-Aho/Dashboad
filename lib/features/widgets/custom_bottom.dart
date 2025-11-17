import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottom extends StatelessWidget {
  final dynamic controller; // أي Controller فيه بيانات الجدول
  final String addButtonText; // نص الزر
  final VoidCallback? onAddPressed; // الدالة اللي تتنفذ عند الضغط
  const CustomBottom({
    super.key,
    required this.controller,
    this.addButtonText = "إضافة",
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onAddPressed ?? controller.onAddPressed,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(addButtonText, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade500,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    );
  }
}
