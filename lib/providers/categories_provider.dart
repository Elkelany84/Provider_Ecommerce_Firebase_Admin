import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/models/categories_model.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoriesModel> categories = [];
  List<CategoriesModel> get getCategories => categories;
  List<CategoriesModel> categoriesList = [];

  // Fetch products from firebase
  final categoriesDb = FirebaseFirestore.instance.collection("categories");
  Future<List<CategoriesModel>> fetchCategories() async {
    try {
      await categoriesDb
          .orderBy("createdAt", descending: true)
          .get()
          .then((productSnapshot) {
        categories.clear();
        for (var element in productSnapshot.docs) {
          categories.insert(0, CategoriesModel.fromFirestore(element)
              // ProductModel(
              //     productId: element.get("productId"),
              //     productTitle: element.get("productTitle"),
              //     productPrice: element.get("productPrice"),
              //     productCategory: element.get("productCategory"),
              //     productDescription: element.get("productDescription"),
              //     productImage: element.get("productImage"),
              //     productQuantity: "productQuantity")
              );
          categoriesList.insert(0, CategoriesModel.fromFirestore(element));
        }
      });
      notifyListeners();

      return categories;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<CategoriesModel>> fetchCategoryStream() {
    try {
      return categoriesDb.snapshots().map((snapshot) {
        categories.clear();
        for (var element in snapshot.docs) {
          categories.insert(0, CategoriesModel.fromFirestore(element)
              // ProductModel(
              //     productId: element.get("productId"),
              //     productTitle: element.get("productTitle"),
              //     productPrice: element.get("productPrice"),
              //     productCategory: element.get("productCategory"),
              //     productDescription: element.get("productDescription"),
              //     productImage: element.get("productImage"),
              //     productQuantity: "productQuantity")
              );
        }
        return categories;
      });
    } catch (e) {
      rethrow;
    }
  }
}
