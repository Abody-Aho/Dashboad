import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';
import 'orders_controller.dart';

mixin OrderTable on GetxController {
  OrdersController get controller;

  List<DataCell> getDataCells(Map<String, dynamic> data) {
    return [
      controller.textCell(data['Column1'], 80),
      controller.textCell(data['Column2'], 160),
      controller.textCell(data['Column3'], 160),
      controller.textCell(data['Column4'], 150),
      controller.textCell(data['Column5'], 100),
      controller.textCell(data['Column6'], 120),
      controller.statusCell(data['Column7']),
      controller.textCell(data['Column8'], 130),
      controller.actionCell(data),
    ];
  }

  List<DataColumn> get tableColumns => [
    DataColumn(label: Text('order_no'.tr), onSort: (i, a) => sortData(0, a)),
    DataColumn(label: Text('client'.tr), onSort: (i, a) => sortData(1, a)),
    DataColumn(label: Text('supermarket_text'.tr), onSort: (i, a) => sortData(2, a)),
    DataColumn(label: Text('driver_text'.tr), onSort: (i, a) => sortData(3, a)),
    DataColumn(label: Text('order_amount'.tr), onSort: (i, a) => sortData(4, a)),
    DataColumn(label: Text('payment_text'.tr), onSort: (i, a) => sortData(5, a)),
    DataColumn(label: Text('status'.tr), onSort: (i, a) => sortData(6, a)),
    DataColumn(label: Text('date_text'.tr), onSort: (i, a) => sortData(7, a)),
    DataColumn(label: Text('actions'.tr)),
  ];

  // ======================= SORT =======================

  void sortData(int columnIndex, bool ascending) {
    controller.sortColumnIndex.value = columnIndex;
    controller.sortAscending.value = ascending;

    final key = 'Column${columnIndex + 1}';

    controller.filteredDataList.sort((a, b) {
      final aVal = a[key] ?? '';
      final bVal = b[key] ?? '';
      return ascending
          ? aVal.toLowerCase().compareTo(bVal.toLowerCase())
          : bVal.toLowerCase().compareTo(aVal.toLowerCase());
    });

    controller.filteredDataList.refresh();
  }

  // ======================= SEARCH =======================

  Future<void> searchQuery(String query) async {
    if (query.isEmpty) {
      await controller.fetchOrders();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("${AppLink.ordersSearch}?query=${Uri.encodeComponent(query)}"),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          List data = body['data'];

          controller.filteredDataList.assignAll(
            data.map<Map<String, dynamic>>((order) {
              return {
                'id': order['id'].toString(),
                'status_raw': order['orders_status'],

                'Column1': order['id'].toString(),
                'Column2': order['user'] ?? '-',
                'Column3': order['supermarket'] ?? '-',
                'Column4': order['driver'] ?? '-',
                'Column5': order['orders_totalprice'].toString(),
                'Column6': controller.mapPayment(order['orders_paymentmethod']),
                'Column7': controller.mapStatus(order['orders_status']),
                'Column8': formatDate(order['orders_datetime']),
              };
            }).toList(),
          );

          controller.selectedRows.assignAll(
            List.generate(controller.filteredDataList.length, (_) => false),
          );
        } else {
          controller.filteredDataList.clear();
        }
      }
    } catch (e) {
      print("Search Error: $e");
    }
  }

  // ======================= DATE FORMAT =======================

  String formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '-';
    return dateTime.split(' ').first;
  }
}
