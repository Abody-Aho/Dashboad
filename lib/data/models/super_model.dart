class SuperModel {
  final int id;
  final String name;
  final String nameAr;

  SuperModel({
    required this.id,
    required this.name,
    required this.nameAr,
  });

  factory SuperModel.fromJson(Map<String, dynamic> json) {
    return SuperModel(
      id: int.tryParse(json['supermarket_id'].toString()) ?? 0,
      name: json['supermarket_name'] ?? '',
      nameAr: json['supermarket_name_ar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "supermarket_id": id,
      "supermarket_name": name,
      "supermarket_name_ar": nameAr,
    };
  }
}