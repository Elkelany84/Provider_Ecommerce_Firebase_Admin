import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesModel {
  final String categoryId, categoryName
      // categoryImage
      ;

  CategoriesModel({
    required this.categoryId,
    required this.categoryName,
    // required this.categoryImage,
  });

  factory CategoriesModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    // data.containsKey("")
    return CategoriesModel(
      categoryId: data['categoryId'],
      categoryName: data['categoryName'],
      // categoryImage: data['categoryImage'],
    );
  }
}
