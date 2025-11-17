import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// وحدة تحكم المستخدمين - User Controller
/// مسؤولة عن إدارة بيانات المستخدمين، البحث، الفرز، والاختيار.
class OrdersController extends GetxController {
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
    fetchOrders();
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
          width: 100, //  حدد عرض ثابت كافي لكل الأزرار
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.grey, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('View ${data['Column1']}'),
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
      label: const Text('رقم الطلب'),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: const Text('العميل'),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: const Text('السوبرماركت'),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: const Text('المندوب'),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: const Text('المبلغ'),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: const Text('طرقة الدفع'),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: const Text('الحالة'),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: const Text('التاريخ'),
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
  void fetchOrders() {
    final paymentMethods = ['كاش', 'محفظة إلكترونية', 'دفع عند الاستلام', 'بطاقة'];
    final statuses = ['جاري', 'مكتمل', 'ملغي', 'قيد التوصيل', 'قيد التحضير'];
    final supermarkets = ['سوبرماركت الأمانة', 'سوبرماركت الخير', 'هايبر ماركت اليمن', 'ماركت الأسرة'];
    final customers = ['أحمد ناجي', 'سليم العزاني', 'عبدالله الكومي', 'آمنة صالح', 'محمد علوي'];
    final drivers = ['عبدالرحمن فيصل', 'أكرم اليافعي', 'حسام عبدالواسع', 'صهيب المريسي'];

    dataList.assignAll(
      List.generate(
        30,
            (index) => {
          'Column1': '#${1000 + index}',                       // رقم الطلب
          'Column2': customers[index % customers.length],      // العميل
          'Column3': supermarkets[index % supermarkets.length],  // السوبرماركت
          'Column4': drivers[index % drivers.length],            // المندوب
          'Column5': '${(1500 + index * 73)} ريال',              // المبلغ
          'Column6': paymentMethods[index % paymentMethods.length], // طريقة الدفع
          'Column7': statuses[index % statuses.length],          // الحالة
          'Column8': '2025-11-${(index % 28) + 1}',                // التاريخ
        },
      ),
    );

    filteredDataList.assignAll(dataList);

    selectedRows.assignAll(
      List.generate(filteredDataList.length, (index) => false),
    );
  }

  final selectedValue = 'جميع الحالات'.obs;
  final options = ['جميع الحالات','جديد', 'قيدالتوصيل', 'مكتمل','ملغي'];

  // عند التغيير
  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

}
