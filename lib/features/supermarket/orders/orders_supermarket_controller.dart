import 'dart:async';

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

  var totalOrders = 0.obs;
  var runningOrders = 0.obs;
  var completedOrders = 0.obs;
  var cancelledOrders = 0.obs;

  var isLoadingStats = false.obs;

  final searchTextController = TextEditingController();
  final box = GetStorage();
  int supermarketId = 0;
  Timer? _timer;
  bool isActive = true;


  @override
  void onInit() {
    super.onInit();

    final user = box.read("user");

    if (user != null) {
      supermarketId = int.parse(user["id"].toString());
    }

    fetchOrders();
    fetchStats(supermarketId: supermarketId);
  }

  void startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {

      if (!isActive) return;

      if (isLoading.value || isLoadingStats.value) return;

      try {
        isLoading.value = true;
        isLoadingStats.value = true;

        await Future.wait([
          fetchOrders(),
         fetchStats(supermarketId: supermarketId)
        ]);

      } finally {
        isLoading.value = false;
        isLoadingStats.value = false;
      }
    });
  }

  final selectedValue = 'all_types'.obs;

  final options = ['all_types', 'clients', 'agents', 'supermarkets'];

  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  @override
  OrdersSupermarketController get controller => this;

  @override
  void onClose() {
    isActive = false;
    _timer?.cancel();
    super.onClose();
  }
}
