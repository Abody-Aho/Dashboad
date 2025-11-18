import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// وحدة تحكم المستخدمين - User Controller
/// مسؤولة عن إدارة بيانات المستخدمين، البحث، الفرز، والاختيار.
class PaymentController extends GetxController {
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
    fetchPayments();
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
                  icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.grey, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('View ${data['Column1']}'),
                  tooltip: 'view'.tr,
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
      label: Text('transaction_number'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: Text('order_number'.tr),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: Text('customer'.tr),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: Text('amount'.tr),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: Text('payment_method'.tr),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: Text('status'.tr),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: Text('supermarket'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: Text('date'.tr),
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
          .where((item) => item.values
          .any((value) => value.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }

    filteredDataList.assignAll(results);
    selectedRows.assignAll(
        List.generate(filteredDataList.length, (index) => false));
  }

  /// تحميل بيانات تجريبية للمستخدمين
  void fetchPayments() {
    final paymentMethods = ['Cash'.tr, 'E-Wallet'.tr, 'Bank Transfer'.tr, 'POS'.tr];
    final statuses = ['Completed'.tr, 'Pending'.tr, 'Failed'.tr];
    final supermarkets = ['Sham Supermarket'.tr, 'Yemen Supermarket'.tr, 'Future Supermarket'.tr];

    dataList.assignAll(
      List.generate(
        20,
            (index) => {
          'Column1': 'TX-${1000 + index}',
          'Column2': '#${500 + index}',
          'Column3': '${'Customer'.tr} ${index + 1}',
          'Column4': '${(index + 1) * 1200} ريال',
          'Column5': paymentMethods[index % paymentMethods.length],
          'Column6': statuses[index % statuses.length],
          'Column7': supermarkets[index % supermarkets.length],
          'Column8': '2025-11-${(index % 28) + 1}',
        },
      ),
    );

    filteredDataList.assignAll(dataList);
    selectedRows.assignAll(
      List.generate(filteredDataList.length, (index) => false),
    );
  }

  final selectedValue = 'all_statuses'.obs;
  final options = ['all_statuses','completed', 'pending','failed','refunded'];

  // عند التغيير
  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  final selectedWay = 'all_methods'.obs;
  final List<String> paymentWay = [
    'all_methods',
    'Cash',
    'Credit Card',
    'Digital Wallet',
    'Bank Transfer',
  ];

  // عند التغيير
  void changeWay(String newValue) {
    selectedWay.value = newValue;
  }

}
