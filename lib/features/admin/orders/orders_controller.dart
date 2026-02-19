import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';

class OrdersController extends GetxController {

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
    fetchOrders();
  }

  // ======================= API =======================

  Future<void> fetchOrders() async {
    isLoading.value = true;

    try {

      final response = await http.get(
        Uri.parse(
            AppLink.ordersView,),
      );

      final body = jsonDecode(response.body);

      if (body['status'] == 'success') {
        final List orders = body['data'];

        dataList.assignAll(
          orders.map<Map<String, String>>((o) {
            return {
              'id': o['id'].toString(),

              'Column1': o['id'].toString(),
              'Column2': o['users'] ?? '-',
              'Column3': o['supermarket'] ?? '-',
              'Column4': o['driver'] ?? '-',
              'Column5': o['total_amount'] ?? '0',
              'Column6': o['payment_method'] ?? '',
              'Column7': o['status'] ?? '',
              'Column8': _formatDate(o['created_at']),
            };
          }).toList(),
        );

        filteredDataList.assignAll(dataList);
        selectedRows.assignAll(
          List.generate(filteredDataList.length, (_) => false),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load orders");
    } finally {
      isLoading.value = false;
    }
  }

  // ======================= DATA CELLS =======================

  List<DataCell> getDataCells(Map<String, dynamic> data) {
    return [
      _textCell(data['Column1'], 80),
      _textCell(data['Column2'], 160),
      _textCell(data['Column3'], 160),
      _textCell(data['Column4'], 150),
      _textCell(data['Column5'], 100),
      _textCell(data['Column6'], 120),
      _statusCell(data['Column7']),
      _textCell(data['Column8'], 130),
      _actionCell(data),
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
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  DataCell _statusCell(String? status) {
    Color color;

    switch (status) {
      case "pending":
        color = Colors.orange;
        break;
      case "on_the_way":
        color = Colors.blue;
        break;
      case "delivered":
        color = Colors.green;
        break;
      case "cancelled":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status ?? '',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  DataCell _actionCell(Map<String, dynamic> data) {
    return DataCell(
      SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => print("view ${data['id']}"),
            ),
            IconButton(
              icon: const Icon(Icons.delivery_dining),
              onPressed: () => print("assign driver ${data['id']}"),
            ),
          ],
        ),
      ),
    );
  }

  // ======================= TABLE COLUMNS =======================

  List<DataColumn> get tableColumns => [
    DataColumn(label: Text('رقم الطلب'), onSort: (i, a) => sortData(0, a)),
    DataColumn(label: Text('العميل'), onSort: (i, a) => sortData(1, a)),
    DataColumn(label: Text('السوبرماركت'), onSort: (i, a) => sortData(2, a)),
    DataColumn(label: Text('المندوب'), onSort: (i, a) => sortData(3, a)),
    DataColumn(label: Text('المبلغ'), onSort: (i, a) => sortData(4, a)),
    DataColumn(label: Text('الدفع'), onSort: (i, a) => sortData(5, a)),
    DataColumn(label: Text('الحالة'), onSort: (i, a) => sortData(6, a)),
    DataColumn(label: Text('التاريخ'), onSort: (i, a) => sortData(7, a)),
    const DataColumn(label: Text('الإجراءات')),
  ];

  // ======================= SORT =======================

  void sortData(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    final key = 'Column${columnIndex + 1}';

    filteredDataList.sort((a, b) {
      final aVal = a[key] ?? '';
      final bVal = b[key] ?? '';
      return ascending
          ? aVal.toLowerCase().compareTo(bVal.toLowerCase())
          : bVal.toLowerCase().compareTo(aVal.toLowerCase());
    });

    filteredDataList.refresh();
  }

  // ======================= SEARCH =======================

  void searchQuery(String query) {
    if (query.isEmpty) {
      filteredDataList.assignAll(dataList);
    } else {
      filteredDataList.assignAll(
        dataList.where((item) {
          return item.values
              .any((v) => v.toLowerCase().contains(query.toLowerCase()));
        }).toList(),
      );
    }

    selectedRows.assignAll(
      List.generate(filteredDataList.length, (_) => false),
    );
  }

  // ======================= DATE FORMAT =======================

  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '-';
    return dateTime.split(' ').first;
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
