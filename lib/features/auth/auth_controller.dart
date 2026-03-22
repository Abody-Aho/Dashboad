import 'package:dashbord2/data/models/user_model.dart';
import 'package:dashbord2/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_link.dart';
import '../../core/services/api_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController extends GetxController {

  final _auth = FirebaseAuth.instance;
  var currentUser = Rxn<UserModel>();
  final box = GetStorage();

  final roles = [
    {'label': 'مدير النظام', 'value': 'admin', 'icon': Icons.admin_panel_settings, 'color': Colors.red},
    {'label': 'مالك سوبرماركت', 'value': 'supermarket', 'icon': Icons.store_mall_directory, 'color': Colors.green},
  ];

  var selectedRole = RxnString();
  void setRole(String role) => selectedRole.value = role;

  final nameController = TextEditingController();
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
      if (message != null) {
        openChat(message.data);
      }
    });
  }

  Future<void> login() async {

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال البريد الإلكتروني وكلمة المرور",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {

      isLoading.value = true;

      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final uid = credential.user!.uid;

      final apiResponse = await ApiServices.getUserData(uid);

      if (apiResponse['status'] == 'success') {

        final user = UserModel.fromJson(apiResponse['data']);

        currentUser.value = user;
        box.write("user", apiResponse['data']);

        await saveTokenToServer(user); // 🔥 جديد

        if (user.role == 'admin') {
          Get.offAllNamed(AppRoutes.dashboardAdmin);
        } else if (user.role == 'supermarket') {
          Get.offAllNamed(AppRoutes.dashboardMarket);
        }

      } else {
        throw Exception(apiResponse['message'] ?? "فشل جلب البيانات");
      }

    } on FirebaseAuthException catch (e) {

      String message = "فشل تسجيل الدخول.";

      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
      }

      Get.snackbar("خطأ", message,
          backgroundColor: Colors.redAccent, colorText: Colors.white);

    } catch (e) {

      Get.snackbar("خطأ", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveTokenToServer(UserModel user) async {

    if (!GetPlatform.isWeb) return;

    String? token = await FirebaseMessaging.instance.getToken(
      vapidKey: "BIMaxXuMXgoEhOrL8yRxs_XnNanF1TgnCQsHWNJEX4c19keSYCnaVR4fx9usP0fGnnzfIkHYdunp6Tm7Km1DMMw",
    );

    if (token == null) return;

    await http.post(
      Uri.parse(AppLink.saveToken),
      body: {
        "id": user.id.toString(),
        "role": user.role,
        "token": token,
      },
    );
  }

  void openChat(Map<String, dynamic> data) {

    if (data["pagename"] == "chat") {

      if (currentUser.value?.role == "admin") {

        Get.toNamed(AppRoutes.adminChat, arguments: {
          "room_id": data["pageid"]
        });

      } else {

        Get.toNamed(AppRoutes.marketChat, arguments: {
          "room_id": data["pageid"]
        });
      }
    }
  }

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

      Get.snackbar("خطأ فادح", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);

    } finally {
      isLoading.value = false;
    }
  }
}