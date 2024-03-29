import 'package:flutter/cupertino.dart';
import 'package:hadi_ecommerce_firebase_admin/models/viewed_products.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class ViewedProdProvider with ChangeNotifier {
  final Map<String, ViewedProdModel> _viewedProdsItems = {};

  Map<String, ViewedProdModel> get viewedProdsItems => _viewedProdsItems;

  // Add the product to the cart
  void addViewedProd({required String productId}) {
    _viewedProdsItems.putIfAbsent(
        productId,
        () => ViewedProdModel(
              viewedProdId: uuid.v4(),
              productId: productId,
            ));
  }

  notifyListeners();

  //clear viewed products
  void clearViewedProds() {
    _viewedProdsItems.clear();
    notifyListeners();
  }
}
