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
    double contentWidth = width > 1200 ? 1100 : width;

    return Scaffold(
      backgroundColor: Constants.backgroundColor1,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: SizedBox(
            width: contentWidth,
            child: width < 850
                ? Column(
                    children: [
                      profileImage(context),
                      const SizedBox(height: 24),
                      profileInfo(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: profileImage(context)),
                      const SizedBox(width: 32),
                      Expanded(flex: 7, child: profileInfo()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ===================== PROFILE IMAGE CARD =====================
  Widget profileImage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Constants.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.green.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green.withOpacity(0.2),
                    width: 4,
                  ),
                ),
                child: Obx(() {
                  return CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: controller.imageBytes.value != null
                        ? MemoryImage(controller.imageBytes.value!)
                        : (controller.imageUrl.value.isEmpty
                                  ? const AssetImage("assets/images/mapp.png")
                                  : NetworkImage(controller.imageUrl.value))
                              as ImageProvider,
                  );
                }),
              ),
              InkWell(
                onTap: controller.changeImage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Constants.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(
            () => Text(
              controller.authController.currentUser.value?.name ??
                  "admin_name".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D312E),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "system_admin".tr,
              style: TextStyle(
                color: Constants.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== PROFILE INFO CARD =====================
  Widget profileInfo() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Constants.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge_outlined, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Text(
                "personal_details".tr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D312E),
                ),
              ),
              const Spacer(),
              Obx(() => _buildAnimatedButton()),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "profile_manage_desc".tr,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Divider(height: 1),
          ),
          _buildResponsiveFields(),
        ],
      ),
    );
  }

  Widget _buildResponsiveFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            buildField(
              "full_name".tr,
              controller.nameController,
              Icons.person_outline,
            ),
            const SizedBox(height: 24),
            buildField(
              "phone_number_label".tr,
              controller.phoneController,
              Icons.phone_android_outlined,
            ),
            const SizedBox(height: 24),
            buildField(
              "email_address".tr,
              controller.emailController,
              Icons.alternate_email_rounded,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedButton() {
    bool isEdit = controller.isEdit.value;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isEdit ? Colors.orange.shade700 : Constants.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: () =>
          isEdit ? controller.saveProfile() : controller.toggleEdit(),
      icon: Icon(isEdit ? Icons.check_circle_outline : Icons.edit_note_rounded),
      label: Text(
        isEdit ? "save_changes".tr : "edit_profile".tr,
        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  // ===================== CUSTOM INPUT FIELD =====================
  Widget buildField(
    String label,
    TextEditingController controllerField,
    IconData icon,
  ) {
    return Obx(() {
      bool isEdit = controller.isEdit.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5F6368),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controllerField,
            readOnly: !isEdit,
            style: const TextStyle(fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: isEdit ? Constants.primary : Colors.grey,
              ),
              filled: true,
              fillColor: isEdit ? Colors.white : const Color(0xFFF1F3F4),
              hintText: "enter_your_hint".trParams({'label': label}),
              contentPadding: const EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Constants.primary, width: 2),
              ),
            ),
          ),
        ],
      );
    });
  }
}
