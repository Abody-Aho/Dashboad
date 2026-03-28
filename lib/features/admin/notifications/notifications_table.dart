import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notifications_controller.dart';

mixin NotificationsTable on GetxController{
  NotificationsController get controller;

  List<DataCell> getDataCells(Map<String, String> data) {
    DataCell cell(String key, double width) {
      return DataCell(
        Tooltip(
          message: data[key] ?? '',
          child: SizedBox(
            width: width,
            child: Text(data[key] ?? '', overflow: TextOverflow.ellipsis),
          ),
        ),
      );
    }

    return [
      cell('Column1', 200),
      DataCell(controller.notificationTypeBadge(data['Column2'] ?? "")),
      cell('Column3', 140),
      cell('Column4', 100),
      cell('Column5', 100),
      cell('Column6', 100),
      cell('Column7', 100),
      cell('Column8', 150),

      DataCell(
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.grey,
                    size: 25,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    controller.showNotificationDetails(data);
                  },
                  tooltip: "view".tr,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<DataColumn> get tableColumns => [
    DataColumn(
      label: Text('title'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),

    DataColumn(
      label: Text('type'.tr),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),

    DataColumn(
      label: Text('receivers'.tr),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),

    DataColumn(
      label: Text('sent_count'.tr),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),

    DataColumn(
      label: Text('read_count'.tr),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),

    DataColumn(
      label: Text('read_rate'.tr),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),

    DataColumn(
      label: Text('status'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),

    DataColumn(
      label: Text('send_date'.tr),
      onSort: (columnIndex, ascending) => sortData(7, ascending),
    ),

    DataColumn(label: Text('actions'.tr)),
  ];

  /// الفرز
  void sortData(int columnIndex, bool ascending) {
    controller.sortColumnIndex.value = columnIndex;
    controller.sortAscending.value = ascending;

    String columnKey = 'Column${columnIndex + 1}';

    controller.filteredDataList.sort((a, b) {
      final valueA = (a[columnKey] ?? '').toLowerCase();
      final valueB = (b[columnKey] ?? '').toLowerCase();

      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });

    controller.filteredDataList.refresh();
  }

}
