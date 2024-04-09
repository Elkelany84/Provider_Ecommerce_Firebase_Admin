import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  final String userId, userName, userEmail, userImage;
  final Timestamp createdAt;
  final List userCart, userWish;
  UserModel(
      {required this.createdAt,
      required this.userCart,
      required this.userWish,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.userImage});
}
