import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// وحدة تحكم المستخدمين - User Controller
class UserController extends GetxController {
  var dataList = <Map<String, String>>[].obs;
  var filteredDataList = <Map<String, String>>[].obs;
  RxList<bool> selectedRows = <bool>[].obs;
  RxBool isLoading = true.obs;

  RxInt sortColumnIndex = 0.obs;
  RxBool sortAscending = true.obs;
  final searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // ======================= DATA CELLS =======================
  List<DataCell> getDataCells(Map<String, dynamic> data) {
    return [
      _textCell(data['Column1'], 180), // الاسم
      _textCell(data['Column2'], 220), // الإيميل
      _textCell(data['Column3'], 140), // الهاتف
      _textCell(data['Column4'], 140), // الدور
      _statusCell(data['Column5']),    // الحالة
      _textCell(data['Column6'], 150), // تاريخ الإنشاء (بدون ساعة)
      _actionCell(data),               // العمليات
    ];
  }

  // ======================= HELPERS =======================
  DataCell _textCell(String? text, double width) {
    return DataCell(
      Tooltip(
        message: text ?? '-',
        child: SizedBox(
          width: width,
          child: Text(
            text ?? '-',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  DataCell _statusCell(String? status) {
    final bool isActive = status == 'Active';
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.shade100 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status ?? '',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.green.shade800 : Colors.red.shade800,
          ),
        ),
      ),
    );
  }

  DataCell _actionCell(Map<String, dynamic> data) {
    return DataCell(
      SizedBox(
        width: 100, // عرض ثابت للأزرار
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.grey, size: 25),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => print('View ${data['Column1']}'),
                tooltip: 'View'.tr,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => print('Edit ${data['Column1']}'),
                tooltip: 'Edit'.tr,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => print('Delete ${data['Column1']}'),
                tooltip: 'Delete'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================= TABLE COLUMNS =======================
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: Text('name'.tr),
      onSort: (i, a) => sortData(0, a),
    ),
    DataColumn(
      label: Text('user_email'.tr),
      onSort: (i, a) => sortData(1, a),
    ),
    DataColumn(
      label: Text('phone'.tr),
      onSort: (i, a) => sortData(2, a),
    ),
    DataColumn(
      label: Text('type'.tr),
      onSort: (i, a) => sortData(3, a),
    ),
    DataColumn(
      label: Text('status'.tr),
      onSort: (i, a) => sortData(4, a),
    ),
    DataColumn(
      label: Text('registration_date'.tr),
      onSort: (i, a) => sortData(5, a),
    ),
    const DataColumn(label: Text('actions')),
  ];

  // ======================= SORT =======================
  void sortData(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    final key = 'Column${columnIndex + 1}';

    filteredDataList.sort((a, b) {
      final aVal = a[key]!.toLowerCase();
      final bVal = b[key]!.toLowerCase();
      return ascending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
    });

    filteredDataList.refresh();
  }

  // ======================= SEARCH =======================
  void searchQuery(String query) {
    List<Map<String, String>> baseList;

    if (selectedValue.value == 'all_types') {
      baseList = dataList;
    } else {
      baseList = dataList.where((item) {
        return item['Column4']?.toLowerCase() ==
            selectedValue.value;
      }).toList();
    }

    if (query.isEmpty) {
      filteredDataList.assignAll(baseList);
    } else {
      filteredDataList.assignAll(
        baseList.where(
              (item) => item.values.any(
                (v) => v.toLowerCase().contains(query.toLowerCase()),
          ),
        ),
      );
    }

    selectedRows.assignAll(
      List.generate(filteredDataList.length, (_) => false),
    );
  }


  // ======================= API =======================
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('http://localhost/flymarket/user_management/view.php'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          final List users = body['data'];

          dataList.assignAll(
            users.map<Map<String, String>>((user) {
              return {
                'Column1': user['name']?.toString() ?? '',
                'Column2': user['email']?.toString() ?? '-',
                'Column3': user['phone']?.toString() ?? '-',
                'Column4': user['role']?.toString() ?? '',
                'Column5':
                user['status'].toString() == '1' ? 'Active' : 'Inactive',
                'Column6': _formatDate(user['created_at']?.toString()),
              };
            }).toList(),
          );

          filteredDataList.assignAll(dataList);
          selectedRows.assignAll(
            List.generate(filteredDataList.length, (_) => false),
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'No internet connection');
    } finally {
      isLoading.value = false;
    }
  }


  // ======================= DATE FORMAT =======================
  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '-';
    return dateTime.split(' ').first; // YYYY-MM-DD
  }

  // ======================= FILTER =======================
  final selectedValue = 'all_types'.obs;
  final options = ['all_types', 'admin', 'customer', 'driver', 'supermarket'];


  void filterByType(String value) {
    selectedValue.value = value;

    if (value == 'all_types') {
      filteredDataList.assignAll(dataList);
    } else {
      filteredDataList.assignAll(
        dataList.where((item) {
          final role = item['Column4']?.toLowerCase();
          return role == value;
        }).toList(),
      );
    }

    selectedRows.assignAll(
      List.generate(filteredDataList.length, (_) => false),
    );
  }




  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }
}
