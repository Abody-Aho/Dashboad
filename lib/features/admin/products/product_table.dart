import 'dart:convert';
import 'package:dashbord2/features/admin/products/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_link.dart';
import '../../../data/models/product_model.dart';

mixin ProductTable on GetxController {
  ProductsController get controller;

  Future<void> fetchProducts() async {
    try {
      controller.isLoading.value = true;

      final response = await http.get(Uri.parse(AppLink.itemsAdminView));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          final List items = body['data'];

          controller.dataList.assignAll(
            items
                .map<ProductModel>((item) => ProductModel.fromJson(item))
                .toList(),
          );

          controller.filteredDataList.assignAll(controller.dataList);
          controller.selectedRows.assignAll(
            List.generate(controller.filteredDataList.length, (_) => false),
          );
        }
      }
    } finally {
      controller.isLoading.value = false;
    }
  }

  List<DataCell> getDataCells(ProductModel data) {
    final isArabic = Get.locale?.languageCode == 'ar';
    return [
      DataCell(
        SizedBox(
          width: 80,
          height: 60,
          child: data.image == "empty" || data.image.isEmpty
              ? const Icon(Icons.image_not_supported, color: Colors.grey)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "${AppLink.imageItems}/${data.image}",
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
      _textCell(isArabic ? data.nameAr : data.nameEn, 150),
      _textCell(isArabic ? data.catAr : data.catEn, 140),
      _textCell(data.price.toString(), 80),
      _textCell(data.count.toString(), 80),
      _textCell(isArabic ? data.superAr : data.superEn, 140),
      _textCell(_availability(data.count), 120),
      _textCell(data.sales.toString(), 80),
      _textCell(data.date, 120),
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
                  onPressed: () => print('View '),
                  tooltip: 'view'.tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                  padding: EdgeInsets.zero,
                  onPressed: () => print(
                    "${AppLink.imageCategories}${controller.categoryOldImage.value}",
                  ),
                  tooltip: 'edit'.tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                  padding: EdgeInsets.zero,
                  onPressed: () => print('Delete'),
                  tooltip: 'delete'.tr,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  DataCell _textCell(String? text, double width) {
    return DataCell(
      Tooltip(
        message: text ?? '-',
        child: SizedBox(
          width: width,
          child: Text(text ?? '-', overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

  // تعريف أعمدة الجدول مع دعم الفرز
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: Text('الصورة'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: Text('product_name'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: Text('category'.tr),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: Text('price'.tr),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: Text('stock'.tr),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: Text('supermarket'.tr),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: Text('availability'.tr),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: Text('sales'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: Text('last_update'.tr),
      onSort: (columnIndex, ascending) => sortData(7, ascending),
    ),
    DataColumn(
      label: Text('actions'.tr),
      onSort: (columnIndex, ascending) => sortData(8, ascending),
    ),
  ];

  // تنفيذ عملية الفرز حسب العمود المختار
  void sortData(int columnIndex, bool ascending) {
    controller.sortColumnIndex.value = columnIndex;
    controller.sortAscending.value = ascending;

    controller.filteredDataList.sort((a, b) {
      int result;

      switch (columnIndex) {
        case 0:
          result = a.nameEn.compareTo(b.nameEn);
          break;
        case 1:
          result = a.catEn.compareTo(b.catEn);
          break;
        case 2:
          result = a.price.compareTo(b.price);
          break;
        case 3:
          result = a.count.compareTo(b.count);
          break;
        case 4:
          result = a.superEn.compareTo(b.superEn);
          break;
        case 5:
          result = _availability(a.count).compareTo(_availability(b.count));
          break;
        case 6:
          result = a.sales.compareTo(b.sales);
          break;
        case 7:
          result = a.date.compareTo(b.date);
          break;
        default:
          result = 0;
      }

      return ascending ? result : -result;
    });

    controller.filteredDataList.refresh();
  }

  String _availability(int count) {
    if (count == 0) return "غير متوفر";
    if (count < 10) return "مخزون منخفض";
    return "متوفر";
  }
}
