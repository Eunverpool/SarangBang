import '../models/dummy_bundle_model.dart';
import '../models/dummy_product_model.dart';
import '../models/dummy_mainbundle_model.dart';

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
  static List<MainBundleModel> mainbundles = [
    MainBundleModel(
        name: '종합 보고서',
        cover: 'lib/core/constants/report.png',
        route: "/reportPage"),
    MainBundleModel(
        name: '대화하기',
        cover: 'lib/core/constants/chat.png',
        route: "/chat_page"),
    MainBundleModel(
        name: '어제의 일기',
        cover: 'lib/core/constants/diary.png',
        route: "/reportPage"),
  ];
  static List<BundleModel> bundles = [
    BundleModel(
      name: '귀여운 손녀',
      cover: 'https://i.postimg.cc/LXgqbpLy/990-4d81f90e9c4a.png',
      itemNames: ['캐릭터'],
      price: 5000,
      mainPrice: 0,
    ),
    BundleModel(
      name: '귀여운 손자',
      cover: 'https://i.postimg.cc/zGPGZQJ4/a5b-2ff48936406a.png',
      itemNames: ['캐릭터'],
      price: 10000,
      mainPrice: 0,
    ),
    BundleModel(
      name: '청소년',
      cover: 'https://i.postimg.cc/bvVP2SGM/a04-9c9269fc6047.png',
      itemNames: ['캐릭터'],
      price: 10000,
      mainPrice: 0,
    ),
    BundleModel(
      name: '성인',
      cover: 'https://i.postimg.cc/gk63S13t/040-a5c20a8f04ea.png',
      itemNames: ['캐릭터'],
      price: 35,
      mainPrice: 0,
    )
  ];
  static List<String> voices = [
    '귀여운 목소리',
    '차분한 목소리',
    '활기찬 목소리',
    '부드러운 목소리',
    '강렬한 목소리',
  ];
}
