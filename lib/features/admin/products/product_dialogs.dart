import 'package:dashbord2/features/admin/products/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';
import '../../../data/models/product_model.dart';

mixin ProductDialogs on GetxController {
  ProductsController get controller;

  void showCategoryDialog() async {
    await controller.fetchSupers();
    await controller.fetchCategoriesAll();

    controller.isEditCategory.value = false;
    controller.resetCategoryForm();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Container(
          width: Get.width < 600 ? Get.width * 0.95 : 500,
          constraints: BoxConstraints(maxHeight: Get.height * 0.85),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Constants.backgroundLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: controller.categoryFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.category_rounded, color: Constants.primary, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            "add_new_category".tr,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Constants.text),
                          ),
                        ],
                      ),
                      // زر الانتقال لـ Dialog التعديل
                      TextButton.icon(
                        onPressed: () {
                          Get.back(); // إغلاق نافذة الإضافة
                          showEditCategoryDialog(); // فتح نافذة التعديل
                        },
                        icon: const Icon(Icons.edit, size: 18, color: Constants.primary),
                        label: const Text("تعديل فئة", style: TextStyle(color: Constants.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 15),

                  /// نوع الفئة
                  const Text("نوع الفئة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Obx(
                        () => Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            activeColor: Constants.primary,
                            title: Text("general_category".tr, style: const TextStyle(fontSize: 14)),
                            value: "general",
                            groupValue: controller.categoryType.value,
                            onChanged: (value) => _handleTypeChange(value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            activeColor: Constants.primary,
                            title: Text("private_category".tr, style: const TextStyle(fontSize: 14)),
                            value: "private",
                            groupValue: controller.categoryType.value,
                            onChanged: (value) => _handleTypeChange(value!),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// سوبرماركت إذا كانت الفئة خاصة
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

                  /// الحقول النصية
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

                  /// أداة التقاط الصور
                  controller.buildCategoryImagePicker(),
                  const SizedBox(height: 25),

                  /// أزرار الحفظ والإلغاء
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Get.back(),
                        child: Text("cancel".tr, style: const TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(width: 12),
                      Obx(
                            () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: controller.isAddingCategory.value ? null : controller.submitCategory,
                          child: controller.isAddingCategory.value
                              ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : Text("save".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  void showEditCategoryDialog() async {
    await controller.fetchSupers();
    await controller.fetchCategoriesAll();

    controller.isEditCategory.value = true;
    controller.resetCategoryForm(); // تصفير الحقول للبدء باختيار جديد

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Container(
          width: Get.width < 600 ? Get.width * 0.95 : 500,
          constraints: BoxConstraints(maxHeight: Get.height * 0.85),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Constants.backgroundLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: controller.categoryFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit_note_rounded, color: Constants.primary, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            "edit_category".tr,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Constants.text),
                          ),
                        ],
                      ),
                      // زر العودة للإضافة
                      TextButton.icon(
                        onPressed: () {
                          Get.back();
                          showCategoryDialog();
                        },
                        icon: const Icon(Icons.add, size: 18, color: Constants.primary),
                        label: Text("add_new_category".tr, style: const TextStyle(color: Constants.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 15),

                  /// نوع الفئة المراد تعديلها
                  const Text("نوع الفئة للتعديل", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Obx(
                        () => Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            activeColor: Constants.primary,
                            title: Text("general_category".tr, style: const TextStyle(fontSize: 14)),
                            value: "general",
                            groupValue: controller.categoryType.value,
                            onChanged: (value) => _handleTypeChange(value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            activeColor: Constants.primary,
                            title: Text("private_category".tr, style: const TextStyle(fontSize: 14)),
                            value: "private",
                            groupValue: controller.categoryType.value,
                            onChanged: (value) => _handleTypeChange(value!),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// Dropdown لاختيار الفئة المراد تعديلها
                  Obx(() {
                    bool isGeneral = controller.categoryType.value == "general";
                    List<dynamic> list = isGeneral ? controller.categoriesAll : controller.categories;

                    return DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: list.any((dynamic c) => c.id == controller.editingCategoryId.value)
                          ? controller.editingCategoryId.value
                          : null,
                      decoration: controller.greenDecoration(
                        isGeneral ? "choose_general_category".tr : "choose_private_category".tr,
                      ).copyWith(
                        prefixIcon: const Icon(Icons.search, color: Constants.primary),
                      ),
                      items: list.map((dynamic c) {
                        return DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(c.nameAr),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          final dynamic cat = list.firstWhere((dynamic c) => c.id == value);
                          controller.isEditCategory.value = true;
                          controller.editingCategoryId.value = cat.id;
                          controller.catNameArController.text = cat.nameAr;
                          controller.catNameEnController.text = cat.name;
                          controller.categoryOldImage.value = cat.image;
                          controller.categoryImageBytes.value = null;
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 15),

                  /// سوبرماركت إذا كانت الفئة خاصة
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

                  /// الحقول النصية للتعديل
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

                  /// أداة التقاط الصور
                  controller.buildCategoryImagePicker(),
                  const SizedBox(height: 25),

                  /// أزرار الحفظ والإلغاء
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Get.back(),
                        child: Text("cancel".tr, style: const TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(width: 12),
                      Obx(
                            () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: controller.isAddingCategory.value ? null : controller.submitCategory,
                          child: controller.isAddingCategory.value
                              ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : Text("update".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
  /// دالة مساعدة لتنظيف الكود ومعالجة تغيير النوع داخل الـ Dialog
  void _handleTypeChange(String value) async {
    controller.categoryType.value = value;
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
                                  style: const TextStyle(color: Constants.white),
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
    controller.priceAfterController.text = product.priceAfterDiscount.toString();
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
                            style: const TextStyle(color: Constants.white),
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
                controller.buildInfo("category_label".tr, product.catAr),

                /// SUPERMARKET
                controller.buildInfo("supermarket_label".tr, product.superAr),

                const SizedBox(height: 10),

                /// PRICE
                Row(
                  children: [

                    Expanded(
                      child: controller.buildInfo(
                        "price_label".tr,
                        "${(product.price).round()}",
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
                        "${(product.priceAfterDiscount).round()}",
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

  void showSuperSearchDialog() {
    TextEditingController search = TextEditingController();
    RxList filtered = controller.supers.toList().obs;

    Get.dialog(
      Dialog(
        // جعل خلفية الدايلوج شفافة لنتمكن من التحكم بالحواف والظلال في الـ Container
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          height: 450, // زيادة طفيفة لراحة بصرية أكبر
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24), // حواف دائرية عصرية
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان للنافذة يضفي لمسة احترافية
              const Padding(
                padding: EdgeInsets.only(bottom: 12.0, right: 4.0),
                child: Text(
                  "اختيار السوبرماركت",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // حقل البحث المطور
              TextField(
                controller: search,
                decoration: InputDecoration(
                  hintText: "ابحث عن سوبرماركت",
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.05), // خلفية خفيفة ناعمة
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none, // إخفاء الحدود التقليدية
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.green, width: 1.5),
                  ),
                ),
                onChanged: (val) {
                  filtered.value = controller.supers.where((s) {
                    return s.nameAr
                        .toLowerCase()
                        .contains(val.toLowerCase());
                  }).toList();
                },
              ),
              const SizedBox(height: 16),

              // قائمة النتائج
              Expanded(
                child: Obx(() => ListView.builder(
                  physics: const BouncingScrollPhysics(), // حركة ارتدادية ناعمة
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final item = filtered[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.storefront, color: Colors.green, size: 20),
                        ),
                        title: Text(
                          item.nameAr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 14),
                        onTap: () {
                          controller.selectedSuperId.value = item.id;

                          /// نفس منطقك 👇
                          controller.selectedCategoryId.value = null;
                          controller.categories.clear();
                          controller.fetchCategoriesBySuper(item.id);

                          Get.back();
                        },
                      ),
                    );
                  },
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
