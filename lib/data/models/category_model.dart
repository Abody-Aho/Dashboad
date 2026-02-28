class CategoryModel {
  final int id;
  final String name;
  final String nameAr;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: int.tryParse(json['categories_id'].toString()) ?? 0,
      name: json['categories_name'] ?? '',
      nameAr: json['categories_name_ar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "categories_id": id,
      "categories_name": name,
      "categories_name_ar": nameAr,
    };
  }
}