import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../features/admin/orders/orders_controller.dart';

class SocketService extends GetxService {
  late WebSocketChannel _channel;
  bool _isConnected = false;

  // الرابط الخاص بسيرفرك موجه للـ WebSocket (على بورت 8080 مثلاً)
  // البروتوكول هنا ws:// وليس http://
  static const String socketServerUrl = 'ws://46.101.225.45:8080';

  @override
  void onInit() {
    super.onInit();
    connectToSocket();
  }

  void connectToSocket() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(socketServerUrl),
      );
      _isConnected = true;
      print("🔌 تم الاتصال بسوكيت السيرفر: $socketServerUrl");

      _channel.stream.listen(
            (message) {
          _handleIncomingMessage(message);
        },
        onError: (error) {
          print("❌ خطأ في السوكيت: $error");
          _reconnect();
        },
        onDone: () {
          print("⚠️ انقطع الاتصال بسوكيت السيرفر");
          _reconnect();
        },
      );
    } catch (e) {
      print("❌ فشل الاتصال بالسوكيت: $e");
      _reconnect();
    }
  }

  void _handleIncomingMessage(String message) {
    try {
      final data = jsonDecode(message);
      final String eventType = data['type'];

      switch (eventType) {

      // 1. إدارة الطلبات
        case 'NEW_ORDER_PLACED':
        case 'ORDER_STATUS_CHANGED':
          if (Get.isRegistered<OrdersController>()) {
            final ordersCtrl = Get.find<OrdersController>();

            // استدعاء الدوال الجاهزة لديك مسبقاً في الـ Mixins
            ordersCtrl.fetchOrders();
            ordersCtrl.fetchStats();

            Get.snackbar(
              "تنبيه لحظي 🔔",
              "تم تحديث حالة الطلبات تلقائياً!",
              backgroundColor: Colors.green.withValues(alpha: 0.8),
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
          }
          break;

      // 2. إدارة المستخدمين (أضفها عندما تجهز الـ Controller الخاص بها)
        case 'NEW_USER_REGISTERED':
        // if (Get.isRegistered<UsersController>()) {
        //   Get.find<UsersController>().fetchUsers();
        // }
          break;

      // 3. إدارة المنتجات
        case 'PRODUCT_UPDATED':
        // if (Get.isRegistered<ProductsController>()) {
        //   Get.find<ProductsController>().fetchProducts();
        // }
          break;

        default:
          print("حدث غير معروف قادم من السيرفر: $eventType");
      }
    } catch (e) {
      print("Error parsing socket message: $e");
    }
  }

  void _reconnect() {
    _isConnected = false;
    // محاولة إعادة الاتصال كل 5 ثوانٍ تلقائياً
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected) {
        print("🔄 محاولة إعادة الاتصال بالسوكيت...");
        connectToSocket();
      }
    });
  }

  @override
  void onClose() {
    _channel.sink.close();
    super.onClose();
  }
}