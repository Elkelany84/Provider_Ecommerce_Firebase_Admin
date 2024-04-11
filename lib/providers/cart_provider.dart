import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_admin/models/cart_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get cartItems => _cartItems;

  final usersDb = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;

  //add products to firebase
  Future<void> addToCartFirebase(
      {required String productId,
      required int quantity,
      required BuildContext context}) async {
    User? user = auth.currentUser;
    if (user == null) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context, fct: () {}, subTitle: "Please Login First!");
      return;
    }
    final uid = user.uid;
    final cartId = uuid.v4();
    try {
      await usersDb.doc(uid).update({
        "userCart": FieldValue.arrayUnion([
          {"cartId": cartId, "productId": productId, "quantity": quantity}
        ]),
      });
      Fluttertoast.showToast(msg: "Item Added To Cart");
    } catch (error) {}
    notifyListeners();
  }

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

  //Get Total Price
  double getTotal({required ProductsProvider productsProvider}) {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      final getCurrentProduct = productsProvider.findByProdId(value.productId);
      if (getCurrentProduct == null) {
        total += 0;
      } else {
        total += double.parse(getCurrentProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }

  //Get Whole Quantity
  int getQty() {
    var total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  void updateQty({required String productId, required int qty}) {
    _cartItems.update(
        productId,
        (cartItem) => CartModel(
            productId: productId, cartId: cartItem.cartId, quantity: qty));
    // _cartItems[productId]!.quantity++;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }
}
