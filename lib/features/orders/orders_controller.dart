import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// User Controller
/// Responsible for managing user data, search, sorting, and selection.
class OrdersController extends GetxController {
  var dataList = <Map<String, String>>[].obs;        // All user data
  var filteredDataList = <Map<String, String>>[].obs; // Data after search/filter
  RxList<bool> selectedRows = <bool>[].obs;          // Selection state for each row

  RxInt sortColumnIndex = 0.obs;                     // Active column index for sorting
  RxBool sortAscending = true.obs;                   // Sorting direction (ascending/descending)
  final searchTextController = TextEditingController(); // Search field controller

  /// Load data when controller is initialized
  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// Create data cells for each row in the table
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
          width: 100, // Fixed width for buttons
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.person, color: Colors.grey, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('View ${data['Column1']}'),
                  tooltip: 'View'.tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('Edit ${data['Column1']}'),
                  tooltip: 'Edit'.tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => print('Delete ${data['Column1']}'),
                  tooltip: 'Delete'.tr,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  /// Define table columns with sorting support
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: Text('name'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: Text('user_email'.tr),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: Text('phone'.tr),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: Text('type'.tr),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: Text('status'.tr),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: Text('registration_date'.tr),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: Text('last_activity'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: Text('actions'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
  ];

  /// Sort data by selected column
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

  /// Execute search in table
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
    selectedRows.assignAll(List.generate(filteredDataList.length, (index) => false));
  }

  /// Load sample user data
  void fetchUsers() {
    final userTypes = ['Client'.tr, 'Agent'.tr, 'Supermarket'.tr, 'Admin'.tr];
    final statuses = ['Active'.tr, 'Inactive'.tr];

    dataList.assignAll(
      List.generate(
        20,
            (index) => {
          'Column1': '${'User'.tr} ${index + 1}', // Name
          'Column2': 'user${index + 1}@gmail.com', // Email
          'Column3': '77${9000000 + index}', // Phone
          'Column4': userTypes[index % userTypes.length], // Type
          'Column5': statuses[index % statuses.length], // Status
          'Column6': '2025-0${(index % 9) + 1}-15', // Registration Date
          'Column7': '2025-11-${(index % 28) + 1}', // Last Activity
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
    'clients',
    'agents',
    'supermarkets',
  ];

  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }
}
