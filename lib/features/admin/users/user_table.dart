import 'package:dashbord2/features/admin/users/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_link.dart';
import '../../../data/models/user_model.dart';

mixin UserTable on GetxController {

  RxList<bool> selectedRows = <bool>[].obs;
  RxInt sortColumnIndex = 0.obs;
  RxBool sortAscending = true.obs;
  var filteredDataList = <Map<String, String>>[].obs;
  // ======================= DATA CELLS =======================
  List<DataCell> getDataCells(Map<String, dynamic> data) {
    return [
      _textCell(data['Column1'], 180), // الاسم
      _textCell(data['Column2'], 220), // الإيميل
      _textCell(data['Column3'], 140), // الهاتف
      _textCell(data['Column4'], 140), // الدور
      _statusCell(data['Column5']), // الحالة
      _textCell(data['Column6'], 150), // تاريخ الإنشاء (بدون ساعة)
      _actionCell(data, data['Column5']), // العمليات
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
    final bool isActive = status == 'active'.tr;
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

  DataCell _actionCell(Map<String, dynamic> data, String? status) {
    final bool isActive = status == 'active'.tr;
    return DataCell(
      SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: IconButton(
                icon: Icon(
                  isActive ? Icons.person : Icons.person_off,
                  color: Colors.grey,
                  size: 25,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => (this as UserController).toggleUserStatus(data),
                tooltip: 'View'.tr,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                padding: EdgeInsets.zero,
                onPressed: () {
                  final user = UserModel(
                    id: int.tryParse(data['id'] ?? ''),
                    firebaseUid: '',
                    name: data['name'] ?? '',
                    email: data['Column2'] ?? '',
                    phone: data['Column3'] ?? '',
                    role: data['role_raw'] ?? '',
                    status: data['Column5'] == 'active'.tr ? 1 : 0,

                    image: data['image'],
                    nameAr: data['name_ar'],
                    vehicleNumber: data['vehicle_number'],
                    location: data['supermarket_location'],
                    timeOpen: data['supermarket_time_open'],
                  );

                  (this as UserController).showEditDialog(user);
                  print("IMAGE NAME => ${user.image}");
                  print("${AppLink.image}${user.image}");

                },
                tooltip: 'Edit'.tr,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                padding: EdgeInsets.zero,
                onPressed: () {
                  (this as UserController).showDeleteDialog(data);
                },
                tooltip: 'Delete'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================= SORT =======================
  void sortData(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    final key = 'Column${columnIndex + 1}';

    filteredDataList.sort((a, b) {
      final aVal = a[key] ?? '';
      final bVal = b[key] ?? '';

      dynamic result;

      if (columnIndex == 2) {
        final aNum = int.tryParse(aVal) ?? 0;
        final bNum = int.tryParse(bVal) ?? 0;
        result = aNum.compareTo(bNum);
      } else if (columnIndex == 5) {
        final aDate = DateTime.tryParse(aVal) ?? DateTime(2000);
        final bDate = DateTime.tryParse(bVal) ?? DateTime(2000);
        result = aDate.compareTo(bDate);
      } else {
        result = aVal.toLowerCase().compareTo(bVal.toLowerCase());
      }

      return ascending ? result : -result;
    });

    filteredDataList.refresh();
  }

  List<DataColumn> get tableColumns => [
    DataColumn(label: Text('name'.tr), onSort: (i, a) => sortData(0, a)),
    DataColumn(label: Text('user_email'.tr), onSort: (i, a) => sortData(1, a)),
    DataColumn(label: Text('phone'.tr), onSort: (i, a) => sortData(2, a)),
    DataColumn(label: Text('type'.tr), onSort: (i, a) => sortData(3, a)),
    DataColumn(label: Text('status'.tr), onSort: (i, a) => sortData(4, a)),
    DataColumn(
      label: Text('registration_date'.tr),
      onSort: (i, a) => sortData(5, a),
    ),
    DataColumn(label: Text('actions'.tr)),
  ];

  List<Map<String, dynamic>> getSelectedUsers() {
    List<Map<String, dynamic>> selectedUsers = [];

    for (int i = 0; i < selectedRows.length; i++) {
      if (selectedRows[i]) {
        selectedUsers.add(filteredDataList[i]);
      }
    }

    return selectedUsers;
  }

}