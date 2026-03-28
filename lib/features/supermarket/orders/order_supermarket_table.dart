import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'orders_supermarket_controller.dart';

mixin OrderSupermarketTable on GetxController {
  OrdersSupermarketController get controller;

  List<DataCell> getDataCells(Map<String, dynamic> data) {
    return [
      controller.textCell(data['Column1'], 80),
      controller.textCell(data['Column2'], 160),
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

  void searchQuery(String query) {
    if (query.isEmpty) {
      controller.filteredDataList.assignAll(controller.dataList);
    } else {
      controller.filteredDataList.assignAll(
        controller.dataList.where((item) {
          return item.values.any(
            (v) => v.toLowerCase().contains(query.toLowerCase()),
          );
        }).toList(),
      );
    }

    controller.selectedRows.assignAll(
      List.generate(controller.filteredDataList.length, (_) => false),
    );
  }

  // ======================= DATE FORMAT =======================

  String formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '-';
    return dateTime.split(' ').first;
  }
}
