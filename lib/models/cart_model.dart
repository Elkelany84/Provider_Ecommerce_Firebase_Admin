import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class CartModel with ChangeNotifier {
  final String productId, cartId;
  final int quantity;

  CartModel({
    required this.productId,
    required this.cartId,
    required this.quantity,
  });
}
