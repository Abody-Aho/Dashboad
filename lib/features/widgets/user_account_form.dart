import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAccountForm extends StatelessWidget {
  final dynamic controller;

  const UserAccountForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final role = controller.selectedRole.value;
      return Column(
        children: [
          // ---------------- نوع المستخدم ----------------
          _sectionTitle("user_type".tr),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: role,
            hint: Text(
                "choose".tr, style: const TextStyle(color: Colors.green)),
            decoration: _inputDecoration(),
            items: controller.roles.map<DropdownMenuItem<String>>((roleItem) {
              return DropdownMenuItem<String>(
                value: roleItem['value'] as String,
                child: Row(
                  children: [
                    Icon(roleItem['icon'] as IconData,
                        color: roleItem['color'] as Color),
                    const SizedBox(width: 10),
                    Text(roleItem['label'] as String),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => controller.setRole(value!),
            validator: (v) => v == null ? "role_required".tr : null,
          ),

          const SizedBox(height: 20),

          // ---------------- الاسم (عام) ----------------
          _buildTextField(
            label: "name".tr,
            hint: "name_hint".tr,
            controller: controller.nameController,
            icon: Icons.person,
          ),

          // ---------------- الاسم العربي (سوبرماركت فقط) ----------------
          if (role == 'supermarket') ...[
            const SizedBox(height: 20),
            _buildTextField(
              label: "الاسم بالعربي",
              hint: "أدخل الاسم باللغة العربية",
              controller: controller.nameArController,
              icon: Icons.translate,
              validator: (v) =>
              v!.isEmpty
                  ? "الاسم العربي مطلوب للسوبرماركت"
                  : null,
            ),
          ],

          const SizedBox(height: 20),

          // ---------------- البريد الإلكتروني (أدمن وسوبرماركت فقط) ----------------
          if (role == 'admin' || role == 'supermarket') ...[
            _buildTextField(
              label: "email".tr,
              hint: "email_hint".tr,
              controller: controller.emailController,
              icon: Icons.email,
              validator: (v) =>
              v == null || v.isEmpty
                  ? "email_required".tr
                  : (!GetUtils.isEmail(v) ? "email_invalid".tr : null),
            ),
            const SizedBox(height: 20),
          ],

          // ---------------- رقم الهاتف (للجميع) ----------------
          _buildTextField(
            label: "phone_number".tr,
            hint: "phone_hint".tr,
            controller: controller.phoneController,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (v) =>
            (v == null || v.isEmpty)
                ? "phone_required".tr
                : (v.length < 9 ? "must_be_9_number".tr : null),
          ),

          const SizedBox(height: 20),

          // ---------------- كلمة المرور (للجميع) ----------------
          _buildPasswordField(
            label: "password".tr,
            hint: "password_hint".tr,
            passController: controller.passwordController,
            visibleObs: controller.isPasswordVisible,
          ),

          const SizedBox(height: 20),

          // ---------------- تأكيد كلمة المرور (للجميع) ----------------
          _buildPasswordField(
            label: "confirm_password".tr,
            hint: "confirm_password_hint".tr,
            passController: controller.confirmPasswordController,
            visibleObs: controller.isConfirmPasswordVisible,
            isConfirm: true,
          ),

          const SizedBox(height: 30),
        ],
      );
    });
  }

  // --- دوال مساعدة للاختصار (Helper Methods) ---

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        _sectionTitle(label),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: _inputDecoration(hint: hint, icon: icon),
          validator: validator ??
                  (v) => v!.isEmpty ? "field_required".tr : null,
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController passController,
    required RxBool visibleObs,
    bool isConfirm = false,
  }) {
    return Column(
      children: [
        _sectionTitle(label),
        const SizedBox(height: 10),
        TextFormField(
          controller: passController,
          obscureText: !visibleObs.value,
          decoration: _inputDecoration(
            hint: hint,
            icon: isConfirm ? Icons.lock_outline : Icons.lock,
            suffix: IconButton(
              icon: Icon(
                  visibleObs.value ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green),
              onPressed: () => visibleObs.toggle(),
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return "password_required".tr;
            if (isConfirm && v != controller.passwordController.text)
              return "password_not_match".tr;
            return null;
          },
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  InputDecoration _inputDecoration(
      {String? hint, IconData? icon, Widget? suffix}) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.green, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.green, width: 2.5)),
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
      suffixIcon: suffix,
    );
  }
}