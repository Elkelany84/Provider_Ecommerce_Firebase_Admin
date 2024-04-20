import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/categories_model.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoriesModel> categories = [];
  List<CategoriesModel> get getCategories {
    return categories;
  }

  // Fetch Categories from firebase
  final productDb = FirebaseFirestore.instance.collection("categories");
  Future<List<CategoriesModel>> fetchCategories() async {
    try {
      await productDb.get().then((productSnapshot) {
        categories.clear();
        for (var element in productSnapshot.docs) {
          categories.insert(0, CategoriesModel.fromFirestore(element));
        }
      });
      print(categories);
      notifyListeners();

      return categories;
    } catch (e) {
      rethrow;
    }
  }
}
