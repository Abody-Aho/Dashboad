class CategoryAllModel {
  final int id;
  final String name;
  final String nameAr;

  CategoryAllModel({
    required this.id,
    required this.name,
    required this.nameAr,
  });

  factory CategoryAllModel.fromJson(Map<String, dynamic> json) {
    return CategoryAllModel(
      id: int.tryParse(json['categories_all_id'].toString()) ?? 0,
      name: json['categories_all_name'] ?? '',
      nameAr: json['categories_all_name_ar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "categories_all_id": id,
      "categories_all_name": name,
      "categories_all_name_ar": nameAr,
    };
  }
}