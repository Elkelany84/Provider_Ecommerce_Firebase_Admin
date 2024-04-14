import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderUserModel extends ChangeNotifier {
  final String userId, userName, userEmail, userPhone, userAddress, userImage;
  final Timestamp createdAt;
  final List userCart, userWish;
  OrderUserModel({
    required this.userPhone,
    required this.userAddress,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.createdAt,
    required this.userCart,
    required this.userWish,
    required this.userImage,
  });
}
