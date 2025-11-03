// products_page.dart
import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'products_controller.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(ProductsController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.transparent,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white54,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Row الزر + البحث
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, color: Colors.black),
                            label: const Text("إضافة منتج",
                                style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 120.w,
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
                      // جدول داخل SizedBox لتحديد ارتفاعه
                      Obx(() {
                        return SizedBox(
                          height: 600.h, // غيّر هذا حسب احتياجك
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
                              columns: const [
                                DataColumn(label: Text('Column 1')),
                                DataColumn(label: Text('Column 2')),
                                DataColumn(label: Text('Column 3')),
                                DataColumn(label: Text('Column 4')),
                              ],
                              source: MyData(
                                controller.filteredDataList,
                                controller.selectedRows,
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  final List<Map<String, String>> dataList;
  final RxList<bool> selectedRows;

  MyData(this.dataList, this.selectedRows);

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
      cells: [
        DataCell(Text(data['Column1'] ?? '')),
        DataCell(Text(data['Column2'] ?? '')),
        DataCell(Text(data['Column3'] ?? '')),
        DataCell(Text(data['Column4'] ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dataList.length;

  @override
  int get selectedRowCount =>
      selectedRows.where((selected) => selected).length;
}
