import 'package:dashbord2/features/admin/products/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';
import '../../../data/models/product_model.dart';

mixin ProductDialogs on GetxController {
  ProductsController get controller;

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
                        isEdit ? "تعديل الفئة" : "إضافة فئة جديدة",
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
                        children: const [
                          RadioListTile<String>(
                            activeColor: Constants.primary,
                            title: Text("فئة عامة"),
                            value: "general",
                          ),
                          RadioListTile<String>(
                            activeColor: Constants.primary,
                            title: Text("فئة خاصة بسوبرماركت"),
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
                          "اختر فئة عامة للتعديل",
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
                          "اختر فئة خاصة للتعديل",
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

                  // سوبرماركت إذا خاصة
                  Obx(() {
                    if (controller.categoryType.value == "private") {
                      return Column(
                        children: [
                          controller.buildSuperDropdown(),
                          const SizedBox(height: 15),
                        ],
                      );
                    }
                    return const SizedBox();
                  }),

                  controller.buildTextField(
                    controller: controller.catNameArController,
                    label: "اسم الفئة (عربي)",
                  ),

                  const SizedBox(height: 15),

                  controller.buildTextField(
                    controller: controller.catNameEnController,
                    label: "اسم الفئة (English)",
                  ),

                  const SizedBox(height: 20),

                  controller.buildCategoryImagePicker(),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("إلغاء"),
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
                                  isEdit ? "تحديث" : "حفظ",
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
                    child: const Center(
                      child: Text(
                        "إضافة منتج جديد",
                        style: TextStyle(
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
                          label: "اسم المنتج (عربي)",
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.nameEnController,
                          label: "اسم المنتج (English)",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// ROW 2 (وصف)
                  controller.buildTextField(
                    controller: controller.descArController,
                    label: "الوصف بالعربي",
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  controller.buildTextField(
                    controller: controller.descEnController,
                    label: "Description (English)",
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  /// ROW 3 (السعر + الكمية + الخصم)
                  Row(
                    children: [
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.priceController,
                          label: "السعر",
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.countController,
                          label: "الكمية",
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.discountController,
                          label: "الخصم %",
                          keyboard: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  controller.buildSuperDropdown(),
                  const SizedBox(height: 15),

                  controller.buildCategoryDropdown(),
                  const SizedBox(height: 15),

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
                        child: const Text(
                          "إلغاء",
                          style: TextStyle(color: Constants.greyDark),
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
                              : const Text(
                                  "إضافة المنتج",
                                  style: TextStyle(color: Constants.white),
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
                    child: const Center(
                      child: Text(
                        "تعديل المنتج",
                        style: TextStyle(
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
                          label: "اسم المنتج (عربي)",
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.nameEnController,
                          label: "اسم المنتج (English)",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// الوصف
                  controller.buildTextField(
                    controller: controller.descArController,
                    label: "الوصف بالعربي",
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  controller.buildTextField(
                    controller: controller.descEnController,
                    label: "Description (English)",
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  /// السعر والكمية والخصم
                  Row(
                    children: [
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.priceController,
                          label: "السعر",
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.countController,
                          label: "الكمية",
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: controller.buildTextField(
                          controller: controller.discountController,
                          label: "الخصم %",
                          keyboard: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// السوبرماركت
                  controller.buildSuperDropdown(),

                  const SizedBox(height: 15),

                  /// الفئة الخاصة
                  controller.buildCategoryDropdown(),

                  const SizedBox(height: 15),

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
                        child: const Text("إلغاء"),
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
                              : const Text(
                            "تحديث المنتج",
                            style: TextStyle(color: Constants.white),
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

                  child: const Center(
                    child: Text(
                      "تفاصيل المنتج",
                      style: TextStyle(
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
                      "${AppLink.imageItems}/${product.image}",
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// NAME
                controller.buildInfo("الاسم بالعربي : ", product.nameAr),
                controller.buildInfo("Name (English) : ", product.nameEn),

                const SizedBox(height: 10),

                /// DESCRIPTION
                controller.buildInfo("الوصف بالعربي : ", product.descAr),
                controller.buildInfo("Description : ", product.descEn),

                const SizedBox(height: 10),

                /// CATEGORY
                controller.buildInfo("الفئة : ", product.catAr),

                /// SUPERMARKET
                controller.buildInfo("السوبرماركت : ", product.superAr),

                const SizedBox(height: 10),

                /// PRICE
                Row(
                  children: [

                    Expanded(
                      child: controller.buildInfo(
                        "السعر : ",
                        "${(product.price / (1 - product.discount / 100)).round()}",
                      ),
                    ),

                    Expanded(
                      child: controller.buildInfo(
                        " الخصم : ",
                        "${product.discount} %",
                      ),
                    ),

                    Expanded(
                      child: controller.buildInfo(
                        "السعر بعد الخصم : ",
                        "${(product.price).round()}",
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 10),

                /// COUNT
                controller.buildInfo("الكمية : ", product.count.toString()),

                /// DATE
                controller.buildInfo("تاريخ الإضافة : ", product.date),

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
    );
  }
}
