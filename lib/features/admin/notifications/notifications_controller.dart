import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  var dataList = <Map<String, String>>[].obs; // جميع بيانات المستخدمين
  var filteredDataList =
      <Map<String, String>>[].obs; // البيانات بعد البحث أو التصفية
  RxList<bool> selectedRows = <bool>[].obs; // حالة التحديد لكل صف

  RxInt sortColumnIndex = 0.obs; // العمود المفعل للفرز
  RxBool sortAscending = true.obs; // اتجاه الفرز (تصاعدي / تنازلي)
  final searchTextController = TextEditingController(); // متحكم حقل البحث

  /// عند إنشاء الكنترولر يتم تحميل البيانات مباشرة
  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
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
      DataCell(Text(data['Column8'] ?? '', overflow: TextOverflow.ellipsis)),
      DataCell(
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.grey,
                    size: 25,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('View ${data['Column1']}'),
                  tooltip: "view".tr,
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
      label: Text('title'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: Text('type'.tr),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: Text('receivers'.tr),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: Text('sent_count'.tr),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: Text('read_count'.tr),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: Text('read_rate'.tr),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: Text('status'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: Text('send_date'.tr),
      onSort: (columnIndex, ascending) => sortData(7, ascending),
    ),
    DataColumn(
      label: Text('actions'.tr),
      onSort: (columnIndex, ascending) => sortData(8, ascending),
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
          .where(
            (item) => item.values.any(
              (value) => value.toLowerCase().contains(query.toLowerCase()),
            ),
          )
          .toList();
    }

    filteredDataList.assignAll(results);
    selectedRows.assignAll(
      List.generate(filteredDataList.length, (index) => false),
    );
  }

  /// تحميل بيانات تجريبية للمستخدمين
  void fetchNotifications() {
    final types = [
      'all_types'.tr,
      'offer'.tr,
      'order'.tr,
      'update'.tr,
      'alert'.tr,
      'general'.tr,
    ];
    final receivers = [
      'clients'.tr,
      'supermarkets'.tr,
      'delivery'.tr,
      'all'.tr,
    ];
    final statuses = ['sent'.tr, 'pending'.tr, 'failed'.tr];

    dataList.assignAll(
      List.generate(
        20,
        (index) => {
          'Column1': '${'notification_number'.tr} ${index + 1}', // العنوان
          'Column2': types[index % types.length], // النوع
          'Column3': receivers[index % receivers.length], // المستقبلين
          'Column4': (50 + index * 3).toString(), // عدد المرسل إليهم
          'Column5': (20 + index * 2).toString(), // عدد القراءات
          'Column6':
              '${(((20 + index * 2) / (50 + index * 3)) * 100).toStringAsFixed(1)}%', // معدل القراءة
          'Column7': statuses[index % statuses.length], // الحالة
          'Column8': '2025-11-${(index % 28) + 1}', // تاريخ الإرسال
        },
      ),
    );

    filteredDataList.assignAll(dataList);

    selectedRows.assignAll(
      List.generate(filteredDataList.length, (index) => false),
    );
  }

  final selectedValue = 'all_types'.obs;
  final options = [
    'all_types',
    'offer',
    'order',
    'update',
    'alert',
    'general',
  ];

  // عند التغيير
  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  final selectedWay = 'all_statuses'.obs;
  final List<String> paymentWay = ['all_statuses', 'sent', 'pending', 'failed'];

  // عند التغيير
  void changeWay(String newValue) {
    selectedWay.value = newValue;
  }
}
