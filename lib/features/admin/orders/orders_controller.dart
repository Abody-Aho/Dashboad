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

class OrdersController extends GetxController
    with OrderApi, OrderDialogs, OrderTable, OrderHelpers {
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

  final selectedValue = 'all_types'.obs;

  final options = ['all_types', 'clients', 'agents', 'supermarkets'];

  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  @override
  OrdersController get controller => this;
}
