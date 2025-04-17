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
  static List<BundleModel> bundles = [
    BundleModel(
      name: '귀여운 손녀',
      cover: 'https://i.postimg.cc/LXgqbpLy/990-4d81f90e9c4a.png',
      itemNames: ['Onion, Oil, Salt'],
      price: 35,
      mainPrice: 50.32,
    ),
    BundleModel(
      name: '귀여운 손자',
      cover: 'https://i.postimg.cc/zGPGZQJ4/a5b-2ff48936406a.png',
      itemNames: ['Onion, Oil, Salt'],
      price: 35,
      mainPrice: 50.32,
    ),
    BundleModel(
      name: '청소년',
      cover: 'https://i.postimg.cc/bvVP2SGM/a04-9c9269fc6047.png',
      itemNames: ['Onion, Oil, Salt'],
      price: 35,
      mainPrice: 50.32,
    ),
    BundleModel(
      name: '성인',
      cover: 'https://i.postimg.cc/gk63S13t/040-a5c20a8f04ea.png',
      itemNames: ['Onion, Oil, Salt'],
      price: 35,
      mainPrice: 50.32,
    ),
  ];
}
