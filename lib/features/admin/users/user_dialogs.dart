import 'package:dashbord2/features/admin/users/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_link.dart';
import '../../../data/models/user_model.dart';

mixin UserDialogs on GetxController {
  UserController get controller;

  void showEditDialog(UserModel user) {
    controller.fillControllers(user);

    // ====== تصميم الحقول الأخضر ======
    InputDecoration greenInput(String label) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.green.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      );
    }

    Get.dialog(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Material(
            color: Colors.white,
            elevation: 12,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF1F8F4), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// ====== العنوان ======
                      Row(
                        children: const [
                          Icon(Icons.edit, color: Color(0xFF2E7D32)),
                          SizedBox(width: 10),
                          Text(
                            "تعديل المستخدم",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// ====== الصورة ======
                      GetBuilder<UserController>(
                        builder: (controller) {
                          return GestureDetector(
                            onTap: () async {
                              await controller.pickImage();
                            },
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF4CAF50),
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey.shade100,
                                  backgroundImage: controller.imageBytes != null
                                      ? MemoryImage(controller.imageBytes!)
                                      : (user.image != null &&
                                      user.image!.isNotEmpty &&
                                      user.image != "empty")
                                      ? NetworkImage(
                                    "${AppLink.image}${user.image}",
                                  )
                                      : AssetImage("assets/images/mapp.png"),

                                  child: controller.imageBytes == null &&
                                      (user.image == null ||
                                          user.image!.isEmpty ||
                                          user.image == "empty")
                                      ? const Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                    color: Color(0xFF4CAF50),
                                  )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),


                      const SizedBox(height: 30),

                      /// ====== حقول السوبرماركت ======
                      if (user.role == "supermarket") ...[
                        TextField(
                          controller: controller.nameArController,
                          decoration: greenInput("الاسم بالعربي"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: controller.locationController,
                          decoration: greenInput("الموقع"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: controller.timeOpenController,
                          decoration: greenInput("وقت العمل"),
                        ),
                        const SizedBox(height: 25),
                      ],

                      /// ====== الحقول الأساسية ======
                      TextField(
                        controller: controller.nameController,
                        decoration: greenInput("الاسم"),
                      ),
                      const SizedBox(height: 15),

                      if (user.role == "admin" ||
                          user.role == "supermarket") ...[
                        TextField(
                          controller: controller.emailController,
                          decoration: greenInput("البريد"),
                        ),
                        const SizedBox(height: 15),
                      ],

                      TextField(
                        controller: controller.phoneController,
                        decoration: greenInput("الهاتف"),
                      ),

                      const SizedBox(height: 15),

                      /// ====== حقل المندوب ======
                      if (user.role == "driver") ...[
                        TextField(
                          controller: controller.vehicleController,
                          decoration: greenInput("رقم المركبة"),
                        ),
                        const SizedBox(height: 25),
                      ],

                      /// ====== زر الحفظ ======
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          backgroundColor: const Color(0xFF2E7D32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                        ),
                        onPressed: () => controller.updateUser(user),
                        child: const Text(
                          "حفظ التعديلات",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

}