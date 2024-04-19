import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrdersModelAdvanced with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String productTitle;
  final String userName;
  final String totalPrice;
  final String imageUrl;
  final String quantity;
  final String sessionId;
  final Timestamp orderDate;

  OrdersModelAdvanced(
      {required this.orderId,
      required this.userId,
      required this.productId,
      required this.productTitle,
      required this.userName,
      required this.totalPrice,
      required this.imageUrl,
      required this.quantity,
      required this.sessionId,
      required this.orderDate});
}

class OrderSummary with ChangeNotifier {
  // final String orderId;
  final String userId;

  final String totalPrice;

  final String totalProducts;
  final String sessionId;
  final Timestamp orderDate;

  OrderSummary(
      {
      // required this.orderId,
      required this.userId,
      required this.totalPrice,
      required this.totalProducts,
      required this.sessionId,
      required this.orderDate});
}
