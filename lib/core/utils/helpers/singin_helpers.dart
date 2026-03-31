import 'package:flutter/material.dart';

TextStyle titleStyle() => TextStyle(
  color: Colors.green[700],
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

InputDecoration inputDecoration({
  String? hint,
  IconData? icon,
  Widget? suffix,
}) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.green, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.green, width: 2.5),
    ),
    hintText: hint,
    prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
    suffixIcon: suffix,
  );
}