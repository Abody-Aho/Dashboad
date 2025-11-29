import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class AuthController extends GetxController {
  // العناصر (الاسم + الأيقونة)
  final roles = [
    {
      'label': 'مدير النظام',
      'icon': Icons.admin_panel_settings,
      'color': Colors.red
    },
    {
      'label': 'مالك سوبرماركت',
      'icon': Icons.store_mall_directory,
      'color': Colors.green
    },
  ];

  var selectedRole = RxnString();

  void setRole(String role) {
    selectedRole.value = role;
  }

  // -----------------------------
  // 🟢 Controllers جديدة
  // -----------------------------
  final nameController = TextEditingController(); // الاسم
  final emailController = TextEditingController(); // الإيميل
  final passwordController = TextEditingController(); // الباسوورد
  final confirmPasswordController =
  TextEditingController(); // تأكيد الباسوورد

  // -----------------------------
  // 🟢 حالات الواجهة
  // -----------------------------
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // =============================
  // 🔐 تسجيل الدخول login()
  // =============================
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

      // مثال انتقال بعد النجاح
      // Get.offAllNamed("/admin");
    } else {
      Get.snackbar("خطأ", "بيانات الدخول غير صحيحة ❌",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // =============================
  // 🟢 🔥 إنشاء حساب register() - بشكل تجريبي
  // =============================
  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final role = selectedRole.value;

    // التحقق من الحقول
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        role == null) {
      Get.snackbar("خطأ", "يرجى تعبئة جميع الحقول",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("خطأ", "كلمتا المرور غير متطابقتين",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // -----------------------------
    // 🔥 تسجيل تجريبي بدون API
    // -----------------------------
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // محاكاة انتظار السيرفر
    isLoading.value = false;

    // نفترض أن العملية "نجحت"
    Get.snackbar(
      "تم",
      "تم إنشاء الحساب بنجاح 🎉",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // 🔄 توجيه المستخدم بعد النجاح
    // غيّر المسار لاحقًا
    Get.offAllNamed("/admin");
  }
}
