import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

/// ويدجت عامة للجدول يمكن ربطها بأي Controller
class CustomDataTable extends StatelessWidget {
  final dynamic controller; // أي Controller فيه بيانات الجدول
  final String addButtonText; // نص الزر
  final VoidCallback? onAddPressed; // الدالة اللي تتنفذ عند الضغط

  const CustomDataTable({
    super.key,
    required this.controller,
    this.addButtonText = "إضافة",
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white54,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 10),

            // ====== الصف العلوي (الزر + البحث) ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // زر إضافة
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: ElevatedButton.icon(
                    onPressed: onAddPressed ?? controller.onAddPressed,
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: Text(addButtonText,
                        style: const TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),

                // مربع البحث
                Container(
                  height: 40,
                  width: 120.w,
                  margin: EdgeInsets.only(right: 5.w),
                  child: TextFormField(
                    controller: controller.searchTextController,
                    onChanged: (query) => controller.searchQuery(query),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2.5,
                        ),
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.green[700]),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ====== الجدول ======
            Obx(() {
              // لجعل الجدول يتحدث عند تغير البيانات
              Visibility(
                visible: false,
                child: Text(
                  controller.filteredDataList.length.toString(),
                ),
              );
              return SizedBox(
                height: 600.h,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cardTheme: const CardThemeData(
                      color: Colors.white54,
                      elevation: 0,
                    ),
                  ),
                  child: PaginatedDataTable2(
                    columnSpacing: 12,
                    minWidth: 786,
                    dividerThickness: 0.5,
                    horizontalMargin: 12,
                    dataRowHeight: 56,
                    availableRowsPerPage: const [5, 10, 12, 20],
                    rowsPerPage: 12,
                    headingRowColor: WidgetStateColor.resolveWith(
                          (states) => Colors.green.shade100,
                    ),
                    headingTextStyle: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    showCheckboxColumn: true,
                    showFirstLastButtons: true,
                    renderEmptyRowsInTheEnd: true,
                    onRowsPerPageChanged: (value) {},
                    sortAscending: controller.sortAscending.value,
                    sortColumnIndex: controller.sortColumnIndex.value,
                    columns: controller.tableColumns,
                    source: GenericDataSource(
                      controller.filteredDataList,
                      controller.selectedRows,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// مصدر البيانات العام لأي جدول
class GenericDataSource extends DataTableSource {
  final List<Map<String, String>> dataList;
  final RxList<bool> selectedRows;

  GenericDataSource(this.dataList, this.selectedRows);

  @override
  DataRow? getRow(int index) {
    final data = dataList[index];
    return DataRow2(
      onTap: () => print('Row ${index + 1} clicked'),
      selected: selectedRows[index],
      onSelectChanged: (value) {
        selectedRows[index] = value ?? false;
        notifyListeners();
      },
      cells: data.values.map((v) => DataCell(Text(v))).toList(),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dataList.length;

  @override
  int get selectedRowCount => selectedRows.where((s) => s).length;
}
