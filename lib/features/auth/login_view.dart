import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   AuthController dropdownController = Get.find();
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
                                    color: Colors.green[900]?.withValues(
                                      alpha: 0.7,
                                    ),
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

                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "user_type".tr,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => DropdownButtonFormField<String>(
                                hint: Text(
                                  "choose".tr,
                                  style: TextStyle(color: Colors.green),
                                ),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.green[700],
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                initialValue:
                                    dropdownController.selectedRole.value,
                                items: dropdownController.roles.map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role['label'] as String,
                                    child: Row(
                                      children: [
                                        Icon(
                                          role['icon'] as IconData,
                                          color: role['color'] as Color,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          role['label'] as String,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  dropdownController.setRole(newValue!);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),

                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "email".tr,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: dropdownController.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 2.5,
                                  ),
                                ),
                                hintText: "email_hint".tr,
                                hintStyle: TextStyle(color: Colors.green[700]),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "email_required".tr;
                                } else if (!GetUtils.isEmail(value)) {
                                  return "email_invalid".tr;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "password".tr,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => TextFormField(
                                controller:
                                    dropdownController.passwordController,
                                obscureText:
                                    !dropdownController.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                      width: 2.5,
                                    ),
                                  ),
                                  hintText: "password_hint".tr,
                                  hintStyle: TextStyle(
                                    color: Colors.green[700],
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.green,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      dropdownController.isPasswordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      dropdownController
                                          .isPasswordVisible
                                          .value = !dropdownController
                                          .isPasswordVisible
                                          .value;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "password_required".tr;
                                  } else if (value.length < 6) {
                                    return "password_short".tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 30),

                            Obx(
                              () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[900],
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: dropdownController.isLoading.value
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          dropdownController.login();
                                          Get.toNamed("admin");
                                        }
                                      },
                                child: dropdownController.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        "login".tr,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
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
    );
  }
}
