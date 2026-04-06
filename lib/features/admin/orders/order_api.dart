// order_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';
import 'orders_controller.dart';

mixin OrderApi on GetxController{
  OrdersController get controller;

  Future<void> fetchStats() async {
    try {
      controller.isLoadingStats.value = true;

      String url = AppLink.ordersStats;


      final res = await http.get(
        Uri.parse(url),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
      );
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
      final response = await http.get(
        Uri.parse(AppLink.ordersView),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
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
      Get.snackbar("error".tr, e.toString());
    } finally {
      controller.isLoading.value = false;
    }
  }

  Future<void> fetchCoupons() async {
    try {
      controller.isCouponLoading.value = true;

      final response = await http.get(
        Uri.parse(AppLink.viewCoupon),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
      );
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
      Get.snackbar("error".tr, e.toString());
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

        Get.snackbar("warning".tr, "all_fields_required".tr);
        return;
      }

      final response = await http.post(
        Uri.parse(AppLink.addCoupon),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
        body: data,
      );

      final body = jsonDecode(response.body);

      if (body['status'] == "success") {
        Get.back();

        Get.snackbar(
          "success".tr,
          "coupon_added".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        fetchCoupons();
      }
    } catch (e) {
      Get.snackbar("error".tr, e.toString());
    }
  }

  Future editCoupon(int id, Map data) async {
    try {
      data['id'] = id.toString();

      final response = await http.post(
        Uri.parse(AppLink.editCoupon),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
        body: data,
      );

      final body = jsonDecode(response.body);

      if (body['status'] == "success") {

        Get.snackbar(
          "success".tr,
          "coupon_updated".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        fetchCoupons();

      } else {
        Get.snackbar("error".tr, "update_failed".tr);
      }

    } catch (e) {
      Get.snackbar("error".tr, e.toString());
    }
  }

  Future deleteCoupon(int id) async {
    try {
      final response = await http.post(
        Uri.parse(AppLink.deleteCoupon),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
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
          "success".tr,
          "coupon_deleted".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

      } else {
        Get.snackbar("error".tr, "delete_failed".tr);
      }
    } catch (e) {
      Get.snackbar("error".tr, e.toString());
    }
  }

  Future updateOrderStatus(int orderId,int superId ,int status) async {

    try {

      final response = await http.post(
        Uri.parse(AppLink.updateStatus),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
        body: {
          "order_id": orderId.toString(),
          "super_id": superId.toString(),
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
        Uri.parse(AppLink.deleteOrder),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
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
      Uri.parse(AppLink.orderDetails),
      headers: {
        "X-API-KEY": "aX9#pL@2026",
      },
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

  // دالة لجلب المتاجر الخاصة بطلب معين
  Future<List<Map<String, dynamic>>> getOrderSupermarkets(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse(AppLink.ordersSupermarkets),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
        body: {
          "orderid": orderId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success') {
          return List<Map<String, dynamic>>.from(body['data']);
        }
      }
    } catch (e) {
      print("Error fetching supermarkets: $e");
    }
    return [];
  }

  Future<bool> updateSupermarketStatus(int orderId, int superId, int status) async {
    try {
      var response = await http.post(
        Uri.parse(AppLink.updateSupermarketStatus), // تأكد من إضافة هذا الرابط في AppLink
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
        body: {
          "orderid": orderId.toString(),
          "superid": superId.toString(),
          "status": status.toString(),
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          return true;
        } else {
          // في حال فشل التعديل على السيرفر (مثلا لم يتم تغيير القيمة)
          Get.snackbar("تنبيه", responseBody['message'] ?? "فشل تحديث الحالة");
          return false;
        }
      }
      return false;
    } catch (e) {
      print("Error updating status: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء محاولة الاتصال بالسيرفر");
      return false;
    }
  }
}