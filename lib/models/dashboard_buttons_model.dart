import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/edit_upload_product_form.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/orders/orders_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/search_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/assets_manager.dart';

class DashboardButtonsModel {
  final Function onPressed;
  final String imagePath;
  final String text;

  DashboardButtonsModel(
      {required this.onPressed, required this.imagePath, required this.text});

  //we add context so we can use navigator
  static List<DashboardButtonsModel> dashboardBtnsList(context) => [
        DashboardButtonsModel(
            text: "Add a New Product",
            imagePath: AssetsManager.cloud,
            onPressed: () {
              Navigator.pushNamed(context, EditOrUploadProductForm.routeName);
            }),
        DashboardButtonsModel(
            text: "Inspect All Products",
            imagePath: AssetsManager.shoppingCart,
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            }),
        DashboardButtonsModel(
            text: "View Orders",
            imagePath: AssetsManager.order,
            onPressed: () {
              Navigator.pushNamed(context, OrdersScreenFree.routeName);
            }),
      ];
}
