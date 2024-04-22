import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CategoryModel extends ChangeNotifier {
  final String categoryId, categoryName, categoryImage;
  final Timestamp createdAt;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.createdAt,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    // data.containsKey("")
    return CategoryModel(
      categoryId: data['categoryId'],
      categoryName: data['categoryName'],
      categoryImage: data['categoryImage'],
      createdAt: data['createdAt'],
    );
  }
}
