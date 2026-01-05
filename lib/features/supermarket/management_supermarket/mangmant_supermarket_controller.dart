import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// وحدة تحكم المستخدمين - User Controller
/// مسؤولة عن إدارة بيانات المستخدمين، البحث، الفرز، والاختيار.
class ManagementSupermarketController extends GetxController {
  var dataList = <Map<String, String>>[].obs;        // جميع بيانات المستخدمين
  var filteredDataList = <Map<String, String>>[].obs; // البيانات بعد البحث أو التصفية
  RxList<bool> selectedRows = <bool>[].obs;          // حالة التحديد لكل صف

  RxInt sortColumnIndex = 0.obs;                     // العمود المفعل للفرز
  RxBool sortAscending = true.obs;                   // اتجاه الفرز
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
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.grey, size: 25),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('View ${data['Column1']}'),
                  tooltip: "view".tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.check, color: Colors.green, size: 25),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('Edit ${data['Column1']}'),
                  tooltip: "accept".tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 25),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('Delete ${data['Column1']}'),
                  tooltip: "delete".tr,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  /// تعريف أعمدة الجدول مع دعم الترجمة
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: Text('store_name'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: Text('owner'.tr),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: Text('email'.tr),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: Text('phone'.tr),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: Text('address'.tr),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: Text('status'.tr),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: Text('register_date'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: Text('actions'.tr),
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

  /// تحميل بيانات تجريبية لادارة السوبرماركت
  void fetchUsers() {
    final statuses = ['pending'.tr, 'accepted'.tr, 'rejected'.tr];
    final addresses = [
      'sanaa_hisaba'.tr,
      'taiz_tahrir'.tr,
      'aden_khor_maksar'.tr,
      'ib_center'.tr,
      'hodieda_port'.tr,
      'dhamar_street'.tr,
      'mukalla_dis'.tr,
      'saada_city'.tr,
    ];

    dataList.assignAll(
      List.generate(
        20,
            (index) => {
          'Column1': '${'supermarket'.tr} ${index + 1}',
          'Column2': '${'owner'.tr} ${index + 1}',
          'Column3': 'market${index + 1}@gmail.com',
          'Column4': '77${9000000 + index}',
          'Column5': addresses[index % addresses.length],
          'Column6': statuses[index % statuses.length],
          'Column7': '2025-0${(index % 9) + 1}-15',
        },
      ),
    );

    filteredDataList.assignAll(dataList);
    selectedRows.assignAll(
        List.generate(filteredDataList.length, (index) => false));
  }

}
