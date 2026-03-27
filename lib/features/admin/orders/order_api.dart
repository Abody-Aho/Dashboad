import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';
import 'orders_controller.dart';

mixin OrderApi on GetxController{
  OrdersController get controller;

  Future<void> fetchOrders() async {
    try {
      controller.isLoading.value = true;
      final response = await http.get(Uri.parse(AppLink.ordersView));

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
              'Column3': order['supermarket'] ?? '-',
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
      Get.snackbar("Error", e.toString());
    } finally {
      controller.isLoading.value = false;
    }
  }

  Future<void> fetchCoupons() async {
    try {
      controller.isCouponLoading.value = true;

      final response = await http.get(Uri.parse(AppLink.viewCoupon));
      final body = jsonDecode(response.body);

      if (body['status'] == "success") {
        final List coupons = body['data'] ?? [];

        controller.couponsList.clear();
        controller.filteredCoupons.clear();

        controller.couponsList.assignAll(
          coupons.map<Map<String, dynamic>>((c) {
            return {
              'id': c['coupon_id'].toString(),

              'Column1': c['coupon_name'] ?? '-',
              'Column2': (c['coupon_discount'] ?? 0).toString(),
              'Column3': (c['coupon_count'] ?? 0).toString(),
              'Column4': c['coupon_expiredate'] ?? '-',
            };
          }).toList(),
        );

        controller.filteredCoupons.assignAll(controller.couponsList);
      } else {
        controller.couponsList.clear();
        controller.filteredCoupons.clear();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      controller.isCouponLoading.value = false;
    }
  }

  Future addCoupon(Map data) async {
    try {
      if (data['name'].isEmpty ||
          data['count'].isEmpty ||
          data['discount'].isEmpty ||
          data['expire'].isEmpty) {

        Get.snackbar("تنبيه", "كل الحقول مطلوبة");
        return;
      }

      final response = await http.post(
        Uri.parse(AppLink.addCoupon),
        body: data,
      );

      final body = jsonDecode(response.body);

      if (body['status'] == "success") {
        Get.back();

        Get.snackbar(
          "نجاح",
          "تم إضافة الكوبون",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        fetchCoupons();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future editCoupon(int id, Map data) async {
    try {
      data['id'] = id.toString();

      final response = await http.post(
        Uri.parse(AppLink.editCoupon),
        body: data,
      );

      final body = jsonDecode(response.body);

      if (body['status'] == "success") {

        Get.snackbar(
          "نجاح",
          "تم تعديل الكوبون",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        fetchCoupons();

      } else {
        Get.snackbar("Error", "فشل التعديل");
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future deleteCoupon(int id) async {
    try {
      final response = await http.post(
        Uri.parse(AppLink.deleteCoupon),
        body: {"id": id.toString()},
      );

      final body = jsonDecode(response.body);

      if (body['status'] == "success") {

        controller.couponsList.removeWhere(
              (e) => e['id'] == id.toString(),
        );

        controller.filteredCoupons.removeWhere(
              (e) => e['id'] == id.toString(),
        );

        Get.snackbar(
          "نجاح",
          "تم حذف الكوبون",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

      } else {
        Get.snackbar("Error", "فشل الحذف");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


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
