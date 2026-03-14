import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import 'admin_profile_controller.dart';

class AdminProfilePage extends StatelessWidget {
  final AdminProfileController controller = Get.put(AdminProfileController());

  AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.backgroundColor1,
      body: Center(
        child: Container(
          width: width > 1200 ? 1000 : width,
          padding: const EdgeInsets.all(24),
          child: width < 700
              ? SingleChildScrollView(
            child: Column(
              children: [
                profileImage(context),
                const SizedBox(height: 30),
                profileInfo(),
              ],
            ),
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: profileImage(context)),
              const SizedBox(width: 30),
              Expanded(flex: 2, child: profileInfo()),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== PROFILE IMAGE =====================

  Widget profileImage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: Constants.greenGradientlight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Obx(() {
                return CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: controller.imageBytes.value != null
                      ? MemoryImage(controller.imageBytes.value!)
                      : (controller.imageUrl.value.isEmpty
                      ? const AssetImage("assets/images/mapp.png")
                      : NetworkImage(controller.imageUrl.value))
                  as ImageProvider,
                );
              }),

              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: controller.changeImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Constants.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Obx(() => Text(
            controller.authController.currentUser.value?.name ?? "Admin",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          )),

          const SizedBox(height: 6),

          Text(
            "Administrator",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ===================== PROFILE INFO =====================

  Widget profileInfo() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: Constants.greenGradientlight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                "Profile Information",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Constants.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (controller.isEdit.value) {
                    controller.saveProfile();
                  } else {
                    controller.toggleEdit();
                  }
                },
                child: Text(
                  controller.isEdit.value
                      ? "Save Changes"
                      : "Edit Profile",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ))
            ],
          ),

          const SizedBox(height: 30),

          buildField(
            "Full Name",
            controller.nameController,
            Icons.person_outline,
          ),

          const SizedBox(height: 20),

          buildField(
            "Phone",
            controller.phoneController,
            Icons.phone_outlined,
          ),

          const SizedBox(height: 20),

          buildField(
            "Email",
            controller.emailController,
            Icons.email_outlined,
          ),
        ],
      ),
    );
  }

  // ===================== INPUT FIELD =====================

  Widget buildField(
      String label,
      TextEditingController controllerField,
      IconData icon,
      ) {
    return Obx(() => TextField(
      controller: controllerField,
      readOnly: !controller.isEdit.value,
      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(
          icon,
          color: Constants.primary,
        ),

        filled: true,
        fillColor: Colors.grey.shade100,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Constants.primary,
            width: 1.5,
          ),
        ),
      ),
    ));
  }
}