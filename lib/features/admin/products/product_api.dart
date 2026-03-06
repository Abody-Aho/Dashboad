import 'dart:convert';
import 'package:dashbord2/features/admin/products/products_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';
import '../../../data/models/category_all_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/super_model.dart';

mixin ProductApi on GetxController {
  ProductsController get controller;

  // تنفيذ البحث في الجدول
  Future<void> searchQuery(String query) async {
    if (query.isEmpty) {
      await controller.fetchProducts();
      return;
    }
    try {
      controller.isLoading.value = true;

      final response = await http.get(
        Uri.parse("${AppLink.itemsSearch}?query=${Uri.encodeComponent(query)}"),
      );

      final body = jsonDecode(response.body);

      if (body["status"]) {
        final List items = body["data"];

        controller.dataList.assignAll(
          items
              .map<ProductModel>((item) => ProductModel.fromJson(item))
              .toList(),
        );

        controller.filteredDataList.assignAll(controller.dataList);
      }
    } finally {
      controller.isLoading.value = false;
    }
  }

  // تحميل بيانات  المنتجات

  Future<void> fetchSupers() async {
    final response = await http.get(Uri.parse(AppLink.supersView));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        controller.supers.assignAll(
          (body["data"] as List).map((e) => SuperModel.fromJson(e)).toList(),
        );
      }
    }
  }

  Future<void> submitCategory() async {
    if (!controller.isEditCategory.value &&
        controller.categoryImageBytes.value == null) {
      Get.snackbar("تنبيه", "يرجى اختيار صورة للفئة");
      return;
    }
    if (!controller.categoryFormKey.currentState!.validate()) return;

    if (controller.categoryType.value == "private" &&
        controller.selectedSuperId.value == null) {
      Get.snackbar("تنبيه", "اختر السوبرماركت");
      return;
    }

    controller.isAddingCategory.value = true;

    try {
      final url = controller.isEditCategory.value
          ? (controller.categoryType.value == "general"
                ? AppLink.updateCategoryAll
                : AppLink.updateCategoryPrivate)
          : (controller.categoryType.value == "general"
                ? AppLink.addCategoryAll
                : AppLink.addCategoryPrivate);

      var request = http.MultipartRequest("POST", Uri.parse(url));

      request.fields.addAll({
        "name_ar": controller.catNameArController.text.trim(),
        "name_en": controller.catNameEnController.text.trim(),
        if (controller.categoryType.value == "private")
          "super": controller.selectedSuperId.value.toString(),
        if (controller.isEditCategory.value)
          "id": controller.editingCategoryId.value.toString(),
      });

      if (controller.categoryImageBytes.value != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "image",
            controller.categoryImageBytes.value!,
            filename: controller.categoryImageName,
          ),
        );
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      final body = jsonDecode(responseData.body);

      if (body["status"] == "success") {
        Get.back();
        controller.resetCategoryForm();
        await fetchCategoriesAll();
        Get.snackbar("نجاح", "تمت العملية بنجاح");
      } else {
        Get.snackbar("خطأ", body["message"] ?? "فشل العملية");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الإرسال");
    } finally {
      controller.isAddingCategory.value = false;
    }
  }

  Future<void> fetchCategoriesAll() async {
    final response = await http.get(Uri.parse(AppLink.categoriesAll));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        controller.categoriesAll.assignAll(
          (body["data"] as List)
              .map((e) => CategoryAllModel.fromJson(e))
              .toList(),
        );
      }
    }
  }

  Future<void> submitAddProduct() async {
    if (!controller.formKey.currentState!.validate()) return;

    if (controller.selectedSuperId.value == null ||
        controller.selectedCategoryId.value == null ||
        controller.selectedCategoryAllId.value == null) {
      Get.snackbar(
        "تنبيه",
        "يرجى اختيار جميع الحقول",
        backgroundColor: Constants.warning,
        colorText: Colors.white,
      );
      return;
    }

    if (controller.imageBytes.value == null) {
      Get.snackbar(
        "تنبيه",
        "يرجى اختيار صورة للمنتج",
        backgroundColor: Constants.warning,
        colorText: Colors.white,
      );
      return;
    }

    controller.isAdding.value = true;

    try {
      // إنشاء مودل الإضافة
      final product = AddProductModel(
        nameAr: controller.nameArController.text.trim(),
        nameEn: controller.nameEnController.text.trim(),
        descAr: controller.descArController.text.trim(),
        descEn: controller.descEnController.text.trim(),
        price: double.tryParse(controller.priceController.text) ?? 0,
        count: int.tryParse(controller.countController.text) ?? 0,
        discount: int.tryParse(controller.discountController.text) ?? 0,
        catId: controller.selectedCategoryId.value!,
        catAllId: controller.selectedCategoryAllId.value!,
        superId: controller.selectedSuperId.value!,
        imagePath: controller.imagePath.value,
      );

      // إنشاء الطلب
      var request = http.MultipartRequest("POST", Uri.parse(AppLink.addItem));

      // إضافة الحقول
      request.fields.addAll({
        "name_ar": product.nameAr,
        "name_en": product.nameEn,
        "desc_ar": product.descAr,
        "desc_en": product.descEn,
        "price": product.price.toString(),
        "count": product.count.toString(),
        "discount": product.discount.toString(),
        "cat": product.catId.toString(),
        "cat_all": product.catAllId.toString(),
        "super": product.superId.toString(),
      });

      // إضافة الصورة
      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          controller.imageBytes.value!,
          filename: controller.imageName,
        ),
      );

      /// إرسال الطلب
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      final body = jsonDecode(responseData.body);

      if (body["status"] == "success") {
        await controller.fetchProducts(); // تحديث الجدول

        controller.resetAddForm(); // إعادة ضبط الحقول

        Get.back();

        Get.snackbar(
          "نجاح",
          "تمت إضافة المنتج بنجاح",
          backgroundColor: Constants.success,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(15),
        );
      } else {
        Get.snackbar(
          "خط",
          body["status"] ?? "فشل في الإضافة",
          backgroundColor: Constants.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الإرسال",
        backgroundColor: Constants.error,
        colorText: Colors.white,
      );
    } finally {
      controller.isAdding.value = false;
    }
  }

  Future<void> fetchCategoriesBySuper(int superId) async {
    final response = await http.post(
      Uri.parse(AppLink.categoriesBySuper),
      body: {"super": superId.toString()},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        controller.categories.assignAll(
          (body["data"] as List).map((e) => CategoryModel.fromJson(e)).toList(),
        );
      }
    }
  }

  Future<void> submitAddCategory() async {
    if (!controller.categoryFormKey.currentState!.validate()) return;

    if (controller.categoryType.value == "private" &&
        controller.selectedSuperId.value == null) {
      Get.snackbar(
        "تنبيه",
        "يرجى اختيار السوبرماركت",
        backgroundColor: Constants.warning,
        colorText: Colors.white,
      );
      return;
    }

    controller.isAddingCategory.value = true;

    try {
      final url = controller.categoryType.value == "general"
          ? AppLink.addCategoryAll
          : AppLink.addCategoryPrivate;

      final response = await http.post(
        Uri.parse(url),
        body: {
          "name_ar": controller.catNameArController.text.trim(),
          "name_en": controller.catNameEnController.text.trim(),
          if (controller.categoryType.value == "private")
            "super": controller.selectedSuperId.value.toString(),
        },
      );

      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        Get.back();
        controller.resetCategoryForm();

        Get.snackbar(
          "نجاح",
          "تمت إضافة الفئة بنجاح",
          backgroundColor: Constants.success,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "خطأ",
          "فشل في الإضافة",
          backgroundColor: Constants.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الإرسال",
        backgroundColor: Constants.error,
        colorText: Colors.white,
      );
    } finally {
      controller.isAddingCategory.value = false;
    }
  }

  Future<void> submitUpdateProduct(int id) async {

    if (!controller.formKey.currentState!.validate()) return;

    controller.isAdding.value = true;

    try {

      var request =
      http.MultipartRequest("POST", Uri.parse(AppLink.updateItem));

      request.fields.addAll({
        "id": id.toString(),
        "name_ar": controller.nameArController.text.trim(),
        "name_en": controller.nameEnController.text.trim(),
        "desc_ar": controller.descArController.text.trim(),
        "desc_en": controller.descEnController.text.trim(),
        "price": controller.priceController.text.trim(),
        "count": controller.countController.text.trim(),
        "discount": controller.discountController.text.trim(),
        "cat": controller.selectedCategoryId.value.toString(),
        "cat_all": controller.selectedCategoryAllId.value.toString(),
        "super": controller.selectedSuperId.value.toString(),
      });

      // إضافة الصورة فقط إذا تم تغييرها
      if (controller.imageBytes.value != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "image",
            controller.imageBytes.value!,
            filename: controller.imageName,
          ),
        );
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      final body = jsonDecode(responseData.body);

      if (body["status"] == "success") {

        await controller.fetchProducts();

        Get.back();

        Get.snackbar(
          "نجاح",
          "تم تحديث المنتج بنجاح",
          backgroundColor: Constants.success,
          colorText: Colors.white,
        );

      } else {

        Get.snackbar(
          "خطأ",
          "فشل تحديث المنتج",
          backgroundColor: Constants.error,
          colorText: Colors.white,
        );
      }

    } catch (e) {

      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الاتصال بالسيرفر",
        backgroundColor: Constants.error,
        colorText: Colors.white,
      );

    } finally {

      controller.isAdding.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {

    try {

      final response = await http.post(
        Uri.parse(AppLink.deleteItem),
        body: {"id": id.toString()},
      );

      if (response.statusCode != 200) {
        Get.snackbar(
          "خطأ",
          "فشل الاتصال بالسيرفر",
          backgroundColor: Constants.error,
          colorText: Colors.white,
        );
        return;
      }

      final body = jsonDecode(response.body);

      /// نجاح الحذف
      if (body["status"] == "success") {

        await controller.fetchProducts();

        Get.snackbar(
          "تم الحذف",
          "تم حذف المنتج بنجاح",
          backgroundColor: Constants.success,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          borderRadius: 10,
          margin: const EdgeInsets.all(15),
        );

      }

      /// فشل من السيرفر
      else {

        Get.snackbar(
          "فشل الحذف",
          body["message"] ?? "لم يتم حذف المنتج",
          backgroundColor: Constants.error,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          borderRadius: 10,
          margin: const EdgeInsets.all(15),
        );
      }

    }

    /// خطأ اتصال
    catch (e) {

      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الاتصال بالسيرفر",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
        borderRadius: 10,
        margin: const EdgeInsets.all(15),
      );
    }
  }
}
