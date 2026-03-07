import 'dart:convert';
import 'package:dashbord2/features/admin/orders/order_dialogs.dart';
import 'package:dashbord2/features/admin/orders/order_helpers.dart';
import 'package:dashbord2/features/admin/orders/order_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';
import '../../widgets/app_delete_dialog.dart';
import 'order_api.dart';

class OrdersController extends GetxController with OrderApi, OrderDialogs, OrderTable, OrderHelpers{

  var dataList = <Map<String, dynamic>>[].obs;
  var filteredDataList = <Map<String, dynamic>>[].obs;

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


    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
            AppLink.ordersView,),
      );

      final body = jsonDecode(response.body);

      if (body['status'] == 'success') {
        final List orders = body['data'];

        dataList.assignAll(
          orders.map<Map<String, dynamic>>((order) {
            return {
              'id': order['id'].toString(),

              'status_raw': order['orders_status'],

              'Column1': order['id'].toString(),
              'Column2': order['user'] ?? '-',
              'Column3': order['supermarket'] ?? '-',
              'Column4': order['driver'] ?? '-',
              'Column5': order['orders_totalprice'].toString(),
              'Column6': _mapPayment(order['orders_paymentmethod']),
              'Column7': _mapStatus(order['orders_status']),
              'Column8': _formatDate(order['orders_datetime']),
            };
          }).toList(),
        );

        filteredDataList.assignAll(dataList);
        selectedRows.assignAll(
          List.generate(filteredDataList.length, (_) => false),
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String _mapStatus(dynamic s) {
    switch (s.toString()) {
      case "0": return "pending";
      case "1": return "accepted";
      case "2": return "on_the_way";
      case "3": return "delivered";
      case "4": return "cancelled";
      default: return "-";
    }
  }

  String _mapPayment(dynamic p) {
    switch (p.toString()) {
      case "0": return "cash";
      case "1": return "card";
      default: return "-";
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
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.visibility,color: Colors.grey,),
                onPressed: () async{
                  var items = await controller.getOrderItems(
                      int.parse(data['id'])
                  );
                  print("items = $items"); // أضف هذا

                  controller.showOrderDetailsDialog(
                    order: data,
                    items: items,
                  );
                },
                padding: EdgeInsets.zero,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.delivery_dining),
                onPressed: () {
                  showStatusDialog(
                    int.parse(data['id']),
                    int.parse(data['status_raw'].toString()),
                    controller,
                  );
                },
                padding: EdgeInsets.zero,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.close,color: Colors.red,),
                onPressed: () {
                  AppDeleteDialog.show(
                    title: "حذف الطلب",
                    message: "هل أنت متأكد من حذف الطلب رقم",
                    itemName: "#${data['id']}",
                    icon: Icons.delete_outline,
                    color: Colors.red,
                    onConfirm: () {
                      controller.deleteOrder(
                        int.parse(data['id']),
                      );
                    },

                  );
                },
                padding: EdgeInsets.zero,
              ),
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

  @override
  OrdersController get controller => this;
}
