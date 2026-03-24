import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import 'supermarket_profile_controller.dart';

class SupermarketProfilePage extends StatelessWidget {
  final SupermarketProfileController controller = Get.put(SupermarketProfileController());

  SupermarketProfilePage({super.key});

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
                ? Column(children: [profileImage(context), const SizedBox(height: 24), profileInfo(context)])
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: profileImage(context)),
                const SizedBox(width: 32),
                Expanded(flex: 7, child: profileInfo(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileImage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Constants.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
        border: Border.all(color: Colors.green.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.green.withOpacity(0.2), width: 4)),
                child: Obx(() => CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: controller.imageBytes.value != null
                      ? MemoryImage(controller.imageBytes.value!)
                      : (controller.imageUrl.value.isEmpty
                      ? const AssetImage("assets/images/mapp.png")
                      : NetworkImage(controller.imageUrl.value)) as ImageProvider,
                )),
              ),
              InkWell(
                onTap: controller.changeImage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() => Text(
            controller.authController.currentUser.value?.name ?? "Supermarket",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          )),
        ],
      ),
    );
  }

  Widget profileInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Constants.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge_outlined, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              const Text("بيانات السوبرماركت", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Spacer(),
              Obx(() => Row(
                children: [
                  if (controller.isEdit.value)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: OutlinedButton(
                        onPressed: controller.toggleEdit,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("إلغاء"),
                      ),
                    ),
                  _buildAnimatedButton(),
                ],
              )),
            ],
          ),
          const Divider(height: 48),
          buildField("English Name", controller.nameController, Icons.person_outline),
          const SizedBox(height: 24),
          buildField("Arabic Name", controller.nameArController, Icons.translate),
          const SizedBox(height: 24),
          buildField("Phone Number", controller.phoneController, Icons.phone_android_outlined),
          const SizedBox(height: 24),
          buildField("Location Address", controller.locationController, Icons.location_on_outlined),
          const SizedBox(height: 24),
          _buildMapCard(context),
          const SizedBox(height: 24),
          buildField("Opening Time", controller.timeOpenController, Icons.access_time),
        ],
      ),
    );
  }

  Widget _buildMapCard(BuildContext context) {
    return Obx(() {
      bool isEdit = controller.isEdit.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("الموقع على الخريطة (GPS)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF5F6368))),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => controller.openMapPicker(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isEdit ? Colors.white : const Color(0xFFF1F3F4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isEdit ? Colors.green : Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.map_rounded, color: isEdit ? Colors.green : Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isEdit ? "اضغط لتحديد الموقع من الخريطة" : "إحداثيات الموقع الحالي",
                            style: TextStyle(color: isEdit ? Colors.green.shade700 : Colors.black87, fontWeight: FontWeight.bold)),
                        Text("Lat: ${controller.latController.text} | Lng: ${controller.lngController.text}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  if (isEdit) const Icon(Icons.edit_location_alt, color: Colors.orange),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAnimatedButton() {
    bool isEdit = controller.isEdit.value;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isEdit ? Colors.green : Colors.green, // بقاء اللون أخضر أو تغييره حسب الرغبة
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => isEdit ? controller.saveProfile() : controller.toggleEdit(),
      icon: Icon(isEdit ? Icons.check : Icons.edit),
      label: Text(isEdit ? "حفظ التغييرات" : "تعديل البروفايل"),
    );
  }

  Widget buildField(String label, TextEditingController controllerField, IconData icon) {
    return Obx(() {
      bool isEdit = controller.isEdit.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF5F6368))),
          const SizedBox(height: 8),
          TextField(
            controller: controllerField,
            readOnly: !isEdit,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: isEdit ? Colors.green : Colors.grey),
              filled: true,
              fillColor: isEdit ? Colors.white : const Color(0xFFF1F3F4),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.green, width: 2)),
            ),
          ),
        ],
      );
    });
  }
}