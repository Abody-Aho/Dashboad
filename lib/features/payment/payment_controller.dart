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
      label: const Text('رقم المعاملة'),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: const Text('رقم الطلب'),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: const Text('العميل'),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: const Text('المبلغ'),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: const Text('طريقة الدفع'),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: const Text('الحالة'),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: const Text('السوبرماركت'),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: const Text('التاريخ'),
      onSort: (columnIndex, ascending) => sortData(7, ascending),
    ),
    DataColumn(
      label: const Text('الإجراءات'),
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
    final paymentMethods = ['نقداً', 'محفظة إلكترونية', 'حوالة', 'POS'];
    final statuses = ['مكتملة', 'معلقة', 'فاشلة'];
    final supermarkets = ['سوبرماركت الشام', 'سوبرماركت اليمن', 'سوبرماركت المستقبل'];

    dataList.assignAll(
      List.generate(
        20,
            (index) => {
          'Column1': 'TX-${1000 + index}', // رقم المعاملة
          'Column2': '#${500 + index}', // رقم الطلب
          'Column3': 'العميل ${index + 1}', // اسم العميل
          'Column4': '${(index + 1) * 1200} ريال', // المبلغ
          'Column5': paymentMethods[index % paymentMethods.length], // طريقة الدفع
          'Column6': statuses[index % statuses.length], // حالة الدفع
          'Column7': supermarkets[index % supermarkets.length], // السوبرماركت
          'Column8': '2025-11-${(index % 28) + 1}', // التاريخ
        },
      ),
    );

    filteredDataList.assignAll(dataList);
    selectedRows.assignAll(
      List.generate(filteredDataList.length, (index) => false),
    );
  }


  final selectedValue = 'جميع الحالات'.obs;
  final options = ['جميع الحالات','مكتمل', 'في الانتظار','فشل','مسترد'];

  // عند التغيير
  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  final selectedWay = 'جميع الطرق'.obs;
  final List<String> paymentWay = [
    'جميع الطرق',
    'كاش',
    'بطاقة اتمانية',
    'محفظة رقمية',
    'تحويل بنكي',
  ];


  // عند التغيير
  void changeWay(String newValue) {
    selectedWay.value = newValue;
  }

}
