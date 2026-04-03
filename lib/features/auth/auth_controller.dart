import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dashbord2/data/models/user_model.dart';
import 'package:dashbord2/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_link.dart';
import '../../core/services/api_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  var currentUser = Rxn<UserModel>();
  final box = GetStorage();

  // متغيرات خاصة بالويب للتعامل مع الملفات
  var webImageBytes = Rxn<Uint8List>();
  var webPdfBytes = Rxn<Uint8List>();
  var imageName = "".obs;
  var pdfName = "".obs;

  final roles = [
    {
      'label': 'مالك سوبرماركت',
      'value': 'supermarket',
      'icon': Icons.store_mall_directory,
      'color': Colors.green,
    },
  ];


  var selectedRole = RxnString('supermarket');

  void setRole(String role) => selectedRole.value = role;
  final nameController = TextEditingController();
  final nameArController = TextEditingController(); // حقل الاسم العربي الجديد
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final timeOpenController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    final data = box.read("user");
    if (data != null) {
      final user = UserModel.fromJson(data);
      currentUser.value = user;
      saveTokenToServer(user);
    }
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) openChat(message.data);
    });
    resetControllers();
  }
  void resetControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    locationController.clear();
    timeOpenController.clear();
    nameArController.clear();
    webImageBytes.value = null;
    webPdfBytes.value = null;
    imageName.value = "";
    pdfName.value = "";
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
    resetControllers();
  }

  Future<void> pickImageWeb() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      webImageBytes.value = await pickedFile.readAsBytes();
      imageName.value = pickedFile.name;
    }
  }

  // دالة اختيار ملف الرخصة للويب
  Future<void> pickPdfWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      webPdfBytes.value = result.files.single.bytes;
      pdfName.value = result.files.single.name;
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "خطأ",
        "يرجى إدخال البريد الإلكتروني وكلمة المرور",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    try {
      showLoadingDialog();
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final apiResponse = await ApiServices.getUserData(uid);
      Get.back();

      if (apiResponse['status'] == 'success') {
        final user = UserModel.fromJson(apiResponse['data']);


        if (user.role == 'supermarket' &&  user.status == 0) {

          await _auth.signOut();

          Get.snackbar(
            "تنبيه",
            "حسابك غير منشط حالياً. يرجى التواصل مع الإدارة لتنشيط الحساب.",
            backgroundColor: Colors.orangeAccent,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
          );
          return;
        }

        currentUser.value = user;
        box.write("user", apiResponse['data']);
        await saveTokenToServer(user);

        if (user.role == 'admin') {
          Get.offAllNamed(AppRoutes.dashboardAdmin);
          resetControllers();
        } else if (user.role == 'supermarket') {
          Get.offAllNamed(AppRoutes.dashboardMarket);
          resetControllers();
        }
      } else {
        throw Exception(apiResponse['message'] ?? "فشل جلب البيانات");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "خطأ",
        "البريد أو كلمة المرور غير صحيحة",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      print(e.code);
    } catch (e) {
      Get.back();
      Get.snackbar(
        "خطأ",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showLoadingDialog() {
    Get.dialog(
      Center(
        child: SizedBox(
          width: 280, // 👈 قمنا بتقييد العرض هنا لكي لا يكون طويلاً بزيادة
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة لوحة التحكم
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      Icons.analytics_outlined,
                      size: 32,
                      color: Colors.blueGrey[700],
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.settings_suggest,
                          size: 16,
                          color: Colors.green[600],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // مؤشر التحميل
                SpinKitWave(
                  color: Colors.green[600]!,
                  size: 25.0,
                  type: SpinKitWaveType.center,
                ),

                const SizedBox(height: 20),

                // نصوص تناسب الأدمين
                Text(
                  "جاري تحميل لوحة التحكم...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "يتم تهيئة البيانات وتأمين الاتصال",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontSize: 11,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> saveTokenToServer(UserModel user) async {
    if (!GetPlatform.isWeb) return;
    String? token = await FirebaseMessaging.instance.getToken(
      vapidKey:
          "BIMaxXuMXgoEhOrL8yRxs_XnNanF1TgnCQsHWNJEX4c19keSYCnaVR4fx9usP0fGnnzfIkHYdunp6Tm7Km1DMMw",
    );
    if (token == null) return;
    await http.post(
      Uri.parse(AppLink.saveToken),
      body: {"id": user.id.toString(), "role": user.role, "token": token},
    );
  }

  void openChat(Map<String, dynamic> data) {
    if (data["pagename"] == "chat") {
      if (currentUser.value?.role == "admin") {
        Get.toNamed(
          AppRoutes.adminChat,
          arguments: {"room_id": data["pageid"]},
        );
      } else {
        Get.toNamed(
          AppRoutes.marketChat,
          arguments: {"room_id": data["pageid"]},
        );
      }
    }
  }

  Future<void> register() async {
    if (selectedRole.value == null) {
      Get.snackbar(
        "خطأ",
        "يرجى اختيار نوع المستخدم",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedRole.value == "supermarket" && webPdfBytes.value == null) {
      Get.snackbar(
        "خطأ",
        "يرجى رفع ملف الرخصة أولاً",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    UserCredential? credential;
    try {
      isLoading.value = true;
      credential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = credential.user!.uid;

      var request = http.MultipartRequest("POST", Uri.parse(AppLink.signup));
      request.fields['firebase_uid'] = uid;
      request.fields['name'] = nameController.text.trim();
      request.fields['name_ar'] = nameArController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['phone'] = phoneController.text.trim();
      request.fields['role'] = selectedRole.value!;
      request.fields['location'] = locationController.text.trim();
      request.fields['time_open'] = timeOpenController.text.trim();
      request.fields['lat'] = "15.375622041597655";
      request.fields['long'] = "44.173400382850155";

      // إضافة ملف الرخصة (Bytes)
      if (webPdfBytes.value != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'license',
            webPdfBytes.value!,
            filename: pdfName.value,
          ),
        );
      }

      // إضافة ملف الصورة (Bytes)
      if (webImageBytes.value != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            webImageBytes.value!,
            filename: imageName.value,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var responseBody = jsonDecode(response.body);

      if (responseBody['status'] == 'success') {
        Get.snackbar(
          "تم",
          "تم إنشاء الحساب بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.login);
      } else {
        await credential.user?.delete();
        Get.snackbar(
          "خطأ",
          responseBody['message'],
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (credential != null) await credential.user?.delete();
      Get.snackbar(
        "خطأ فادح",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
