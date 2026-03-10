import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_link.dart';
import '../../auth/auth_controller.dart';

class AdminProfileController extends GetxController {

  final AuthController authController = Get.find();

  var isEdit = false.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  var imageUrl = "".obs;

  @override
  void onInit() {
    super.onInit();

    _loadUser();
    ever(authController.currentUser, (_) {
      _loadUser();
    });
  }

  void _loadUser() {

    final user = authController.currentUser.value;

    if (user == null) return;

    nameController.text = user.name;
    phoneController.text = user.phone;
    emailController.text = user.email;

    if (user.image != null && user.image!.isNotEmpty) {
      imageUrl.value = "${AppLink.image}/${user.image}";
    } else {
      imageUrl.value = "";
    }
  }

  void toggleEdit() {
    isEdit.value = !isEdit.value;
  }

  void saveProfile() {

    Get.snackbar(
      "تم الحفظ",
      "تم تحديث بيانات الأدمن",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    isEdit.value = false;
  }

  void changeImage() {}
}