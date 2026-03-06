import 'package:dashbord2/features/admin/products/product_api.dart';
import 'package:dashbord2/features/admin/products/product_dialogs.dart';
import 'package:dashbord2/features/admin/products/product_helpers.dart';
import 'package:dashbord2/features/admin/products/product_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/category_all_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/super_model.dart';
import 'dart:typed_data';

class ProductsController extends GetxController with ProductApi, ProductDialogs, ProductHelpers, ProductTable{

  @override
  ProductsController get controller => this;


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

  var selectedSuperId = RxnInt();
  var selectedCategoryId = RxnInt();
  var selectedCategoryAllId = RxnInt();
  // القوائم القادمة من API
  var supers = <SuperModel>[].obs;
  var categories = <CategoryModel>[].obs;
  var categoriesAll = <CategoryAllModel>[].obs;
  // ===== Category Add Controllers =====
  final catNameArController = TextEditingController();
  final catNameEnController = TextEditingController();

  RxString categoryType = "general".obs; // general | private
  RxBool isAddingCategory = false.obs;
  final categoryFormKey = GlobalKey<FormState>();
  RxBool isEditCategory = false.obs;
  RxnInt editingCategoryId = RxnInt();

  Rx<Uint8List?> categoryImageBytes = Rx<Uint8List?>(null);
  String categoryImageName = "";
  RxString categoryOldImage = "".obs;
  RxString itemsOldImage = "".obs;
  // عند إنشاء الكنترولر يتم تحميل البيانات مباشرة
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void resetCategoryForm() {
    catNameArController.clear();
    catNameEnController.clear();
    selectedSuperId.value = null;
    categoryType.value = "general";

    categoryImageBytes.value = null;
    categoryImageName = "";
    categoryOldImage.value = "";
    isEditCategory.value = false;
    editingCategoryId.value = null;
  }

  void resetAddForm() {
    nameArController.clear();
    nameEnController.clear();
    descArController.clear();
    descEnController.clear();
    priceController.clear();
    countController.clear();
    discountController.clear();

    selectedSuperId.value = null;
    selectedCategoryId.value = null;
    selectedCategoryAllId.value = null;
    imageBytes.value = null;
    imageName = "";

  }
  void resetDialogState() {

    /// ----------- Product -----------
    nameArController.clear();
    nameEnController.clear();
    descArController.clear();
    descEnController.clear();
    priceController.clear();
    countController.clear();
    discountController.clear();
    itemsOldImage.value = "";

    selectedSuperId.value = null;
    selectedCategoryId.value = null;
    selectedCategoryAllId.value = null;

    imageBytes.value = null;
    imageName = "";
    imagePath.value = "";

    /// ----------- Category -----------
    catNameArController.clear();
    catNameEnController.clear();

    categoryType.value = "general";
    categoryImageBytes.value = null;
    categoryImageName = "";
    categoryOldImage.value = "";

    isEditCategory.value = false;
    editingCategoryId.value = null;

    /// ----------- Lists -----------
    categories.clear();

  }

  // إنشاء خلايا البيانات الخاصة بكل صف في الجدول


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
