import 'package:dashbord2/data/models/user_model.dart';
import 'package:dashbord2/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;


  //  أدوار المستخدمين

  final roles = [
    {'label': 'مدير النظام', 'value': 'admin', 'icon': Icons.admin_panel_settings, 'color': Colors.red},
    {'label': 'مالك سوبرماركت', 'value': 'supermarket', 'icon': Icons.store_mall_directory, 'color': Colors.green},
  ];

  var selectedRole = RxnString();
  void setRole(String role) => selectedRole.value = role;


  //  الحقول

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // حقول خاصة بكل دور
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final timeOpenController = TextEditingController();


  //  حالات الواجهة

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;


  //  تسجيل الدخول

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال البريد الإلكتروني وكلمة المرور", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final uid = credential.user!.uid;

      final apiResponse = await ApiServices.getUserData(uid);

      if (apiResponse['status'] == 'success') {
        final user = UserModel.fromJson(apiResponse['data']);

        if (user.role == 'admin') {
          Get.offAllNamed(AppRoutes.dashboardAdmin);
        } else if (user.role == 'supermarket') {
          Get.offAllNamed(AppRoutes.dashboardMarket);
        } else {
          throw Exception("دور المستخدم غير معروف!");
        }
      } else {
        throw Exception(apiResponse['message'] ?? "فشل جلب بيانات المستخدم.");
      }

    } on FirebaseAuthException catch (e) {
      String message = "فشل تسجيل الدخول.";
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
      } else if (e.code == 'invalid-email') {
        message = 'صيغة البريد الإلكتروني غير صحيحة.';
      }
      Get.snackbar("خطأ في المصادقة", message, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("خطأ", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }


  //  إنشاء الحساب

  Future<void> register() async {
    if (selectedRole.value == null) {
      Get.snackbar("خطأ", "يرجى اختيار نوع المستخدم", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    UserCredential? credential;

    try {
      isLoading.value = true;

      credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      final uid = credential.user!.uid;


      final newUser = UserModel(
        firebaseUid: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        role: selectedRole.value!,
        status: 1,
      );

      final response = await ApiServices.signUp(
        user: newUser,
        location: locationController.text.trim(),
        time_open: timeOpenController.text.trim(),
      );

      if (response['status'] == 'success') {
        Get.snackbar("تم", "تم إنشاء الحساب بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed(AppRoutes.login);
      } else {
        await credential.user?.delete();
        Get.snackbar("خطأ في الخادم", response['message'] ?? "فشل حفظ البيانات.", backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      String message = "حدث خطأ أثناء إنشاء الحساب.";
      if (e.code == 'weak-password') {
        message = 'كلمة المرور ضعيفة جدًا (6 أحرف على الأقل).';
      } else if (e.code == 'email-already-in-use') {
        message = 'هذا البريد الإلكتروني مُسجل بالفعل.';
      } else if (e.code == 'invalid-email') {
        message = 'صيغة البريد الإلكتروني غير صحيحة.';
      }
      Get.snackbar("خطأ في المصادقة", message, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      if (credential != null) {
        await credential.user?.delete();
      }
      Get.snackbar("خطأ فادح", "حدث خطأ غير متوقع: ${e.toString()}", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

}
