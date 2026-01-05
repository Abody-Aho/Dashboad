import 'package:dashbord2/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.green[50],
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            children: [
              SizedBox(height: 30.h),

              /// أيقونة التسجيل
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
                            // عنوان إنشاء الحساب
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
                                    color: Colors.green[900]?.withValues(
                                      alpha: 0.7,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.person_add,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "create_account_desc".tr,
                              style: TextStyle(
                                color: Colors.green[700],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // نوع المستخدم
                            Align(
                              alignment: Alignment.topRight,
                              child: Text("user_type".tr, style: _titleStyle()),
                            ),
                            const SizedBox(height: 10),

                            Obx(
                              () => DropdownButtonFormField<String>(
                                initialValue: controller.selectedRole.value,
                                hint: Text(
                                  "choose".tr,
                                  style: const TextStyle(color: Colors.green),
                                ),
                                decoration: _inputDecoration(),
                                items: controller.roles.map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role['value'] as String,
                                    child: Row(
                                      children: [
                                        Icon(
                                          role['icon'] as IconData,
                                          color: role['color'] as Color,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(role['label'] as String),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    controller.setRole(value!),
                                validator: (v) =>
                                    v == null ? "role_required".tr : null,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // الاسم
                            Align(
                              alignment: Alignment.topRight,
                              child: Text("name".tr, style: _titleStyle()),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.nameController,
                              decoration: _inputDecoration(
                                hint: "name_hint".tr,
                                icon: Icons.person,
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? "name_required".tr : null,
                            ),

                            const SizedBox(height: 20),

                            // الإيميل
                            Align(
                              alignment: Alignment.topRight,
                              child: Text("email".tr, style: _titleStyle()),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.emailController,
                              decoration: _inputDecoration(
                                hint: "email_hint".tr,
                                icon: Icons.email,
                              ),
                              validator: (v) => v!.isEmpty
                                  ? "email_required".tr
                                  : !GetUtils.isEmail(v)
                                  ? "email_invalid".tr
                                  : null,
                            ),

                            const SizedBox(height: 20),

                            // الرقم
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "phone_number".tr,
                                style: _titleStyle(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.phoneController,
                              decoration: _inputDecoration(
                                hint: "phone_hint".tr,
                                icon: Icons.phone,
                              ),
                              keyboardType: TextInputType.phone,

                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "phone_required".tr;
                                }
                                if(v.length < 9){
                                  return "must_be_9_number".tr;
                                }
                                if (!GetUtils.isPhoneNumber(v)) {
                                  return "phone_invalid".tr;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // كلمة المرور
                            Align(
                              alignment: Alignment.topRight,
                              child: Text("password".tr, style: _titleStyle()),
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => TextFormField(
                                controller: controller.passwordController,
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                decoration: _inputDecoration(
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
                                        controller.isPasswordVisible.value =
                                            !controller.isPasswordVisible.value,
                                  ),
                                ),
                                validator: (v) =>
                                    v!.isEmpty ? "password_required".tr : null,
                              ),
                            ),

                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "confirm_password".tr,
                                style: _titleStyle(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => TextFormField(
                                controller:
                                    controller.confirmPasswordController,
                                obscureText:
                                    !controller.isConfirmPasswordVisible.value,
                                decoration: _inputDecoration(
                                  hint: "confirm_password_hint".tr,
                                  icon: Icons.lock_outline,
                                  suffix: IconButton(
                                    icon: Icon(
                                      controller.isConfirmPasswordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      controller
                                          .isConfirmPasswordVisible
                                          .value = !controller
                                          .isConfirmPasswordVisible
                                          .value;
                                    },
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "confirm_required".tr;
                                  }
                                  if (v != controller.passwordController.text) {
                                    return "password_not_match".tr;
                                  }
                                  return null;
                                },
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
                                  onPressed: () =>
                                      Get.offNamed(AppRoutes.login),
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
    );
  }

  TextStyle _titleStyle() => TextStyle(
    color: Colors.green[700],
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  InputDecoration _inputDecoration({
    String? hint,
    IconData? icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green, width: 2.5),
      ),
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
      suffixIcon: suffix,
    );
  }
}
