import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// وحدة تحكم المستخدمين - User Controller
/// مسؤولة عن إدارة بيانات المستخدمين، البحث، الفرز، والاختيار.
class ProductsController extends GetxController {
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
    fetchProducts();
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
                  icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.grey, size: 25),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('View ${data['Column1']}'),
                  tooltip: 'view'.tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('Edit ${data['Column1']}'),
                  tooltip: 'edit'.tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('Delete ${data['Column1']}'),
                  tooltip: 'delete'.tr,
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
      label: Text('product_name'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: Text('category'.tr),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: Text('price'.tr),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: Text('stock'.tr),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: Text('supermarket'.tr),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: Text('availability'.tr),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: Text('sales'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: Text('last_update'.tr),
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
  void fetchProducts() {
    final categories = ['خضار', 'فاكهة', 'مشروبات', 'أدوات منزلية'];
    final supermarkets = ['سوبرماركت الشام', 'سوبرماركت اليمن', 'سوبرماركت المستقبل'];
    final availability = ['متوفر', 'غير متوفر'];

    dataList.assignAll(
      List.generate(
        20,
            (index) => {
          'Column1': 'منتج ${index + 1}', // اسم المنتج
          'Column2': categories[index % categories.length], // التصنيف
          'Column3': '${(index + 1) * 5} ريال', // السعر
          'Column4': '${(index + 1) * 10}', // المخزون
          'Column5': supermarkets[index % supermarkets.length], // السوبرماركت
          'Column6': availability[index % availability.length], // التوفر
          'Column7': '${(index + 1) * 20}', // المبيعات
          'Column8': '2025-11-${(index % 28) + 1}', // اخر تحديث
        },
      ),
    );

    filteredDataList.assignAll(dataList);
    selectedRows.assignAll(
      List.generate(filteredDataList.length, (index) => false),
    );
  }

  final selectedValue = 'all_status'.obs;
  final options = ['all_status','available', 'not_available'];

  // عند التغيير
  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  final selectedCategories = 'all_categories'.obs;
  final List<String> supermarketCategories = [
    'all_categories',
    'bakery',
    'dairy',
    'grains',
    'fruits',
    'vegetables',
    'meat',
    'drinks',
    'detergents',
  ];

  // عند التغيير
  void changeCategories(String newValue) {
    selectedCategories.value = newValue;
  }
}
