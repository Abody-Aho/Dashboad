import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var dataList = <Map<String, String>>[].obs;        // كل البيانات
  var filteredDataList = <Map<String, String>>[].obs; // البيانات المعروضة بعد البحث
  RxList<bool> selectedRows = <bool>[].obs;          // حالة الـ Checkbox لكل صف

  RxInt sortColumnIndex = 0.obs;                     // العمود المرتب حاليا
  RxBool sortAscending = true.obs;                   // اتجاه الفرز
  final searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  ///  الأعمدة الخاصة بالجدول مع الترتيب
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: const Text('Column 1'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    DataColumn(
      label: const Text('Column 2'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    DataColumn(
      label: const Text('Column 3'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    DataColumn(
      label: const Text('Column 4'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
  ];

  /// عند الضغط على زر الإضافة
  void onAddPressed() {
    print(" تم الضغط على زر إضافة مستخدم");
  }

  ///  ترتيب الجدول حسب العمود
  void sortById(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    String columnKey = 'Column${columnIndex + 1}';

    filteredDataList.sort((a, b) {
      final valueA = a[columnKey]!.toLowerCase();
      final valueB = b[columnKey]!.toLowerCase();
      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });

    // تحديث العرض
    filteredDataList.refresh();
  }

  /// البحث في الجدول
  void searchQuery(String query) {
    List<Map<String, String>> results;
    if (query.isEmpty) {
      results = dataList;
    } else {
      results = dataList
          .where((item) => item.values
          .any((value) => value.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }

    filteredDataList.assignAll(results);
    selectedRows
        .assignAll(List.generate(filteredDataList.length, (index) => false));
  }

  /// إنشاء البيانات التجريبية
  void fetchProducts() {
    dataList.assignAll(
      List.generate(
        36,
            (index) => {
          'Column1': 'User ${index + 1}',
          'Column2': 'Email${index + 1}@gmail.com',
          'Column3': 'Role ${index + 1}',
          'Column4': 'Active',
        },
      ),
    );

    filteredDataList.assignAll(dataList);
    selectedRows
        .assignAll(List.generate(filteredDataList.length, (index) => false));
  }
}
