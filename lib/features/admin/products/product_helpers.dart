import 'package:dashbord2/features/admin/products/products_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';

mixin ProductHelpers on GetxController {
  ProductsController get controller;

  Widget buildSuperDropdown() {
    return Obx(
      () => DropdownButtonFormField<int>(
        initialValue: controller.supers
            .any((e) => e.id == controller.selectedSuperId.value)
            ? controller.selectedSuperId.value
            : null,
        decoration: greenDecoration("اختر السوبرماركت"),
        items: controller.supers.map((s) {
          return DropdownMenuItem<int>(value: s.id, child: Text(s.nameAr));
        }).toList(),
        onChanged: (value) {
          controller.selectedSuperId.value = value;
          controller.selectedCategoryId.value = null;
          controller.categories.clear();
          if (value != null) {
            controller.fetchCategoriesBySuper(value);
          }
        },
        validator: (value) =>
            value == null ? "الرجاء اختيار السوبرماركت" : null,
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "هذا الحقل مطلوب";
        }
        return null;
      },
      decoration: greenDecoration(label),
    );
  }

  Widget buildCategoryImagePicker() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("صورة الفئة"),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                withData: true,
              );

              if (result != null) {
                controller.categoryImageBytes.value = result.files.first.bytes;
                controller.categoryImageName = result.files.first.name;
              }
            },
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Constants.greyLight),
              ),
              child: controller.categoryImageBytes.value != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        controller.categoryImageBytes.value!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    )
                  : controller.categoryOldImage.value.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "${AppLink.imageCategories}${controller.categoryOldImage.value}",
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    )
                  : const Center(child: Text("اضغط لاختيار صورة")),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Obx(
      () => DropdownButtonFormField<int>(
        initialValue: controller.categories
            .any((e) => e.id == controller.selectedCategoryId.value)
            ? controller.selectedCategoryId.value
            : null,
        decoration: greenDecoration("الفئة الخاصة"),
        items: controller.categories.map((c) {
          return DropdownMenuItem<int>(value: c.id, child: Text(c.nameAr));
        }).toList(),
        onChanged: (value) {
          controller.selectedCategoryId.value = value;
        },
        validator: (value) => value == null ? "اختر الفئة الخاصة" : null,
      ),
    );
  }

  Widget buildCategoryAllDropdown() {
    return Obx(
      () => DropdownButtonFormField<int>(
        initialValue: controller.categoriesAll
            .any((e) => e.id == controller.selectedCategoryAllId.value)
            ? controller.selectedCategoryAllId.value
            : null,
        decoration: greenDecoration("الفئة العامة"),
        items: controller.categoriesAll.map((c) {
          return DropdownMenuItem<int>(value: c.id, child: Text(c.nameAr));
        }).toList(),
        onChanged: (value) {
          controller.selectedCategoryAllId.value = value;
        },
        validator: (value) => value == null ? "اختر الفئة العامة" : null,
      ),
    );
  }

  Widget buildImagePicker() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "صورة المنتج",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Constants.text,
            ),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                withData: true,
              );

              if (result != null) {
                controller.imageBytes.value = result.files.first.bytes;
                controller.imageName = result.files.first.name;
              }
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Constants.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Constants.greyLight),
              ),
              child: controller.imageBytes.value != null
              /// إذا تم اختيار صورة جديدة
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  controller.imageBytes.value!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              )

              /// إذا توجد صورة قديمة للمنتج
                  : controller.itemsOldImage.value.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "${AppLink.imageItems}/${controller.itemsOldImage.value}",
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              )

              /// إذا لا توجد أي صورة
                  : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 40,
                      color: Constants.grey,
                    ),
                    SizedBox(height: 8),
                    Text("اضغط لاختيار صورة"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration greenDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Constants.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Constants.greyLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Constants.primary, width: 2),
      ),
    );
  }

  Widget buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Constants.greyLight),
        ),

        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 6,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          ],
        ),
      ),
    );
  }
}
