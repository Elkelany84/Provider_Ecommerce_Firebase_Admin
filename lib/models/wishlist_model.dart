import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class WishListModel with ChangeNotifier {
  final String wishlistId, productId;

  WishListModel({
    required this.wishlistId,
    required this.productId,
  });
}
