class SuperMarket {
  final int id;
  final String nameEn;
  final String nameAr;
  final String image;

  SuperMarket({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.image,
  });

  factory SuperMarket.fromJson(Map<String, dynamic> json) {
    return SuperMarket(
      id: json['supermarket_id'],
      nameEn: json['supermarket_name'],
      nameAr: json['supermarket_name_ar'],
      image: json['supermarket_image'] ?? "",
    );
  }

  /// 🔥 يرجع الاسم حسب اللغة
  String getName(String langCode) {
    return langCode == 'ar' ? nameAr : nameEn;
  }
}