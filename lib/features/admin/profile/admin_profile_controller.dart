import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_link.dart';
import '../../auth/auth_controller.dart';

class AdminProfileController extends GetxController {

  final AuthController authController = Get.find();

  var isEdit = false.obs;
  Rxn<Uint8List> imageBytes = Rxn<Uint8List>();
  String? imageName;

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

  Future<void> saveProfile() async {

    final user = authController.currentUser.value;

    if(user == null) return;

    try{

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(AppLink.updateProfile),
      );

      request.fields["id"] = user.id.toString();
      request.fields["name"] = nameController.text;
      request.fields["email"] = emailController.text;
      request.fields["phone"] = phoneController.text;

      if (imageBytes.value != null) {

        request.files.add(
          http.MultipartFile.fromBytes(
            "image",
            imageBytes.value!,
            filename: imageName,
          ),
        );

      }

      var response = await request.send();

      var respStr = await response.stream.bytesToString();

      var data = jsonDecode(respStr);

      if(data["status"] == "success"){

        Get.snackbar(
          "نجاح",
          "تم تحديث البروفايل",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        isEdit.value = false;

      }else{

        Get.snackbar(
          "خطأ",
          data["message"] ?? "فشل التحديث",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(data["message"]);
        print("USER ID = ${user.id}");

      }

    }catch(e){

      Get.snackbar(
        "خطأ",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    }
    if (user.id == null) {
      Get.snackbar(
        "خطأ",
        "معرف المستخدم غير موجود",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

  }
  void changeImage() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {

      imageBytes.value = result.files.single.bytes;
      imageName = result.files.single.name;

      // imageUrl.value = ""; // No longer strictly needed if imageBytes is reactive, but doesn't hurt
    }
  }
}