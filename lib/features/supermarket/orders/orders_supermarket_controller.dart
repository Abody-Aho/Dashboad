import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_supermarket_api.dart';
import 'order_supermarket_dialogs.dart';
import 'order_supermarket_helpers.dart';
import 'order_supermarket_table.dart';
import 'package:get_storage/get_storage.dart';
class OrdersSupermarketController extends GetxController
    with OrderSupermarketApi, OrderSupermarketDialogs, OrderSupermarketTable, OrderSupermarketHelpers {
  var dataList = <Map<String, dynamic>>[].obs;
  var filteredDataList = <Map<String, dynamic>>[].obs;

  RxList<bool> selectedRows = <bool>[].obs;
  RxBool isLoading = true.obs;

  RxInt sortColumnIndex = 0.obs;
  RxBool sortAscending = true.obs;

  final searchTextController = TextEditingController();
  final box = GetStorage();
  int supermarketId = 0;


  @override
  void onInit() {
    super.onInit();

    final user = box.read("user");

    if (user != null) {
      supermarketId = int.parse(user["id"].toString());
    }

    fetchOrders();
  }

  final selectedValue = 'all_types'.obs;

  final options = ['all_types', 'clients', 'agents', 'supermarkets'];

  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  @override
  OrdersSupermarketController get controller => this;
}
