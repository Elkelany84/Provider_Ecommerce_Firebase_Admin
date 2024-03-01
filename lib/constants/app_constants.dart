import 'package:hadi_ecommerce_firebase_admin/models/categories_model.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';

class AppConstants {
  static const String imageUrl =
      "https://images.unsplash.com/photo-1465572089651-8fde36c892dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80";

  static List<String> bannerImages = [
    AssetsManager.banner1,
    AssetsManager.banner2
  ];

  static List<CategoriesModel> categoriesList = [
    CategoriesModel(id: "1", name: "Phones", image: AssetsManager.mobiles),
    CategoriesModel(id: "2", name: "Clothes", image: AssetsManager.fashion),
    CategoriesModel(id: "3", name: "Watches", image: AssetsManager.watch),
    CategoriesModel(id: "4", name: "Books", image: AssetsManager.book),
    CategoriesModel(
        id: "5", name: "Electronics", image: AssetsManager.electronics),
    CategoriesModel(id: "6", name: "Cosmetics", image: AssetsManager.cosmetics),
    CategoriesModel(id: "7", name: "Shoes", image: AssetsManager.shoes),
    CategoriesModel(id: "8", name: "LapTops", image: AssetsManager.pc)
  ];
}
