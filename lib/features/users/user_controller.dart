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
    fetchUsers();
  }

  List<DataCell> getDataCells(Map<String, dynamic> data) {
    return [
      DataCell(Text(data['Column1'] ?? '', overflow: TextOverflow.ellipsis)),
      DataCell(Text(data['Column2'] ?? '', overflow: TextOverflow.ellipsis)),
      DataCell(Text(data['Column3'] ?? '', overflow: TextOverflow.ellipsis)),
      DataCell(Text(data['Column4'] ?? '', overflow: TextOverflow.ellipsis)),
      DataCell(Text(data['Column5'] ?? '', overflow: TextOverflow.ellipsis)),
      DataCell(Text(data['Column6'] ?? '', overflow: TextOverflow.ellipsis)),
      DataCell(Text(data['Column7'] ?? '', overflow: TextOverflow.ellipsis)),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.grey),
              onPressed: () {
                // هنا تحط الكود لتغيير الأيقونة إذا أحببت
              },
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => print('Edit ${data['Column1']}'),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => print('Delete ${data['Column1']}'),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    ];
  }
  ///  الأعمدة الخاصة بالجدول مع الترتيب
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: const Text('الاسم'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    DataColumn(
      label: const Text('البريد الإلكتروني'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    DataColumn(
      label: const Text('الهاتف'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    DataColumn(
      label: const Text('النوع'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    DataColumn(
      label: const Text('الحالة'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    DataColumn(
      label: const Text('تاريخ التسجيل'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    DataColumn(
      label: const Text('آخر نشاط'),
      onSort: (columnIndex, ascending) => sortById(columnIndex, ascending),
    ),
    const DataColumn(
      label: Text('الإجراءات'),
    ),
  ];

  /// عند الضغط على زر الإضافة
  void onAddPressed() {
    print("تم الضغط على زر إضافة مستخدم");
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

  /// إنشاء بيانات تجريبية مناسبة للأعمدة
  void fetchUsers() {
    dataList.assignAll(
      List.generate(
        20,
            (index) => {
          'Column1': 'المستخدم ${index + 1}',
          'Column2': 'user${index + 1}@gmail.com',
          'Column3': '77${9000000 + index}',
          'Column4': index.isEven ? 'ذكر' : 'أنثى',
          'Column5': index.isEven ? 'نشط' : 'غير نشط',
          'Column6': '2025-0${(index % 9) + 1}-15',
          'Column7': '2025-11-${(index % 28) + 1}',
          'Column8': '...',
        },
      ),
    );

    filteredDataList.assignAll(dataList);
    selectedRows.assignAll(
        List.generate(filteredDataList.length, (index) => false));
  }
}
