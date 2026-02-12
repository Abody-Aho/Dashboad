import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAccountForm extends StatelessWidget {
  final dynamic controller;

  const UserAccountForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [

        /// ---------------- USER TYPE ----------------
        _sectionTitle("user_type".tr),
        const SizedBox(height: 10),

        DropdownButtonFormField<String>(
          value: controller.selectedRole.value,
          hint: Text(
            "choose".tr,
            style: const TextStyle(color: Colors.green),
          ),
          decoration: _inputDecoration(),
          items: controller.roles.map<DropdownMenuItem<String>>((role) {
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
          onChanged: (value) => controller.setRole(value!),
          validator: (v) => v == null ? "role_required".tr : null,
        ),

        const SizedBox(height: 20),

        /// ---------------- NAME ----------------
        _sectionTitle("name".tr),
        const SizedBox(height: 10),

        TextFormField(
          controller: controller.nameController,
          decoration: _inputDecoration(
            hint: "name_hint".tr,
            icon: Icons.person,
          ),
          validator: (v) => v!.isEmpty ? "name_required".tr : null,
        ),

        const SizedBox(height: 20),

        /// ---------------- EMAIL OR PHONE ----------------
        if (controller.selectedRole.value == 'supermarket' ||
            controller.selectedRole.value == 'admin')
          ..._emailAndPhone()
        else
          ..._phoneOnly(),

        const SizedBox(height: 20),

        /// ---------------- PASSWORD ----------------
        _sectionTitle("password".tr),
        const SizedBox(height: 10),

        TextFormField(
          controller: controller.passwordController,
          obscureText: !controller.isPasswordVisible.value,
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
              onPressed: () => controller.isPasswordVisible.value =
              !controller.isPasswordVisible.value,
            ),
          ),
          validator: (v) =>
          v!.isEmpty ? "password_required".tr : null,
        ),

        const SizedBox(height: 20),

        /// ---------------- CONFIRM PASSWORD ----------------
        _sectionTitle("confirm_password".tr),
        const SizedBox(height: 10),

        TextFormField(
          controller: controller.confirmPasswordController,
          obscureText: !controller.isConfirmPasswordVisible.value,
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
                controller.isConfirmPasswordVisible.value =
                !controller.isConfirmPasswordVisible.value;
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

        const SizedBox(height: 30),
      ],
    ));
  }

  /// ================= HELPER WIDGETS =================

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  List<Widget> _emailAndPhone() {
    return [
      _sectionTitle("email".tr),
      const SizedBox(height: 10),
      TextFormField(
        controller: controller.emailController,
        decoration: _inputDecoration(
          hint: "email_hint".tr,
          icon: Icons.email,
        ),
        validator: (v) => v == null || v.isEmpty
            ? "email_required".tr
            : !GetUtils.isEmail(v)
            ? "email_invalid".tr
            : null,
      ),
      const SizedBox(height: 20),
      ..._phoneOnly(),
    ];
  }

  List<Widget> _phoneOnly() {
    return [
      _sectionTitle("phone_number".tr),
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
          if (v.length < 9) {
            return "must_be_9_number".tr;
          }
          if (!GetUtils.isPhoneNumber(v)) {
            return "phone_invalid".tr;
          }
          return null;
        },
      ),
    ];
  }

  InputDecoration _inputDecoration({
    String? hint,
    IconData? icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green),
      ),
    );
  }
}
