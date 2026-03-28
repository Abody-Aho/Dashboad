import 'package:dashbord2/features/supermarket/products/products_supermarket_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';
import '../../../data/models/product_model.dart';

mixin ProductSupermarketDialogs on GetxController {
  ProductsSupermarketController get controller;

  void showCategoryDialog({
    bool isEdit = false,
    int? id,
    String? nameAr,
    String? nameEn,
    String? type, // general | private
    int? superId,
  }) async {
    await controller.fetchSupers();
    await controller.fetchCategoriesAll();
    if (type == "private" && superId != null) {
      await controller.fetchCategoriesBySuper(superId);
    }
    controller.isEditCategory.value = isEdit;
    controller.editingCategoryId.value = id;

    if (isEdit) {
      controller.catNameArController.text = nameAr ?? "";
      controller.catNameEnController.text = nameEn ?? "";
      controller.categoryType.value = type ?? "general";
      controller.selectedSuperId.value = superId;
    } else {
      controller.resetCategoryForm();
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width < 600 ? Get.width * 0.95 : 550,
          constraints: BoxConstraints(maxHeight: Get.height * 0.9),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Constants.backgroundLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: controller.categoryFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: Constants.greenGradientlight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        isEdit ? "edit_category".tr : "add_new_category".tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Constants.text,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // نوع الفئة
                  Obx(
                    () => RadioGroup<String>(
                      groupValue: controller.categoryType.value,
                      onChanged: (value) async {
                        controller.categoryType.value = value!;

                        controller.editingCategoryId.value = null;
                        controller.selectedSuperId.value = null;
                        controller.categories.clear();
                        controller.categoryImageName = "";
                        controller.categoryOldImage.value = "";

                        controller.catNameArController.clear();
                        controller.catNameEnController.clear();

                        if (value == "general") {
                          await controller.fetchCategoriesAll();
                        } else {
                          await controller.fetchSupers();
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            activeColor: Constants.primary,
                            title: Text("general_category".tr),
                            value: "general",
                          ),
                          RadioListTile<String>(
                            activeColor: Constants.primary,
                            title: Text("private_category".tr),
                            value: "private",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.categoryType.value == "general") {
                      return DropdownButtonFormField<int>(
                        initialValue:
                        controller.categoriesAll
                            .any((c) => c.id == controller.editingCategoryId.value)
                            ? controller.editingCategoryId.value
                            : null,
                        decoration: controller.greenDecoration(
                          "choose_general_category".tr,
                        ),
                        items: controller.categoriesAll.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(c.nameAr),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            final cat = controller.categoriesAll.firstWhere(
                              (c) => c.id == value,
                            );

                            controller.editingCategoryId.value = cat.id;
                            controller.isEditCategory.value = true;

                            controller.catNameArController.text = cat.nameAr;
                            controller.catNameEnController.text = cat.name;

                            controller.categoryOldImage.value = cat.image;
                            controller.categoryImageBytes.value = null;
                          }
                        },
                      );
                    } else {
                      return DropdownButtonFormField<int>(
                        initialValue:
                            controller.categories.any(
                              (c) => c.id == controller.editingCategoryId.value,
                            )
                            ? controller.editingCategoryId.value
                            : null,
                        decoration: controller.greenDecoration(
                          "choose_private_category".tr,
                        ),
                        items: controller.categories.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(c.nameAr),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            final cat = controller.categories.firstWhere(
                              (c) => c.id == value,
                            );

                            controller.isEditCategory.value = true;
                            controller.editingCategoryId.value = cat.id;

                            controller.catNameArController.text = cat.nameAr;
                            controller.catNameEnController.text = cat.name;

                            controller.categoryOldImage.value = cat.image;
                            controller.categoryImageBytes.value = null;
                          }
                        },
                      );
                    }
                  }),
                  const SizedBox(height: 15),
                  const SizedBox(height: 10),


                  controller.buildTextField(
                    controller: controller.catNameArController,
                    label: "category_name_ar".tr,
                  ),

                  const SizedBox(height: 15),

                  controller.buildTextField(
                    controller: controller.catNameEnController,
                    label: "category_name_en".tr,
                  ),

                  const SizedBox(height: 20),

                  controller.buildCategoryImagePicker(),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text("cancel".tr),
                      ),
                      const SizedBox(width: 15),
                      Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: controller.isAddingCategory.value
                              ? null
                              : controller.submitCategory,
                          child: controller.isAddingCategory.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  isEdit ? "update".tr : "save".tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAddProductDialog() async {
    await controller.fetchSupers();
    await controller.fetchCategoriesAll();

    Get.dialog(
      Dialog(
        backgroundColor: Constants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Constants.backgroundLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: Constants.greenGradientlight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "add_new_product".tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Constants.text,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// ROW 1 (اسم المنتج)
                  Row(
                    children: [
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.nameArController,
                          label: "product_name_ar".tr,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.nameEnController,
                          label: "product_name_en".tr,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// ROW 2 (وصف)
                  controller.buildTextField(
                    controller: controller.descArController,
                    label: "description_ar".tr,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  controller.buildTextField(
                    controller: controller.descEnController,
                    label: "description_en".tr,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  /// ROW 3 (السعر + الكمية + الخصم)
                  Row(
                    children: [
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.priceController,
                          label: "price_text".tr,
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.countController,
                          label: "quantity".tr,
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.discountController,
                          label: "discount_percent".tr,
                          keyboard: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  controller.buildCategoryAllDropdown(),

                  const SizedBox(height: 20),

                  // IMAGE UPLOAD
                  controller.buildImagePicker(),

                  const SizedBox(height: 30),

                  // BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          "cancel".tr,
                          style: const TextStyle(color: Constants.greyDark),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: controller.isAdding.value
                              ? null
                              : controller.submitAddProduct,
                          child: controller.isAdding.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "add_product".tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void showEditProductDialog(ProductModel product) async {


    /// تحميل القوائم أولاً
    await controller.fetchSupers();
    await controller.fetchCategoriesAll();
    if (product.superId != 0) {
      await controller.fetchCategoriesBySuper(product.superId);
    }

    /// تعبئة الحقول النصية
    controller.nameArController.text = product.nameAr;
    controller.nameEnController.text = product.nameEn;

    controller.descArController.text = product.descAr;
    controller.descEnController.text = product.descEn;

    controller.priceController.text = product.price.toString();
    controller.countController.text = product.count.toString();
    controller.discountController.text = product.discount.toString();

    /// تعيين القيم المختارة في القوائم المنسدلة
    controller.selectedSuperId.value = product.superId;
    controller.selectedCategoryId.value = product.catId;
    controller.selectedCategoryAllId.value = product.catAllId;

    /// الصورة القديمة
    controller.itemsOldImage.value = product.image;
    controller.imageBytes.value = null;
    controller.imageName = "";
    Get.dialog(
      Dialog(
        backgroundColor: Constants.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: Get.width < 600 ? Get.width * 0.95 : 600,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Constants.backgroundLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: Constants.greenGradientlight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "edit_product".tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Constants.text,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// الاسم
                  Row(
                    children: [
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.nameArController,
                          label: "product_name_ar".tr,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.nameEnController,
                          label: "product_name_en".tr,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// الوصف
                  controller.buildTextField(
                    controller: controller.descArController,
                    label: "description_ar".tr,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  controller.buildTextField(
                    controller: controller.descEnController,
                    label: "description_en".tr,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  /// السعر والكمية والخصم
                  Row(
                    children: [
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.priceController,
                          label: "price_text".tr,
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.countController,
                          label: "quantity".tr,
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.discountController,
                          label: "discount_percent".tr,
                          keyboard: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),


                  /// الفئة العامة
                  controller.buildCategoryAllDropdown(),

                  const SizedBox(height: 20),

                  /// الصورة
                  controller.buildImagePicker(),

                  const SizedBox(height: 30),

                  /// الأزرار
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text("cancel".tr),
                      ),

                      const SizedBox(width: 15),

                      Obx(
                            () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: controller.isAdding.value
                              ? null
                              : () => controller.submitUpdateProduct(product.id),
                          child: controller.isAdding.value
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            "update_product".tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showProductDetails(ProductModel product) {

    Get.dialog(

      Dialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: Container(
          width: Get.width < 600 ? Get.width * 0.95 : 650,
          padding: const EdgeInsets.all(25),

          decoration: BoxDecoration(
            color: Constants.backgroundLight,
            borderRadius: BorderRadius.circular(20),
          ),

          child: SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: Constants.greenGradientlight,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Center(
                    child: Text(
                      "product_details".tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Constants.text,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// IMAGE
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "${AppLink.imageItems}${product.image}",
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// NAME
                controller.buildInfo("name_ar_label".tr, product.nameAr),
                controller.buildInfo("name_en_label".tr, product.nameEn),

                const SizedBox(height: 10),

                /// DESCRIPTION
                controller.buildInfo("description_ar_label".tr, product.descAr),
                controller.buildInfo("description_en_label".tr, product.descEn),

                const SizedBox(height: 10),

                /// CATEGORY
                controller.buildInfo("category_label".tr, product.catAllAr),

                const SizedBox(height: 10),

                /// PRICE
                Row(
                  children: [

                    Expanded(
                      child: controller.buildInfo(
                        "price_label".tr,
                        "${(product.price / (1 - product.discount / 100)).round()}",
                      ),
                    ),

                    Expanded(
                      child: controller.buildInfo(
                        "discount_label".tr,
                        "${product.discount} %",
                      ),
                    ),

                    Expanded(
                      child: controller.buildInfo(
                        "price_after_discount_label".tr,
                        "${(product.price).round()}",
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 10),

                /// COUNT
                controller.buildInfo("quantity".tr, product.count.toString()),

                /// DATE
                controller.buildInfo("add_date_label".tr, product.date),

                const SizedBox(height: 30),

                /// BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      "close".tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
