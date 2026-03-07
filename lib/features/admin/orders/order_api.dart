import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';
import 'orders_controller.dart';

mixin OrderApi on GetxController{
  OrdersController get controller;

  Future updateOrderStatus(int orderId, int status) async {

    try {

      final response = await http.post(
        Uri.parse(AppLink.updateStatus),
        body: {
          "order_id": orderId.toString(),
          "status": status.toString(),
        },
      );

      final body = jsonDecode(response.body);

      if (body['status'] == "success") {

        Get.snackbar(
          "Success",
          "تم تحديث حالة الطلب",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        controller.fetchOrders();

      } else {

        Get.snackbar(
          "Error",
          "فشل تحديث الحالة",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

  }

  Future deleteOrder(int orderId) async {

    try {

      final response = await http.post(
        Uri.parse(AppLink.deleteOrder),
        body: {
          "order_id": orderId.toString(),
        },
      );

      final body = jsonDecode(response.body);

      if (body['status'] == "success") {

        Get.back();

        Get.snackbar(
          "Success",
          "تم حذف الطلب",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        controller.fetchOrders();

      } else {

        Get.snackbar(
          "Error",
          "فشل حذف الطلب",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

  }

  Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {

    final response = await http.post(
      Uri.parse(AppLink.orderDetails),
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
