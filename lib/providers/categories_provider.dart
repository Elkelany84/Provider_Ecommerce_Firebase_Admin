import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/categories_model.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoryModel> categories = [];
  List<CategoryModel> get getCategories {
    return categories;
  }

  //Show Product and Product Details
  CategoryModel? findByCategoryId(String categoryId) {
    if (categories
        .where((element) => element.categoryId == categoryId)
        .isEmpty) {
      return null;
    }
    return categories.firstWhere((element) => element.categoryId == categoryId);
  }

  // Fetch products from firebase
  final productDb = FirebaseFirestore.instance.collection("categories");
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      await productDb.get().then((productSnapshot) {
        categories.clear();
        for (var element in productSnapshot.docs) {
          categories.insert(0, CategoryModel.fromFirestore(element)
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
  Stream<List<CategoryModel>> fetchCategoryStream() {
    try {
      return categoriesDb.snapshots().map((snapshot) {
        categories.clear();
        for (var element in snapshot.docs) {
          categories.insert(0, CategoryModel.fromFirestore(element)
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
    debugPrint('The number of products: ${query.count}');
    quer = query.count;
    notifyListeners();
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

  //create function to edit category in firebase
  // Future<void> editCategory(
  //     {categoryId, String categoryName, String categoryImage}) {
  //   return categoryList.doc(categoryId).update({
  //     'categoryId': categoryId,
  //     'categoryName': categoryName,
  //     "categoryImage": categoryImage
  //   });
  // }
}
