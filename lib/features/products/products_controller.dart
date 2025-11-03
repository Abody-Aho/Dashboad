// products_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  var dataList = <Map<String, String>>[].obs;       // كل البيانات
  var filteredDataList = <Map<String, String>>[].obs; // البيانات المعروضة بعد البحث
  RxList<bool> selectedRows = <bool>[].obs;        // حالة الـ Checkbox لكل صف

  RxInt sortColumnIndex = 1.obs;                   // العمود المرتب حاليا
  RxBool sortAscending = true.obs;                 // اتجاه الفرز
  final searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // ترتيب الجدول
  void sortById(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    String columnKey = 'Column${columnIndex + 1}';

    // ترتيب القائمة المعروضة فقط
    filteredDataList.sort((a, b) {
      final valueA = a[columnKey]!.toLowerCase();
      final valueB = b[columnKey]!.toLowerCase();
      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });
  }

  // البحث في الجدول
  void searchQuery(String query) {
    List<Map<String, String>> results;
    if (query.isEmpty) {
      results = dataList;
    } else {
      results = dataList.where((item) =>
          item.values.any((value) => value.toLowerCase().contains(query.toLowerCase()))
      ).toList();
    }

    filteredDataList.assignAll(results);

    // إعادة تهيئة الـ Checkbox
    selectedRows.assignAll(List.generate(filteredDataList.length, (index) => false));
  }

  // إنشاء البيانات التجريبية
  void fetchProducts() {
    dataList.assignAll(
      List.generate(
        36,
            (index) => {
          'Column1': 'Data ${index + 1} - 1',
          'Column2': 'Data ${index + 1} - 2',
          'Column3': 'Data ${index + 1} - 3',
          'Column4': 'Data ${index + 1} - 4',
        },
      ),
    );

    filteredDataList.assignAll(dataList);
    selectedRows.assignAll(List.generate(filteredDataList.length, (index) => false));
  }
}
