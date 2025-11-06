import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// وحدة تحكم المستخدمين - User Controller
/// مسؤولة عن إدارة بيانات المستخدمين، البحث، الفرز، والاختيار.
class UserController extends GetxController {
  var dataList = <Map<String, String>>[].obs;        // جميع بيانات المستخدمين
  var filteredDataList = <Map<String, String>>[].obs; // البيانات بعد البحث أو التصفية
  RxList<bool> selectedRows = <bool>[].obs;          // حالة التحديد لكل صف

  RxInt sortColumnIndex = 0.obs;                     // العمود المفعل للفرز
  RxBool sortAscending = true.obs;                   // اتجاه الفرز (تصاعدي / تنازلي)
  final searchTextController = TextEditingController(); // متحكم حقل البحث

  /// عند إنشاء الكنترولر يتم تحميل البيانات مباشرة
  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// إنشاء خلايا البيانات الخاصة بكل صف في الجدول
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
        SizedBox(
          width: 100, //  حدد عرض ثابت كافي لكل الأزرار
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.person, color: Colors.grey, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('View ${data['Column1']}'),
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('Edit ${data['Column1']}'),
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('Delete ${data['Column1']}'),
                ),
              ),
            ],
          ),
        ),
      ),


    ];
  }

  /// تعريف أعمدة الجدول مع دعم الفرز
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: const Text('الاسم'),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: const Text('البريد الإلكتروني'),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: const Text('الهاتف'),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: const Text('النوع'),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: const Text('الحالة'),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: const Text('تاريخ التسجيل'),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: const Text('آخر نشاط'),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: const Text('الإجراءات'),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
  ];

  /// تنفيذ عملية الفرز حسب العمود المختار
  void sortData(int columnIndex, bool ascending) {
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

  /// تنفيذ البحث في الجدول
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
    selectedRows.assignAll(
        List.generate(filteredDataList.length, (index) => false));
  }

  /// تحميل بيانات تجريبية للمستخدمين
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
        },
      ),
    );

    filteredDataList.assignAll(dataList);
    selectedRows.assignAll(
        List.generate(filteredDataList.length, (index) => false));
  }
}
