import 'package:dashbord2/features/admin/orders/order_dialogs.dart';
import 'package:dashbord2/features/admin/orders/order_helpers.dart';
import 'package:dashbord2/features/admin/orders/order_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_api.dart';
import 'dart:async';
class OrdersController extends GetxController
    with OrderApi, OrderDialogs, OrderTable, OrderHelpers {
  var dataList = <Map<String, dynamic>>[].obs;
  var filteredDataList = <Map<String, dynamic>>[].obs;
  var filteredCoupons = <Map<String, dynamic>>[].obs;
  var couponsList = <Map<String, dynamic>>[].obs;
  Timer? _timer;


  RxList<bool> selectedRows = <bool>[].obs;
  RxBool isLoading = true.obs;
  RxBool isCouponLoading = true.obs;

  RxInt sortColumnIndex = 0.obs;
  RxBool sortAscending = true.obs;
  var totalOrders = 0.obs;
  var runningOrders = 0.obs;
  var completedOrders = 0.obs;
  var cancelledOrders = 0.obs;

  var isLoadingStats = false.obs;
  bool isActive = true;

  final searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    fetchOrders();
    fetchStats();

    startAutoRefresh();
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
          fetchStats(),
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
  OrdersController get controller => this;

  @override
  void onClose() {
    isActive = false;
    _timer?.cancel();
    super.onClose();
  }
}
