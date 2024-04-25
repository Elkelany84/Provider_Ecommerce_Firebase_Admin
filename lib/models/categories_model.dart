import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesModel extends ChangeNotifier {
  final String id, name, image;

  CategoriesModel({required this.id, required this.name, required this.image});

  factory CategoriesModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
// data.containsKey("")
    return CategoriesModel(
//doc.get(field),
      id: data['categoryId'],
      name: data['categoryName'],
      image: data['categoryImage'],
    );
  }
}
