import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class ProductModel extends ChangeNotifier {
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productImage,
      productQuantity;

  Timestamp? createdAt;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    this.createdAt,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    // data.containsKey("")
    return ProductModel(
      //doc.get(field),
      productId: data['productId'],
      productTitle: data['productTitle'],
      productPrice: data['productPrice'],
      productCategory: data['productCategory'],
      productDescription: data['productDescription'],
      productImage: data['productImage'],
      productQuantity: data['productQuantity'], createdAt: data['createdAt'],
    );
  }
}
