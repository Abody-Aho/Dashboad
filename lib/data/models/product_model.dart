class ProductModel {

  final int id;

  final String nameAr;
  final String nameEn;

  final String descAr;
  final String descEn;

  final String catAr;
  final String catEn;

  final String catAllAr;
  final String catAllEn;

  final int catId;
  final int catAllId;

  final String superAr;
  final String superEn;

  final int superId;

  final double price;
  final double priceAfterDiscount;
  final int count;
  final int discount;
  final int sales;

  final String date;
  final String image;

  ProductModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descAr,
    required this.descEn,
    required this.catAr,
    required this.catEn,
    required this.catId,
    required this.catAllId,
    required this.superAr,
    required this.superEn,
    required this.superId,
    required this.price,
    required this.priceAfterDiscount,
    required this.count,
    required this.discount,
    required this.sales,
    required this.date,
    required this.image, required this.catAllAr, required this.catAllEn,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {

    return ProductModel(

      id: int.parse(json["itmes_id"].toString()),

      nameAr: json["itmes_name_ar"] ?? '',
      nameEn: json["itmes_name"] ?? '',

      descAr: json["itmes_desc_ar"] ?? '',
      descEn: json["itmes_desc"] ?? '',

      catAr: json["categories_name_ar"] ?? '',
      catEn: json["categories_name"] ?? '',

      catAllAr: json["cat_ar"] ?? '',
      catAllEn: json["cat_en"] ?? '',

      catId: int.tryParse(json["itmes_cat"].toString()) ?? 0,
      catAllId: int.tryParse(json["itmes_cat_all"].toString()) ?? 0,

      superAr: json["supermarket_name_ar"] ?? '',
      superEn: json["supermarket_name"] ?? '',

      superId: int.tryParse(json["itmes_super"].toString()) ?? 0,

      price: double.tryParse(
          (json["itmes_price"]).toString()) ?? 0,
      
      priceAfterDiscount: double.tryParse((json["itemspricediscount"] ?? json["itemspricedisount"] ?? "0").toString()) ?? 0,

      count: int.tryParse(json["itmes_count"].toString()) ?? 0,

      discount: int.tryParse(json["itmes_discount"].toString()) ?? 0,

      sales: int.tryParse(json["sales"].toString()) ?? 0,

      date: json["itmes_date"].toString().split(" ").first,

      image: json["itmes_image"] ?? '',
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
