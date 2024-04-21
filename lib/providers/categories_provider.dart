import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/categories_model.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoriesModel> categories = [];
  List<CategoriesModel> get getCategories {
    return categories;
  }

  // Fetch products from firebase
  final productDb = FirebaseFirestore.instance.collection("categories");
  Future<List<CategoriesModel>> fetchCategories() async {
    try {
      await productDb.get().then((productSnapshot) {
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
        }
      });
      notifyListeners();
      // print(products);
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  final categoriesDb = FirebaseFirestore.instance.collection("categories");
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

  //count products in firebase
  final CollectionReference<Map<String, dynamic>> categoryList =
      FirebaseFirestore.instance.collection('categories');
  int? quer;
  Future<int?> countCategories() async {
    AggregateQuerySnapshot query = await categoryList.count().get();
    // debugPrint('The number of products: ${query.count}');
    quer = query.count;
    return query.count;
  }

//create function to delete category from firebase
  Future<void> deleteCategory(String categoryId) {
    return categoryList.doc(categoryId).delete();
  }

//create function to add category to firebase
  Future<void> addCategory(
      String categoryId, String categoryName, String categoryImage) {
    return categoryList.doc(categoryId).set({
      'categoryId': categoryId,
      'categoryName': categoryName,
      "categoryImage": categoryImage
    });
  }
}
