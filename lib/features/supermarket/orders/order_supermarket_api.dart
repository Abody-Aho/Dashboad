import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';
import 'orders_supermarket_controller.dart';

mixin OrderSupermarketApi on GetxController {
  OrdersSupermarketController get controller;

  Future<void> fetchStats({int? supermarketId}) async {
    try {
      controller.isLoadingStats.value = true;

      String url = AppLink.ordersStats;


      final res = await http.get(Uri.parse("$url?supermarket_id=$supermarketId"));
      final data = jsonDecode(res.body);

      if (data['status'] == 'success') {
        controller.totalOrders.value = data['data']['total_orders'];
        controller.runningOrders.value = data['data']['running_orders'];
        controller.completedOrders.value = data['data']['completed_orders'];
        controller.cancelledOrders.value = data['data']['cancelled_orders'];
      }

    } catch (e) {
      print(e);
    } finally {
      controller.isLoadingStats.value = false;
    }
  }

  Future<void> fetchOrders() async {
    try {
      controller.isLoading.value = true;

      final response = await http.post(
        Uri.parse(AppLink.ordersViewSupermarket),
        body: {"supermarket_id": controller.supermarketId.toString()},
      );

      final body = jsonDecode(response.body);

      if (body['status'] == 'success') {
        final List orders = body['data'];

        controller.dataList.assignAll(
          orders.map<Map<String, dynamic>>((order) {
            return {
              'id': order['id'].toString(),
              'status_raw': order['orders_status'],
              'Column1': order['id'].toString(),
              'Column2': order['user'] ?? '-',
              'Column4': order['driver'] ?? '-',
              'Column5': order['orders_totalprice'].toString(),
              'Column6': controller.mapPayment(order['orders_paymentmethod']),
              'Column7': controller.mapStatus(order['orders_status']),
              'Column8': controller.formatDate(order['orders_datetime']),
            };
          }).toList(),
        );

        controller.filteredDataList.assignAll(controller.dataList);

        controller.selectedRows.assignAll(
          List.generate(controller.filteredDataList.length, (_) => false),
        );
      }
    } catch (e) {
      Get.snackbar("error".tr, e.toString());
    } finally {
      controller.isLoading.value = false;
    }
  }

  Future updateOrderStatus(int orderId, int status) async {
    try {
      final response = await http.post(
        Uri.parse(AppLink.updateStatusSuper),
        body: {
          "order_id": orderId.toString(),
          "status": status.toString(),
        },
      );

      final body = jsonDecode(response.body);

      if (body['status'] == "success") {
        Get.snackbar(
          "success".tr,
          "order_status_updated".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        controller.fetchOrders();
      } else {
        Get.snackbar(
          "error".tr,
          "status_update_failed".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("error".tr, e.toString());
    }
  }

  Future deleteOrder(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse(AppLink.deleteSuperOrder),
        body: {
          "order_id": orderId.toString(),
        },
      );

      final body = jsonDecode(response.body);

      if (body['status'] == "success") {
        Get.back();

        Get.snackbar(
          "success".tr,
          "order_deleted".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        controller.fetchOrders();
      } else {
        Get.snackbar(
          "error".tr,
          "order_delete_failed".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("error".tr, e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {
    final response = await http.post(
      Uri.parse(AppLink.ordersViewDetails),
      body: {
        "order_id": orderId.toString(),
      },
    );

    final body = jsonDecode(response.body);

    if (body['status'] == "success") {
      return List<Map<String, dynamic>>.from(body['data']);
    }

    return [];
  }
}
