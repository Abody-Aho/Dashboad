import 'package:dashbord2/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers/login_helpers.dart';
import 'auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.green[50],
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 78,
                    decoration: BoxDecoration(
                      color: Colors.green[900]?.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.7),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.store,
                      size: 33,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "login_title".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "login_subtitle".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green[700], fontSize: 18),
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: Container(
                      width: screenWidth > 600 ? 500 : double.infinity,
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth > 600 ? 130 : 10,
                      ),
                      child: Card(
                        elevation: 6,
                        shadowColor: Colors.green.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "login".tr,
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.green[900]?.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.login,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "login_desc".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 30),


                                // الإيميل
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text("email".tr, style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: authController.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: inputDecoration(
                                      hint: "email_hint".tr, icon: Icons.email),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return "email_required".tr;
                                    if (!GetUtils.isEmail(value)) return "email_invalid".tr;
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 15),
                                // كلمة المرور
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text("password".tr, style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                      () => TextFormField(
                                    controller: authController.passwordController,
                                    obscureText: !authController.isPasswordVisible.value,
                                    decoration: inputDecoration(
                                      hint: "password_hint".tr,
                                      icon: Icons.lock,
                                      suffix: IconButton(
                                        icon: Icon(authController.isPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                            color: Colors.green),
                                        onPressed: () {
                                          authController.isPasswordVisible.value = !authController.isPasswordVisible.value;
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return "password_required".tr;
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // زر تسجيل الدخول
                                Obx(
                                      () => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[900],
                                      minimumSize: const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    onPressed: authController.isLoading.value ? null : () {
                                      if (_formKey.currentState!.validate()) {
                                        authController.login();
                                      }
                                    },
                                    child: authController.isLoading.value
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : Text("login".tr, style: const TextStyle(fontSize: 18, color: Colors.white)),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // زر الانتقال لإنشاء حساب
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("dont_have_account".tr, style: TextStyle(color: Colors.green[800]),),
                                    TextButton(
                                      onPressed: () => Get.toNamed(AppRoutes.signIn),
                                      child: Text(
                                        "create_account".tr,
                                        style: TextStyle(
                                          color: Colors.green[900],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // زر اللغة
                topIconButton(
                  icon: Icons.language,
                  onTap: () => changeLanguageDialog(context),
                ),
                // زر المساعدة
                topIconButton(
                  icon: Icons.help_outline_rounded,
                  onTap: () => showHelpDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
