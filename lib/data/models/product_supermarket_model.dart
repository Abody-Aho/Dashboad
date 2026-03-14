class AddSupermarketProductModel {
  final String nameAr;
  final String nameEn;
  final String descAr;
  final String descEn;
  final double price;
  final int count;
  final int discount;
  final int catAllId;
  final int superId;
  final String imagePath;

  AddSupermarketProductModel({
    required this.nameAr,
    required this.nameEn,
    required this.descAr,
    required this.descEn,
    required this.price,
    required this.count,
    required this.discount,
    required this.catAllId,
    required this.superId,
    required this.imagePath,
  });
}
