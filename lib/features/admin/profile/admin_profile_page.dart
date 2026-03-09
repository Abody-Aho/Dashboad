import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import 'admin_profile_controller.dart';

class AdminProfilePage extends StatelessWidget {

  final AdminProfileController controller =
  Get.put(AdminProfileController());



  AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Constants.backgroundColor1,
      body: Center(
        child: Container(
          width: width > 1200 ? 1000 : width,
          padding: const EdgeInsets.all(20),

          child: width < 700
              ? SingleChildScrollView(
            child: Column(
              children: [
                profileImage(context),
                const SizedBox(height: 25),
                profileInfo(),
              ],
            ),
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: profileImage(context)),
              const SizedBox(width: 25),
              Expanded(flex: 2, child: profileInfo()),
            ],
          ),
        ),
      ),
    );
  }

  // صورة البروفايل
  Widget profileImage(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Constants.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          decoration: const BoxDecoration(
            gradient: Constants.greenGradientlight,
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),

          child: SingleChildScrollView(
            child: SizedBox(
              height: width < 700 ? 210 : 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Stack(
                    alignment: Alignment.center,
                    children: [

                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Constants.primary,
                            width: 3,
                          ),
                        ),
                        child: Obx(() => CircleAvatar(
                          radius: 60,
                          backgroundImage:
                          AssetImage(controller.imageUrl.value),
                        )),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: controller.changeImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Constants.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    controller.nameController.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Constants.text,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Administrator",
                    style: TextStyle(
                      fontSize: 14,
                      color: Constants.greyDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// معلومات البروفايل
  Widget profileInfo() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Constants.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 28),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Profile Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Constants.text,
                      ),
                    ),

                    Obx(() => ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
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

                      icon: Icon(
                        controller.isEdit.value
                            ? Icons.save
                            : Icons.edit,
                        size: 18, color: Constants.white,
                      ),

                      label: Text(
                        controller.isEdit.value ? "Save" : "Edit",style: TextStyle(color: Constants.white),
                      ),
                    ))
                  ],
                ),

                const SizedBox(height: 28),

                buildField(
                  "Full Name",
                  controller.nameController,
                  Icons.person,
                ),

                const SizedBox(height: 18),

                buildField(
                  "Phone",
                  controller.phoneController,
                  Icons.phone,
                ),

                const SizedBox(height: 18),

                buildField(
                  "Email",
                  controller.emailController,
                  Icons.email,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(
      String label,
      TextEditingController controllerField,
      IconData icon,
      ) {

    return Obx(() => TextField(
      controller: controllerField,
      readOnly: !controller.isEdit.value,

      style: const TextStyle(
        fontSize: 15,
        color: Constants.text,
      ),

      decoration: InputDecoration(

        labelText: label,

        prefixIcon: Icon(
          icon,
          color: Constants.primary,
        ),

        filled: true,
        fillColor: Constants.backgroundLight,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Constants.greyLight,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Constants.greyLight,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Constants.primary,
            width: 1.5,
          ),
        ),
      ),
    ));
  }
}