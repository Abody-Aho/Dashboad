import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  final dynamic controller; // أي Controller فيه بيانات الجدول
  const CustomSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: TextFormField(
        controller: controller.searchTextController,
        onChanged: (query) => controller.searchQuery(query),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 2.5,
            ),
          ),
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.green[700]),
          prefixIcon: const Icon(Icons.search, color: Colors.green),
        ),
      ),
    );
  }
}
