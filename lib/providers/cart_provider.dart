import 'package:flutter/cupertino.dart';
import 'package:hadi_ecommerce_firebase_admin/models/cart_model.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get cartItems => _cartItems;

  // Add the product to the cart
  void addToCart({required String productId}) {
    _cartItems.putIfAbsent(productId,
        () => CartModel(productId: productId, cartId: uuid.v4(), quantity: 1));
    // Notify listeners that the cart has changed
    notifyListeners();
  }

  //Check if The Product is in the cart
  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  //Remove Item From Cart
  void removeFromCart(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }
}
