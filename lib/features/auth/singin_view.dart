import 'package:dashbord2/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers/login_helpers.dart';
import '../../core/utils/helpers/singin_helpers.dart' hide inputDecoration;
import 'auth_controller.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final AuthController controller = Get.find<AuthController>();
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
                  SizedBox(height: 30.h),
                  Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 78,
                    decoration: BoxDecoration(
                      color: Colors.green[900]?.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.userPlus,
                      size: 33,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "signup_title".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "signup_subtitle".tr,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "create_account".tr,
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
                                        Icons.person_add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // اسم السوبرماركت (English)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "الاسم (English)",
                                    style: titleStyle(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: controller.nameController,
                                  decoration: inputDecoration(
                                    hint: "Ex: Al-Amal Market",
                                    icon: Icons.store,
                                  ),
                                  validator: (v) => v!.isEmpty ? "Required" : null,
                                ),
                                const SizedBox(height: 20),

                                // اسم السوبرماركت (عربي)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "اسم السوبرماركت (عربي)",
                                    style: titleStyle(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: controller.nameArController,
                                  textAlign: TextAlign.right,
                                  decoration: inputDecoration(
                                    hint: "مثال: سوبرماركت الأمل",
                                    icon: Icons.storefront,
                                  ),
                                  validator: (v) => v!.isEmpty ? "مطلوب" : null,
                                ),
                                const SizedBox(height: 20),

                                // البريد والإيميل
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text("email".tr, style: titleStyle()),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: controller.emailController,
                                  decoration: inputDecoration(
                                    hint: "email_hint".tr,
                                    icon: Icons.email,
                                  ),
                                  validator: (v) => GetUtils.isEmail(v!)
                                      ? null
                                      : "email_invalid".tr,
                                ),
                                const SizedBox(height: 20),

                                // رفع الرخصة (خاص بالسوبرماركت)
                                Obx(
                                  () => Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          "رخصة المحل (PDF)",
                                          style: titleStyle(),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ListTile(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.green),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        leading: const Icon(
                                          Icons.upload_file,
                                          color: Colors.red,
                                        ),
                                        title: Text(
                                          controller.pdfName.value == ""
                                              ? "اضغط لرفع الرخصة"
                                              : controller.pdfName.value,
                                        ),
                                        onTap: () => controller.pickPdfWeb(),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),

                                // رقم الهاتف
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "phone_number".tr,
                                    style: titleStyle(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: controller.phoneController,
                                  decoration: inputDecoration(
                                    hint: "777xxxxxx",
                                    icon: Icons.phone,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (v) =>
                                      v!.length < 9 ? "must_be_9_number".tr : null,
                                ),
                                const SizedBox(height: 20),

                                // كلمة المرور
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text("password".tr, style: titleStyle()),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => TextFormField(
                                    controller: controller.passwordController,
                                    obscureText:
                                        !controller.isPasswordVisible.value,
                                    decoration: inputDecoration(
                                      hint: "password_hint".tr,
                                      icon: Icons.lock,
                                      suffix: IconButton(
                                        icon: Icon(
                                          controller.isPasswordVisible.value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.green,
                                        ),
                                        onPressed: () =>
                                            controller.isPasswordVisible.toggle(),
                                      ),
                                    ),
                                    validator: (v){
                                      if (v == null || v.isEmpty) {
                                        return "password_required".tr;
                                      }
                                      if (v.length < 8) {
                                        return "password_min_length".tr;
                                      }

                                      if (!RegExp(r'[A-Z]').hasMatch(v)) {
                                        return "password_uppercase".tr;
                                      }

                                      if (!RegExp(r'[a-z]').hasMatch(v)) {
                                        return "password_lowercase".tr;
                                      }

                                      if (!RegExp(r'[0-9]').hasMatch(v)) {
                                        return "password_number".tr;
                                      }
                                      return null;

                                    }

                                  ),
                                ),
                                const SizedBox(height: 20),

                                // تأكيد كلمة المرور
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "confirm_password".tr,
                                    style: titleStyle(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => TextFormField(
                                    controller:
                                        controller.confirmPasswordController,
                                    obscureText:
                                        !controller.isConfirmPasswordVisible.value,
                                    decoration: inputDecoration(
                                      hint: "confirm_password_hint".tr,
                                      icon: Icons.lock_outline,
                                      suffix: IconButton(
                                        icon: Icon(
                                          controller.isConfirmPasswordVisible.value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.green,
                                        ),
                                        onPressed: () => controller
                                            .isConfirmPasswordVisible
                                            .toggle(),
                                      ),
                                    ),
                                    validator: (v) =>
                                        v != controller.passwordController.text
                                        ? "password_not_match".tr
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // زر التسجيل
                                Obx(
                                  () => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[900],
                                      minimumSize: const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () {
                                            if (_formKey.currentState!.validate()) {
                                              controller.register();
                                            }
                                          },
                                    child: controller.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            "create_account".tr,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "have_account".tr,
                                      style: TextStyle(color: Colors.green[800]),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                          Get.offNamed(AppRoutes.login);
                                          controller.resetControllers();
                                      },
                                      child: Text(
                                        "login".tr,
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
