import 'package:dashbord2/features/admin/users/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_link.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

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

                                  child:
                                      controller.imageBytes == null &&
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

  void showUserDetailsDialog(UserModel user) {
    Get.dialog(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 10),
                        Text(
                          "تفاصيل المستخدم",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    _infoItem("الاسم", user.name),

                    if (user.role == "admin" || user.role == "supermarket")
                      _infoItem("البريد", user.email),

                    _infoItem("الهاتف", user.phone),

                    if (user.role == "supermarket") ...[
                      _infoItem("الاسم بالعربي", user.nameAr),
                      _infoItem("الموقع", user.location),
                      _infoItem("وقت العمل", user.timeOpen),

                      const SizedBox(height: 15),

                      if (user.license != null &&
                          user.license!.trim().isNotEmpty &&
                          user.license != "null") ...[
                        const Text(
                          "الرخصة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),

                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: const Text(
                            "تحميل",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            final url = Uri.encodeFull(
                              "${AppLink.pdf}${user.license}",
                            );

                            final uri = Uri.parse(url);

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              Get.snackbar(
                                "خطأ",
                                "لا يمكن تحميل الملف",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                        ),
                      ],
                    ],

                    if (user.role == "driver") ...[
                      _infoItem("رقم المركبة", user.vehicleNumber),

                      if (user.ratingAvg != 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              const Text(
                                "التقييم: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(user.ratingAvg!.toStringAsFixed(1)),
                            ],
                          ),
                        ),
                    ],

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                        ),
                        onPressed: () => Get.back(),
                        child: const Text(
                          "إغلاق",
                          style: TextStyle(color: Colors.white),
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
    );
  }

  Widget _infoItem(String title, String? value) {
    if (value == null || value.isEmpty || value == "null") {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
