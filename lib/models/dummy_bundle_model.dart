class BundleModel {
  final String name;
  final String cover;
  final List<String> itemNames;
  final double? price; // double → double? (nullable)
  final double? mainPrice; // double → double? (nullable)
  final bool isLocked;

  BundleModel({
    required this.name,
    required this.cover,
    required this.itemNames,
    this.price, // required 제거
    this.mainPrice, // required 제거
    this.isLocked = false,
  });
}
