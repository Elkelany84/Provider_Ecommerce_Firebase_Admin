import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class ViewedProdModel with ChangeNotifier {
  final String viewedProdId, productId;

  ViewedProdModel({
    required this.viewedProdId,
    required this.productId,
  });
}
