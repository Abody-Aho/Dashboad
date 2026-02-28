import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';
import '../../../data/models/category_all_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/super_model.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class ProductsController extends GetxController {

  final nameArController = TextEditingController();
  final nameEnController = TextEditingController();
  final descArController = TextEditingController();
  final descEnController = TextEditingController();
  final priceController = TextEditingController();
  final countController = TextEditingController();
  final discountController = TextEditingController();

  RxString imagePath = "".obs;
  var isLoading = false.obs;                         // حالة التحميل

  RxList<bool> selectedRows = <bool>[].obs;          // حالة التحديد لكل صف

  RxInt sortColumnIndex = 0.obs;                     // العمود المفعل للفرز
  RxBool sortAscending = true.obs;                   // اتجاه الفرز (تصاعدي / تنازلي)
  final searchTextController = TextEditingController(); // متحكم حقل البحث
  var dataList = <ProductModel>[].obs;
  var filteredDataList = <ProductModel>[].obs;
  final formKey = GlobalKey<FormState>();

  RxBool isAdding = false.obs;
  Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);
  String imageName = "";
  Rx<SuperModel?> selectedSuper = Rx<SuperModel?>(null);
  Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  Rx<CategoryAllModel?> selectedCategoryAll = Rx<CategoryAllModel?>(null);
  // القوائم القادمة من API
  var supers = <SuperModel>[].obs;
  var categories = <CategoryModel>[].obs;
  var categoriesAll = <CategoryAllModel>[].obs;

  // عند إنشاء الكنترولر يتم تحميل البيانات مباشرة
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void showAddProductDialog() async {
    await fetchSupers();
    await fetchCategoriesAll();

    Get.dialog(
      Dialog(
        backgroundColor: Constants.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Constants.backgroundLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: formKey,
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

                  /// ROW 1 (اسم عربي + اسم انجليزي)
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: nameArController,
                          label: "اسم المنتج (عربي)",
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTextField(
                          controller: nameEnController,
                          label: "اسم المنتج (English)",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// ROW 2 (وصف)
                  _buildTextField(
                    controller: descArController,
                    label: "الوصف بالعربي",
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  _buildTextField(
                    controller: descEnController,
                    label: "Description (English)",
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  /// ROW 3 (السعر + الكمية + الخصم)
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: priceController,
                          label: "السعر",
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTextField(
                          controller: countController,
                          label: "الكمية",
                          keyboard: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTextField(
                          controller: discountController,
                          label: "الخصم %",
                          keyboard: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildSuperDropdown(),
                  const SizedBox(height: 15),

                  _buildCategoryDropdown(),
                  const SizedBox(height: 15),

                  _buildCategoryAllDropdown(),

                  const SizedBox(height: 20),

                  /// IMAGE UPLOAD
                  _buildImagePicker(),

                  const SizedBox(height: 30),

                  /// BUTTONS
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
                      Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isAdding.value ? null : submitAddProduct,
                        child: isAdding.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text("إضافة المنتج",style: TextStyle(color: Constants.white),),
                      )),
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
  Widget _buildTextField({
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
      decoration: _greenDecoration(label),
    );
  }
  Widget _buildImagePicker() {
    return Obx(() => Column(
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
            FilePickerResult? result =
            await FilePicker.platform.pickFiles(
              type: FileType.image,
              withData: true,
            );

            if (result != null) {
              imageBytes.value = result.files.first.bytes;
              imageName = result.files.first.name;
            }
          },
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Constants.greyLight),
            ),
            child: imageBytes.value == null
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload,
                      size: 40, color: Constants.grey),
                  SizedBox(height: 8),
                  Text("اضغط لاختيار صورة"),
                ],
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                imageBytes.value!,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ],
    ));
  }
  Widget _buildSuperDropdown() {
    return Obx(() => DropdownButtonFormField<SuperModel>(
      initialValue: selectedSuper.value,
      decoration: _greenDecoration("اختر السوبرماركت"),
      items: supers.map((s) {
        return DropdownMenuItem(
          value: s,
          child: Text(s.nameAr),
        );
      }).toList(),
      onChanged: (value) {
        selectedSuper.value = value;
        selectedCategory.value = null;
        categories.clear();
        fetchCategoriesBySuper(value!.id);
      },
      validator: (value) =>
      value == null ? "الرجاء اختيار السوبرماركت" : null,
    ));
  }

  Widget _buildCategoryDropdown() {
    return Obx(() => DropdownButtonFormField<CategoryModel>(
      initialValue: selectedCategory.value,
      decoration: _greenDecoration("الفئة الخاصة"),
      items: categories.map((c) {
        return DropdownMenuItem(
          value: c,
          child: Text(c.nameAr),
        );
      }).toList(),
      onChanged: (value) => selectedCategory.value = value,
      validator: (value) =>
      value == null ? "اختر الفئة الخاصة" : null,
    ));
  }
  Widget _buildCategoryAllDropdown() {
    return Obx(() => DropdownButtonFormField<CategoryAllModel>(
      initialValue: selectedCategoryAll.value,
      decoration: _greenDecoration("الفئة العامة"),
      items: categoriesAll.map((c) {
        return DropdownMenuItem(
          value: c,
          child: Text(c.nameAr),
        );
      }).toList(),
      onChanged: (value) =>
      selectedCategoryAll.value = value,
      validator: (value) =>
      value == null ? "اختر الفئة العامة" : null,
    ));
  }
  InputDecoration _greenDecoration(String label) {
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
        borderSide:
        const BorderSide(color: Constants.primary, width: 2),
      ),
    );
  }

  Future<void> fetchSupers() async {
    final response = await http.get(Uri.parse(AppLink.supersView));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        supers.assignAll(
          (body["data"] as List)
              .map((e) => SuperModel.fromJson(e))
              .toList(),
        );
      }
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
        categories.assignAll(
          (body["data"] as List)
              .map((e) => CategoryModel.fromJson(e))
              .toList(),
        );
      }
    }
  }

  Future<void> fetchCategoriesAll() async {
    final response =
    await http.get(Uri.parse(AppLink.categoriesAll));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        categoriesAll.assignAll(
          (body["data"] as List)
              .map((e) => CategoryAllModel.fromJson(e))
              .toList(),
        );
      }
    }
  }

  Future<void> submitAddProduct() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedSuper.value == null ||
        selectedCategory.value == null ||
        selectedCategoryAll.value == null) {
      Get.snackbar(
        "تنبيه",
        "يرجى اختيار جميع الحقول",
        backgroundColor: Constants.warning,
        colorText: Colors.white,
      );
      return;
    }

    if (imageBytes.value == null) {
      Get.snackbar(
        "تنبيه",
        "يرجى اختيار صورة للمنتج",
        backgroundColor: Constants.warning,
        colorText: Colors.white,
      );
      return;
    }

    isAdding.value = true;

    try {
      /// إنشاء مودل الإضافة
      final product = AddProductModel(
        nameAr: nameArController.text.trim(),
        nameEn: nameEnController.text.trim(),
        descAr: descArController.text.trim(),
        descEn: descEnController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0,
        count: int.tryParse(countController.text) ?? 0,
        discount: int.tryParse(discountController.text) ?? 0,
        catId: selectedCategory.value!.id,
        catAllId: selectedCategoryAll.value!.id,
        superId: selectedSuper.value!.id,
        imagePath: imagePath.value,
      );

      /// إنشاء الطلب
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(AppLink.addItem),
      );

      /// إضافة الحقول
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
          imageBytes.value!,
          filename: imageName,
        ),
      );

      /// إرسال الطلب
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      final body = jsonDecode(responseData.body);

      if (body["status"] == "success") {
        await fetchProducts(); // تحديث الجدول

        _resetAddForm(); // إعادة ضبط الحقول

        Get.back();

        Get.snackbar(
          "نجاح",
          "تمت إضافة المنتج بنجاح",
          backgroundColor: Constants.success,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
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
      isAdding.value = false;
    }
  }

  void _resetAddForm() {
    nameArController.clear();
    nameEnController.clear();
    descArController.clear();
    descEnController.clear();
    priceController.clear();
    countController.clear();
    discountController.clear();

    selectedSuper.value = null;
    selectedCategory.value = null;
    selectedCategoryAll.value = null;
    imageBytes.value = null;
    imageName = "";

  }

  // إنشاء خلايا البيانات الخاصة بكل صف في الجدول
  List<DataCell> getDataCells(ProductModel data) {
    final isArabic = Get.locale?.languageCode == 'ar';
    return [
      _textCell(isArabic ? data.nameAr : data.nameEn, 150),
      _textCell(isArabic ? data.catAr : data.catEn, 140),
      _textCell(data.price.toString(), 80),
      _textCell(data.count.toString(), 80),
      _textCell(isArabic ? data.superAr : data.superEn, 140),
      _textCell(_availability(data.count), 120),
      _textCell(data.sales.toString(), 80),
      _textCell(data.date, 120),
      DataCell(
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.grey, size: 25),
                  padding: EdgeInsets.zero,
                  onPressed: () => print('View '),
                  tooltip: 'view'.tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                  padding: EdgeInsets.zero,
                  onPressed: () => print('Edit'),
                  tooltip: 'edit'.tr,
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                  padding: EdgeInsets.zero,
                  onPressed: () => print('Delete'),
                  tooltip: 'delete'.tr,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
  DataCell _textCell(String? text, double width) {
    return DataCell(
      Tooltip(
        message: text ?? '-',
        child: SizedBox(
          width: width,
          child: Text(
            text ?? '-',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  // تعريف أعمدة الجدول مع دعم الفرز
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: Text('product_name'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),
    DataColumn(
      label: Text('category'.tr),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),
    DataColumn(
      label: Text('price'.tr),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),
    DataColumn(
      label: Text('stock'.tr),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),
    DataColumn(
      label: Text('supermarket'.tr),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),
    DataColumn(
      label: Text('availability'.tr),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),
    DataColumn(
      label: Text('sales'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),
    DataColumn(
      label: Text('last_update'.tr),
      onSort: (columnIndex, ascending) => sortData(7, ascending),
    ),
    DataColumn(
      label: Text('actions'.tr),
      onSort: (columnIndex, ascending) => sortData(8, ascending),
    ),
  ];

  // تنفيذ عملية الفرز حسب العمود المختار
  void sortData(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredDataList.sort((a, b) {
      int result;

      switch (columnIndex) {
        case 0:
          result = a.nameEn.compareTo(b.nameEn);
          break;
        case 1:
          result = a.catEn.compareTo(b.catEn);
          break;
        case 2:
          result = a.price.compareTo(b.price);
          break;
        case 3:
          result = a.count.compareTo(b.count);
          break;
        case 4:
          result = a.superEn.compareTo(b.superEn);
          break;
        case 5:
          result = _availability(a.count).compareTo(_availability(b.count));
          break;
        case 6:
          result = a.sales.compareTo(b.sales);
          break;
        case 7:
          result = a.date.compareTo(b.date);
          break;
        default:
          result = 0;
      }

      return ascending ? result : -result;
    });

    filteredDataList.refresh();
  }

  // تنفيذ البحث في الجدول
  Future<void> searchQuery(String query) async {
    if (query.isEmpty) {
      await fetchProducts();
      return;
    }
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse("${AppLink.itemsSearch}?query=${Uri.encodeComponent(query)}"),
      );

      final body = jsonDecode(response.body);

      if (body["status"]) {
        final List items = body["data"];

        dataList.assignAll(
          items.map<ProductModel>((item) => ProductModel.fromJson(item)).toList(),
        );

        filteredDataList.assignAll(dataList);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // تحميل بيانات تجريبية للمستخدمين
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final response = await http.get(Uri.parse(AppLink.itemsAdminView));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          final List items = body['data'];

          dataList.assignAll(
            items.map<ProductModel>((item) => ProductModel.fromJson(item)).toList(),
          );

          filteredDataList.assignAll(dataList);
          selectedRows.assignAll(List.generate(filteredDataList.length, (_) => false));
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  String _availability(int count) {
    if (count == 0) return "غير متوفر";
    if (count < 10) return "مخزون منخفض";
    return "متوفر";
  }

  final selectedValue = 'all_status'.obs;
  final options = ['all_status','available', 'not_available'];

  // عند التغيير
  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  final selectedCategories = 'all_categories'.obs;
  final List<String> supermarketCategories = [
    'all_categories',
    'bakery',
    'dairy',
    'grains',
    'fruits',
    'vegetables',
    'meat',
    'drinks',
    'detergents',
  ];

  // عند التغيير
  void changeCategories(String newValue) {
    selectedCategories.value = newValue;
  }
}
