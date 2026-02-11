import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/features/admin/users/user_controller.dart';
import 'package:dashbord2/features/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/custom_bottom.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/custom_search_bar.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = Get.find<UserController>();

    // بطاقات الإحصائيات / Statistics Cards
    List<Widget> statCards = [
      StatCard(
        title: 'total_users'.tr, // مترجم
        value: '1,245',
        percent: '8%',
        subtitle: 'compared_last_month'.tr,
      ),
      StatCard(
        title: 'active_users'.tr,
        value: '984',
        percent: '5%',
        subtitle: 'compared_last_month'.tr,
      ),
      StatCard(
        title: 'new_signups'.tr,
        value: '124',
        percent: '12%',
        subtitle: 'compared_last_month'.tr,
      ),
      StatCard(
        title: 'banned_users'.tr,
        value: '15',
        percent: '-3%',
        subtitle: 'compared_last_month'.tr,
        percentColor: Colors.red,
        percentIcon: Icons.arrow_downward,
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // العنوان / Page Title
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'user_management'.tr,
                  style: TextStyle(
                    color: Constants.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // بطاقات الإحصائيات / Statistics Cards Layout
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth > 500) {
                    crossAxisCount = 2;
                  }

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2.0,
                    children: statCards,
                  );
                },
              ),
              const SizedBox(height: 20),

              // جدول المستخدمين مع الخلفية المستديرة / Users Table with Rounded Background
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),

                      // الصف العلوي (زر + قائمة + بحث) / Top Row (Button + Dropdown + Search)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isPhone = constraints.maxWidth < 600;

                          if (isPhone) {
                            // عمودي / Vertical layout
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomSearchBar(
                                  controller: controller,
                                  hintText: 'search'.tr,
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedValue,
                                    options: controller.options,
                                    onChanged: (value) {
                                      controller.filterByType(value);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 11),
                                  child: CustomBottom(
                                    controller: controller,
                                    addButtonText: 'add_users'.tr,
                                    onAddPressed: () {
                                      print("Add user pressed");
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          } else {
                            // أفقي / Horizontal layout
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomBottom(
                                  controller: controller,
                                  addButtonText: 'add_users'.tr,
                                  onAddPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:  Text(
                                            "create_account".tr,
                                            style: TextStyle(
                                              color: Colors.green[700],
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: SizedBox(
                                            width: 600,
                                            height: 600,
                                            child: SingleChildScrollView(
                                              child: Form(
                                                key: formKey,
                                                child: Obx(
                                                  () => Column(
                                                    children: [
                                                      // نوع المستخدم
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: Text("user_type".tr, style: _titleStyle()),
                                                      ),
                                                      const SizedBox(height: 10),

                                                      DropdownButtonFormField<String>(
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
                                                        onChanged: (value) => controller.setRole(value!),
                                                        validator: (v) => v == null ? "role_required".tr : null,
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
                                                        validator: (v) => v!.isEmpty ? "name_required".tr : null,
                                                      ),

                                                      const SizedBox(height: 20),

                                                      // الشرط الخاص بالإيميل أو الهاتف
                                                      if (controller.selectedRole.value == 'supermarket' || controller.selectedRole.value == 'admin') ...[
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
                                                          validator: (v) => v == null || v.isEmpty
                                                              ? "email_required".tr
                                                              : !GetUtils.isEmail(v)
                                                                  ? "email_invalid".tr
                                                                  : null,
                                                        ),
                                                        const SizedBox(height: 20),
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
                                                            if (v.length < 9) {
                                                              return "must_be_9_number".tr;
                                                            }
                                                            if (!GetUtils.isPhoneNumber(v)) {
                                                              return "phone_invalid".tr;
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ] else ...[
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
                                                            if (v.length < 9) {
                                                              return "must_be_9_number".tr;
                                                            }
                                                            if (!GetUtils.isPhoneNumber(v)) {
                                                              return "phone_invalid".tr;
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ],

                                                      const SizedBox(height: 20),

                                                      // كلمة المرور
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: Text("password".tr, style: _titleStyle()),
                                                      ),
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
                                                            onPressed: () => controller.isPasswordVisible.value = !controller.isPasswordVisible.value,
                                                          ),
                                                        ),
                                                        validator: (v) => v!.isEmpty ? "password_required".tr : null,
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
                                                              controller.isConfirmPasswordVisible.value = !controller.isConfirmPasswordVisible.value;
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
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red[900],
                                                minimumSize: const Size(50, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                              onPressed: () => Navigator.pop(context),
                                              child: Text(
                                                "cancel".tr,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Obx(
                                                  () => ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green[900],
                                                  minimumSize: const Size(50, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                ),
                                                onPressed: controller.isLoading.value
                                                    ? null
                                                    : () {
                                                  if (formKey.currentState!.validate()) {
                                                    Navigator.pop(context);
                                                    controller.addAccount();
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
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedValue,
                                    options: controller.options,
                                    onChanged: (value) {
                                      controller.filterByType(value);
                                    },
                                  ),
                                ),

                                Expanded(
                                  child: CustomSearchBar(
                                    controller: controller,
                                    hintText: 'search'.tr,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 15),

                      // جدول المستخدمين / Users Table
                      SizedBox(
                        height: 500,
                        child: CustomDataTable(controller: controller),
                      ),
                    ],
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
