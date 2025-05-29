class BundleModel {
  String name;
  String cover;
  List<String> itemNames;
  double? price;
  double? mainPrice;
  bool isLocked = false; // 기본값을 false로 설정

  BundleModel({
    required this.name,
    required this.cover,
    required this.itemNames,
    required this.price,
    required this.mainPrice,
    required this.isLocked,
  });
}
