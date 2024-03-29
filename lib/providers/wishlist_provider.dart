import 'package:flutter/cupertino.dart';
import 'package:hadi_ecommerce_firebase_admin/models/wishlist_model.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class WishlistProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishlistItems = {};

  Map<String, WishListModel> get wishlistItems => _wishlistItems;

  // Add the product to the cart
  void addOrRemoveFromWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.putIfAbsent(
          productId,
          () => WishListModel(
                wishlistId: uuid.v4(),
                productId: productId,
              ));
    }

    // Notify listeners that the cart has changed
    notifyListeners();
  }

  //Check if The Product is in the cart
  bool isProductInWishlist({required String productId}) {
    return _wishlistItems.containsKey(productId);
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
