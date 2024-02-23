import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EmptyBag(
      imagePath: AssetsManager.shoppingBasket,
      title: "Whoops",
      subtile: "Your Cart Is Empty!",
      details: "Looks Like Your Cart is Empty,Start Shopping!",
      buttonText: "Shop now",
    ));
  }
}
