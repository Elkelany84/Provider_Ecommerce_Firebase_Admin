import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class WishListModel with ChangeNotifier {
  final String wishListId, productId;

  WishListModel({
    required this.wishListId,
    required this.productId,
  });
}
