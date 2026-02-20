import 'dart:convert';
import 'dart:typed_data';
import 'package:dashbord2/features/admin/users/user_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/user_model.dart';

mixin UserForm on GetxController {

  //  الحقول
  var isLoading = false.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameArController = TextEditingController();

  // حقول خاصة بكل دور
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final timeOpenController = TextEditingController();
  final vehicleController = TextEditingController();

  var selectedRole = RxnString();

  void setRole(String role) => selectedRole.value = role;



  //  حالات الواجهة

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  Uint8List? imageBytes;
  String? imageName;
  final _auth = FirebaseAuth.instance;
  final roles = [
    {
      'label': 'مدير النظام',
      'value': 'admin',
      'icon': Icons.admin_panel_settings,
      'color': Colors.red,
    },
    {
      'label': 'مالك سوبرماركت',
      'value': 'supermarket',
      'icon': Icons.store_mall_directory,
      'color': Colors.green,
    },
    {
      'label': 'مندوب',
      'value': 'driver',
      'icon': Icons.delivery_dining,
      'color': Colors.orange,
    },
    {
      'label': 'عميل',
      'value': 'users',
      'icon': Icons.person,
      'color': Colors.blue,
    },
  ];


  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      imageBytes = result.files.first.bytes;
      imageName = result.files.first.name;
      update(); // ← هذا هو السر
    }
  }

  void fillControllers(UserModel user) {
    nameController.text = user.name;
    nameArController.text = user.nameAr ?? '';
    emailController.text = user.email;
    phoneController.text = user.phone;
    locationController.text = user.location ?? '';
    timeOpenController.text = user.timeOpen ?? '';
    vehicleController.text = user.vehicleNumber ?? '';

    imageBytes = null; // مهم جداً
  }

  void _clearInputs() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    locationController.clear();
    timeOpenController.clear();
  }

  Future<void> addAccount() async {
    if (selectedRole.value == null) {
      Get.snackbar("تنبيه", "يرجى اختيار الرتبة أولاً");
      return;
    }

    String role = selectedRole.value!;
    isLoading.value = true;

    try {
      String? uid;

      // 1. التعامل مع Firebase (فقط للأدمن والسوبرماركت)
      if (role == "admin" || role == "supermarket") {
        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
          throw "البريد وكلمة المرور مطلوبان لهذا النوع";
        }
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        uid = credential.user!.uid;
      }

      final response = await ApiServices.adminAddUser(
        role: role,
        name: nameController.text.trim(),
        name_ar: nameArController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        firebaseUid: uid,
        location: "غير محدد",
        timeOpen: "6am to 6pm",
      );

      if (response['status'] == 'success') {
        Get.back(); // إغلاق النافذة
        await (this as UserController).fetchUsers();
        Get.snackbar(
          "تم",
          "تمت إضافة $role بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _clearInputs(); // دالة لتنظيف الحقول
      } else {
        if (uid != null) await _auth.currentUser?.delete();
        Get.snackbar("خطأ", response['message']);
        print(response['message']);
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      isLoading.value = true;

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          AppLink.updateAccount,
        ),
      );

      request.fields['id'] = user.id.toString();
      request.fields['role'] = user.role;

      request.fields['name'] = nameController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['phone'] = phoneController.text.trim();
      request.fields['name_ar'] = nameArController.text.trim();
      request.fields['supermarket_location'] = locationController.text.trim();
      request.fields['supermarket_time_open'] = timeOpenController.text.trim();
      request.fields['vehicle_number'] = vehicleController.text.trim();

      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes!,
            filename: imageName ?? "image.jpg",
          ),
        );
      }

      var response = await request.send();

      // إذا السيرفر رجع خطأ HTTP
      if (response.statusCode != 200) {
        throw Exception("Server Error");
      }

      var responseBody = await response.stream.bytesToString();

      print("UPDATE RESPONSE => $responseBody");

      final body = jsonDecode(responseBody);

      if (body["status"] == "success") {
        await (this as UserController).fetchUsers();
        Get.back(); // إغلاق الدايلوق
        Get.snackbar(
          "تم التعديل",
          "تم تحديث البيانات بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(10),
        );
      } else {
        Get.snackbar(
          "خطأ",
          "فشل في تحديث البيانات",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(10),
        );
      }
    } catch (e) {
      print("UPDATE ERROR => $e");

      Get.snackbar(
        "خطأ",
        "مشكلة في الاتصال بالخادم",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } finally {
      isLoading.value = false;
    }
  }
}