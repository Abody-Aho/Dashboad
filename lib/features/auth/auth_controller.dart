import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class AuthController extends GetxController {
  // العناصر (الاسم + الأيقونة)
  final roles = [
    {'label': 'مدير النظام', 'icon': Icons.admin_panel_settings , 'color': Colors.red},
    {'label': 'مالك سوبرماركت', 'icon': Icons.store_mall_directory , 'color': Colors.green[700]},
  ];

  var selectedRole = RxnString();

  void setRole(String role) {
    selectedRole.value = role;
  }
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال الإيميل وكلمة المرور",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    final success = await AuthService.login(email, password);
    isLoading.value = false;

    if (success) {
      Get.snackbar("تم", "تم تسجيل الدخول بنجاح ✅",
          backgroundColor: Colors.green, colorText: Colors.white);
      // انتقل لصفحة رئيسية مثلاً:
      // Get.offAll(() => HomeScreen());
    } else {
      Get.snackbar("خطأ", "بيانات الدخول غير صحيحة ❌",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
