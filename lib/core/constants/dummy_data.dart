import '../models/dummy_bundle_model.dart';
import '../models/dummy_product_model.dart';

class Dummy {
  /// List Of Dummy Products
  static List<ProductModel> products = [
    ProductModel(
      name: 'Perry\'s Ice Cream Banana',
      weight: '800 gm',
      cover: 'https://i.imgur.com/6unJlSL.png',
      images: ['https://i.imgur.com/6unJlSL.png'],
      price: 13,
      mainPrice: 15,
    ),
    ProductModel(
      name: 'Vanilla Ice Cream Banana',
      weight: '500 gm',
      cover: 'https://i.imgur.com/oaCY49b.png',
      images: ['https://i.imgur.com/oaCY49b.png'],
      price: 12,
      mainPrice: 15,
    ),
    ProductModel(
      name: 'Meat',
      weight: '1 Kg',
      cover: 'https://i.imgur.com/5wghZji.png',
      images: ['https://i.imgur.com/5wghZji.png'],
      price: 15,
      mainPrice: 18,
    ),
  ];

  /// List Of Dummy Bundles
  static List<BundleModel> mainbundles = [
    BundleModel(
      name: '종합 보고서',
      cover: 'https://i.imgur.com/Y0IFT2g.png',
    ),
    BundleModel(
      name: '대화하기',
      cover: 'https://i.postimg.cc/qtM4zj1K/packs-2.png',
    ),
    BundleModel(
      name: '어제의 일기',
      cover: 'https://i.postimg.cc/MnwW8WRd/pack-1.png',
    ),
  ];
}
