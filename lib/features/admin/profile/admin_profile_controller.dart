import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminProfileController extends GetxController {

  var isEdit = false.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  var imageUrl =
      "images/profile.png".obs;

  @override
  void onInit() {
    nameController.text = "Admin Name";
    phoneController.text = "777777777";
    emailController.text = "admin@email.com";
    super.onInit();
  }

  void toggleEdit() {
    isEdit.value = !isEdit.value;
  }

  void saveProfile() {
    /// هنا تربطه مع API
    Get.snackbar(
      "تم الحفظ",
      "تم تحديث بيانات الأدمن",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    isEdit.value = false;
  }

  void changeImage() {
    /// FilePicker او ImagePicker
  }
}