class ProductModel {
  final String nameAr;
  final String nameEn;

  final String catAr;
  final String catEn;

  final String superAr;
  final String superEn;

  final double price;
  final int count;
  final int sales;
  final String date;

  ProductModel({
    required this.nameAr,
    required this.nameEn,
    required this.catAr,
    required this.catEn,
    required this.superAr,
    required this.superEn,
    required this.price,
    required this.count,
    required this.sales,
    required this.date,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      nameAr: json["itmes_name_ar"] ?? '',
      nameEn: json["itmes_name"] ?? '',

      catAr: json["categories_name_ar"] ?? '',
      catEn: json["categories_name"] ?? '',

      superAr: json["supermarket_name_ar"] ?? '',
      superEn: json["supermarket_name"] ?? '',

      price: double.tryParse(
          (json["itemspricedisount"] ?? json["itmes_price"]).toString()) ??
          0.0,

      count: int.tryParse(json["itmes_count"].toString()) ?? 0,
      sales: int.tryParse(json["sales"].toString()) ?? 0,

      date: json["itmes_date"].toString().split(" ").first,
    );
  }
}
class AddProductModel {
  final String nameAr;
  final String nameEn;
  final String descAr;
  final String descEn;
  final double price;
  final int count;
  final int discount;
  final int catId;
  final int catAllId;
  final int superId;
  final String imagePath;

  AddProductModel({
    required this.nameAr,
    required this.nameEn,
    required this.descAr,
    required this.descEn,
    required this.price,
    required this.count,
    required this.discount,
    required this.catId,
    required this.catAllId,
    required this.superId,
    required this.imagePath,
  });
}